import 'dart:convert';

import 'package:flutter_fusioncharts/src/bridge/fusion_charts_bridge.dart';
import 'package:flutter_fusioncharts/src/bridge/fusion_charts_protocol.dart';
import 'package:flutter_fusioncharts/src/export/fusion_charts_export.dart';
import 'package:flutter_fusioncharts/src/source/fusion_charts_source.dart';
import 'package:flutter_test/flutter_test.dart';

import 'fakes/fake_webview_host.dart';

/// Decodes the envelope out of a `window.__fcBridgeReceive("...")` call.
Map<String, dynamic> envelopeOf(String script) {
  final int open = script.indexOf('(');
  final int close = script.lastIndexOf(')');
  final String literal = script.substring(open + 1, close);
  return jsonDecode(jsonDecode(literal) as String) as Map<String, dynamic>;
}

FusionChartsBridge makeBridge(FakeWebViewHost host) => FusionChartsBridge(
      chartId: 'fc-test1',
      host: host,
      scriptLoader: () async => '/* bridge */',
    );

void main() {
  group('envelope encoding', () {
    test('carries protocol version, chart id, type and payload', () {
      final String encoded = FusionChartsMessage(
        type: FusionChartsOutbound.render,
        chartId: 'fc-test1',
        payload: <String, dynamic>{'type': 'column2d'},
      ).encode();

      expect(jsonDecode(encoded), <String, dynamic>{
        'protocolVersion': 1,
        'chartId': 'fc-test1',
        'type': 'render',
        'payload': <String, dynamic>{'type': 'column2d'},
      });
    });

    test('omits requestId when absent and includes it when present', () {
      final Map<String, dynamic> without = jsonDecode(FusionChartsMessage(
        type: FusionChartsOutbound.update,
        chartId: 'fc-test1',
      ).encode()) as Map<String, dynamic>;
      expect(without.containsKey('requestId'), isFalse);

      final Map<String, dynamic> with_ = jsonDecode(FusionChartsMessage(
        type: FusionChartsOutbound.update,
        chartId: 'fc-test1',
        requestId: 'r1',
      ).encode()) as Map<String, dynamic>;
      expect(with_['requestId'], 'r1');
    });

    test('rejects an unknown outbound type', () {
      expect(
        () =>
            FusionChartsMessage(type: 'evaluate', chartId: 'fc-test1').encode(),
        throwsA(isA<FusionChartsProtocolError>()),
      );
    });

    test('rejects a malformed chart id', () {
      expect(
        () => FusionChartsMessage(
          type: FusionChartsOutbound.render,
          chartId: 'window.alert(1)',
        ).encode(),
        throwsA(isA<FusionChartsProtocolError>()),
      );
    });

    test('rejects an oversized payload rather than truncating it', () {
      expect(
        () => FusionChartsMessage(
          type: FusionChartsOutbound.render,
          chartId: 'fc-test1',
          payload: <String, dynamic>{
            'blob': 'x' * (FusionChartsMessage.maxEncodedLength + 1),
          },
        ).encode(),
        throwsA(isA<FusionChartsProtocolError>()),
      );
    });
  });

  group('injection resistance', () {
    // Each of these terminated a string literal or closed a script tag in the
    // 1.x implementation, which built JavaScript by interpolation.
    const Map<String, String> hostile = <String, String>{
      'single quote': "it's",
      'double quote': 'say "hi"',
      'backslash': r'C:\path\to',
      'script close': '</script><script>alert(1)</script>',
      'line separator': '\u2028\u2029',
      'null byte': 'a\u0000b',
      'template literal': r'${alert(1)}',
      'chart terminator': '"});alert(1);//',
    };

    hostile.forEach((String label, String value) {
      test('$label survives a round trip as data, not code', () {
        final String encoded = FusionChartsMessage(
          type: FusionChartsOutbound.render,
          chartId: 'fc-test1',
          payload: <String, dynamic>{
            'dataSource': <String, dynamic>{'caption': value},
          },
        ).encode();

        final Map<String, dynamic> decoded =
            jsonDecode(encoded) as Map<String, dynamic>;
        final Map<String, dynamic> ds = (decoded['payload']
            as Map<String, dynamic>)['dataSource'] as Map<String, dynamic>;
        expect(ds['caption'], value);
      });
    });

    test('license key is never concatenated into script source', () async {
      final FakeWebViewHost host = FakeWebViewHost();
      final FusionChartsBridge bridge = makeBridge(host);
      await bridge.attach();
      host.completePageLoad();
      await pumpEventQueue();
      host.clear();

      // The emitted script is `window.__fcBridgeReceive("...")`, so the only
      // breakout vector is an unescaped double quote or backslash. A single
      // quote is inert inside a double-quoted literal and JSON does not escape
      // it, so asserting on single quotes would test nothing.
      const String key = r'leak");alert("pwned");//\';
      await bridge.send(FusionChartsMessage(
        type: FusionChartsOutbound.render,
        chartId: 'fc-test1',
        payload: <String, dynamic>{'licenseKey': key},
      ));

      final String script = host.executedScripts.single;

      // A substring check would be meaningless here: the correctly escaped
      // form `\");alert(` still *contains* `");alert(`. The property that
      // actually matters is that the argument is one well-formed JSON string
      // literal, which is only possible if the payload never terminated it.
      expect(script.startsWith('window.__fcBridgeReceive("'), isTrue);
      expect(script.endsWith('");'), isTrue);

      final String literal =
          script.substring(script.indexOf('(') + 1, script.lastIndexOf(')'));
      final Object? outer = jsonDecode(literal);
      expect(outer, isA<String>(),
          reason: 'the argument must be a single intact string literal');
      expect(jsonDecode(outer as String), isA<Map<String, dynamic>>());

      // And the key must survive intact as data.
      expect(envelopeOf(script)['payload']['licenseKey'], key);
    });
  });

  group('inbound validation', () {
    test('accepts a well-formed event envelope', () {
      final FusionChartsMessage message =
          FusionChartsMessage.decodeInbound(jsonEncode(<String, dynamic>{
        'protocolVersion': 1,
        'chartId': 'fc-test1',
        'type': 'event',
        'payload': <String, dynamic>{'eventName': 'dataPlotClick'},
      }));
      expect(message.type, FusionChartsInbound.event);
      expect(message.payload['eventName'], 'dataPlotClick');
    });

    test('rejects a mismatched protocol version', () {
      expect(
        () => FusionChartsMessage.decodeInbound(jsonEncode(<String, dynamic>{
          'protocolVersion': 99,
          'chartId': 'fc-test1',
          'type': 'event',
        })),
        throwsA(isA<FusionChartsProtocolError>()),
      );
    });

    test('rejects non-JSON, non-object and unknown-type input', () {
      expect(() => FusionChartsMessage.decodeInbound('not json'),
          throwsA(isA<FusionChartsProtocolError>()));
      expect(() => FusionChartsMessage.decodeInbound('[1,2,3]'),
          throwsA(isA<FusionChartsProtocolError>()));
      expect(
        () => FusionChartsMessage.decodeInbound(jsonEncode(<String, dynamic>{
          'protocolVersion': 1,
          'chartId': 'fc-test1',
          'type': 'render',
        })),
        throwsA(isA<FusionChartsProtocolError>()),
        reason: 'render is outbound-only and must not be accepted inbound',
      );
    });
  });

  group('inbound routing', () {
    test('routes a valid export payload to onExport', () {
      final FakeWebViewHost host = FakeWebViewHost();
      final FusionChartsBridge bridge = makeBridge(host);
      FusionChartsExport? received;
      bridge.onExport = (FusionChartsExport export) => received = export;

      bridge.handleInbound(jsonEncode(<String, dynamic>{
        'protocolVersion': 1,
        'chartId': 'fc-test1',
        'type': 'export',
        'payload': <String, dynamic>{
          'format': 'png',
          'mime': 'image/png',
          'fileName': 'chart.png',
          'base64': base64Encode(<int>[1, 2, 3]),
        },
      }));

      expect(received, isNotNull);
      expect(received!.format, 'png');
      expect(received!.bytes, <int>[1, 2, 3]);
    });

    test('reports export-empty for a payload with no bytes or text', () {
      final FakeWebViewHost host = FakeWebViewHost();
      final FusionChartsBridge bridge = makeBridge(host);
      String? code;
      bridge.onError = (String value, String message) => code = value;

      bridge.handleInbound(jsonEncode(<String, dynamic>{
        'protocolVersion': 1,
        'chartId': 'fc-test1',
        'type': 'export',
        'payload': <String, dynamic>{'format': 'png'},
      }));

      expect(code, 'export-empty');
    });

    test('accepts the exact FusionCharts runtime version', () async {
      final FakeWebViewHost host = FakeWebViewHost();
      final FusionChartsBridge bridge = makeBridge(host);
      await bridge.load(FusionChartsSource.asset());
      String? errorCode;
      bool ready = false;
      bridge.onError = (String code, String message) => errorCode = code;
      bridge.onReady = () => ready = true;

      bridge.handleInbound(jsonEncode(<String, dynamic>{
        'protocolVersion': 1,
        'chartId': 'fc-test1',
        'type': 'ready',
        'payload': <String, dynamic>{'fusionChartsVersion': '4.2.2'},
      }));

      expect(errorCode, isNull);
      expect(ready, isTrue);
    });

    test('rejects a different FusionCharts runtime version', () async {
      final FakeWebViewHost host = FakeWebViewHost();
      final FusionChartsBridge bridge = makeBridge(host);
      await bridge.load(FusionChartsSource.asset());
      String? code;
      bridge.onError = (String value, String message) => code = value;

      bridge.handleInbound(jsonEncode(<String, dynamic>{
        'protocolVersion': 1,
        'chartId': 'fc-test1',
        'type': 'ready',
        'payload': <String, dynamic>{'fusionChartsVersion': '4.2.1'},
      }));

      expect(code, 'runtime-version-mismatch');
    });
  });

  group('event name validation', () {
    test('accepts ordinary FusionCharts event names', () {
      expect(FusionChartsMessage.isValidEventName('dataPlotClick'), isTrue);
      expect(FusionChartsMessage.isValidEventName('renderComplete'), isTrue);
    });

    test('rejects names carrying quotes or separators', () {
      for (final String bad in <String>[
        "click','x')//",
        'a b',
        '',
        'click;alert(1)',
        '2fast',
      ]) {
        expect(FusionChartsMessage.isValidEventName(bad), isFalse,
            reason: 'should reject "$bad"');
      }
    });
  });

  group('source configuration (offline assets only)', () {
    test('asset mode is the only runtime mode', () {
      expect(FusionChartsSourceMode.values, <FusionChartsSourceMode>[
        FusionChartsSourceMode.asset,
      ]);
    });

    test('isLocal: true maps to the asset source', () {
      expect(FusionChartsSource.fromIsLocal(true).mode,
          FusionChartsSourceMode.asset);
    });

    test('isLocal: false throws instead of reaching the network', () {
      expect(() => FusionChartsSource.fromIsLocal(false),
          throwsA(isA<FusionChartsSourceError>()));
    });

    test('the isLocal: false message carries migration guidance', () {
      const String m = FusionChartsSource.unsupportedIsLocalFalseMessage;
      expect(m, contains('not supported in 2.0'));
      expect(m, contains('Remove isLocal: false'));
      expect(m, contains('assets bundled with this package'));
      expect(m, contains('FusionChartsSource.asset'));
    });

    test('an http or https assetKey is rejected', () {
      for (final String bad in <String>[
        'https://cdn.fusioncharts.com/fusioncharts/4.2.2/index.html',
        'http://example.com/page.html',
        '//example.com/page.html',
      ]) {
        expect(() => FusionChartsSource.asset(assetKey: bad),
            throwsA(isA<FusionChartsSourceError>()),
            reason: 'should reject "$bad"');
      }
    });

    test('the default asset is the package-owned page (packageAsset defaults)',
        () {
      // FusionCharts 4.2.2 and all eight themes ship inside this package, so a
      // consuming app needs no FusionCharts assets and makes no network request.
      expect(FusionChartsSource.asset().assetKey,
          'packages/flutter_fusioncharts/assets/bridge/fc_page.html');
      expect(FusionChartsSource.asset().version, '4.2.2');
      expect(FusionChartsSource.fromIsLocal(true).assetKey,
          FusionChartsSource.packageAsset);
    });

    test('a plain asset key is accepted', () {
      expect(FusionChartsSource.asset(assetKey: 'fc/index.html').assetKey,
          'fc/index.html');
    });

    test('rejects a floating "latest" version literal', () {
      expect(() => FusionChartsSource.asset(version: 'latest'),
          throwsA(isA<FusionChartsSourceError>()));
    });
  });
}
