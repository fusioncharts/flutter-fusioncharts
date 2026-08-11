import 'package:flutter_fusioncharts/flutter_fusioncharts.dart';
import 'package:flutter_fusioncharts/src/bridge/fusion_charts_bridge.dart';
import 'package:flutter_fusioncharts/src/bridge/fusion_charts_protocol.dart';
import 'package:flutter_test/flutter_test.dart';

import 'bridge_message_test.dart' show envelopeOf;
import 'fakes/fake_webview_host.dart';

FusionChartsBridge makeBridge(FakeWebViewHost host) => FusionChartsBridge(
      chartId: 'fc-test1',
      host: host,
      scriptLoader: () async => '/* bridge */',
    );

void main() {
  group('readiness queueing', () {
    test('messages sent before the page loads are held, not dropped', () async {
      final FakeWebViewHost host = FakeWebViewHost();
      final FusionChartsBridge bridge = makeBridge(host);
      await bridge.attach();

      await bridge.send(FusionChartsMessage(
          type: FusionChartsOutbound.render, chartId: 'fc-test1'));
      await bridge.send(FusionChartsMessage(
          type: FusionChartsOutbound.update, chartId: 'fc-test1'));

      expect(bridge.isReady, isFalse);
      expect(host.bridgeEnvelopes, isEmpty);
      expect(bridge.pendingMessages, hasLength(2));
    });

    test('queued messages flush in order once the page loads', () async {
      final FakeWebViewHost host = FakeWebViewHost();
      final FusionChartsBridge bridge = makeBridge(host);
      await bridge.attach();

      await bridge.send(FusionChartsMessage(
          type: FusionChartsOutbound.render, chartId: 'fc-test1'));
      await bridge.send(FusionChartsMessage(
          type: FusionChartsOutbound.addEvents,
          chartId: 'fc-test1',
          payload: <String, dynamic>{
            'events': <String>['renderComplete']
          }));

      host.completePageLoad();
      await pumpEventQueue();

      expect(bridge.isReady, isTrue);
      expect(bridge.pendingMessages, isEmpty);
      final List<String> types = host.bridgeEnvelopes
          .map((String s) => envelopeOf(s)['type'] as String)
          .toList();
      expect(types, <String>['render', 'addEvents']);
    });

    test('the bridge script is injected before any envelope', () async {
      final FakeWebViewHost host = FakeWebViewHost();
      final FusionChartsBridge bridge = makeBridge(host);
      await bridge.attach();
      await bridge.send(FusionChartsMessage(
          type: FusionChartsOutbound.render, chartId: 'fc-test1'));
      host.completePageLoad();
      await pumpEventQueue();

      expect(host.executedScripts.first, '/* bridge */');
    });

    test('messages sent after readiness dispatch immediately', () async {
      final FakeWebViewHost host = FakeWebViewHost();
      final FusionChartsBridge bridge = makeBridge(host);
      await bridge.attach();
      host.completePageLoad();
      await pumpEventQueue();
      host.clear();

      await bridge.send(FusionChartsMessage(
          type: FusionChartsOutbound.update, chartId: 'fc-test1'));
      expect(host.bridgeEnvelopes, hasLength(1));
    });
  });

  group('inbound routing', () {
    test('delivers events for this chart', () async {
      final FakeWebViewHost host = FakeWebViewHost();
      final FusionChartsBridge bridge = makeBridge(host);
      String? seenName;
      bridge.onEvent = (String name, String? sender, Map<String, dynamic> a) {
        seenName = name;
      };
      await bridge.attach();
      host.completePageLoad();
      await pumpEventQueue();

      host.emitMessage('{"protocolVersion":1,"chartId":"fc-test1",'
          '"type":"event","payload":{"eventName":"dataPlotClick"}}');
      expect(seenName, 'dataPlotClick');
    });

    test('ignores traffic addressed to a different chart', () async {
      final FakeWebViewHost host = FakeWebViewHost();
      final FusionChartsBridge bridge = makeBridge(host);
      String? seenName;
      bridge.onEvent = (String name, String? s, Map<String, dynamic> a) {
        seenName = name;
      };
      await bridge.attach();
      host.completePageLoad();
      await pumpEventQueue();

      host.emitMessage('{"protocolVersion":1,"chartId":"fc-other",'
          '"type":"event","payload":{"eventName":"dataPlotClick"}}');
      expect(seenName, isNull);
    });

    test('reports malformed inbound text as a structured error', () async {
      final FakeWebViewHost host = FakeWebViewHost();
      final FusionChartsBridge bridge = makeBridge(host);
      final List<String> codes = <String>[];
      bridge.onError = (String code, String message) => codes.add(code);
      await bridge.attach();
      host.completePageLoad();
      await pumpEventQueue();

      host.emitMessage('<<not json>>');
      expect(codes, contains('invalid-inbound'));
    });

    test('surfaces WebView resource errors', () async {
      final FakeWebViewHost host = FakeWebViewHost();
      final FusionChartsBridge bridge = makeBridge(host);
      final List<String> codes = <String>[];
      bridge.onError = (String code, String message) => codes.add(code);
      await bridge.attach();

      host.emitError('net::ERR_FAILED', code: -1);
      expect(codes, contains('webview-error'));
    });
  });

  group('disposal', () {
    test('sends dispose and releases the host', () async {
      final FakeWebViewHost host = FakeWebViewHost();
      final FusionChartsBridge bridge = makeBridge(host);
      await bridge.attach();
      host.completePageLoad();
      await pumpEventQueue();
      host.clear();

      await bridge.dispose();

      expect(envelopeOf(host.bridgeEnvelopes.single)['type'], 'dispose');
      expect(host.disposed, isTrue);
    });

    test('is idempotent and silently ignores later sends', () async {
      final FakeWebViewHost host = FakeWebViewHost();
      final FusionChartsBridge bridge = makeBridge(host);
      await bridge.attach();
      host.completePageLoad();
      await pumpEventQueue();
      await bridge.dispose();
      host.clear();

      await bridge.dispose();
      await bridge.send(FusionChartsMessage(
          type: FusionChartsOutbound.update, chartId: 'fc-test1'));
      expect(host.executedScripts, isEmpty);
    });

    test('inbound messages after disposal are ignored', () async {
      final FakeWebViewHost host = FakeWebViewHost();
      final FusionChartsBridge bridge = makeBridge(host);
      bool fired = false;
      bridge.onEvent = (String n, String? s, Map<String, dynamic> a) {
        fired = true;
      };
      await bridge.attach();
      host.completePageLoad();
      await pumpEventQueue();
      await bridge.dispose();

      host.emitMessage('{"protocolVersion":1,"chartId":"fc-test1",'
          '"type":"event","payload":{"eventName":"dataPlotClick"}}');
      expect(fired, isFalse);
    });
  });

  group('FusionChartsController', () {
    test('drops invalid event names before they reach the page', () async {
      final FakeWebViewHost host = FakeWebViewHost();
      final FusionChartsBridge bridge = makeBridge(host);
      final FusionChartsController controller = FusionChartsController();
      controller.attachBridge(bridge);
      await bridge.attach();
      host.completePageLoad();
      await pumpEventQueue();
      host.clear();

      controller.addEvents(<String>["bad');alert(1)//", 'a b']);
      await Future<void>.delayed(Duration.zero);
      expect(host.bridgeEnvelopes, isEmpty);

      controller.addEvents(<String>['renderComplete']);
      await Future<void>.delayed(Duration.zero);
      expect(
        (envelopeOf(host.bridgeEnvelopes.single)['payload']
            as Map<String, dynamic>)['events'],
        <String>['renderComplete'],
      );
    });

    test('is a no-op before a bridge is attached', () {
      final FusionChartsController controller = FusionChartsController();
      expect(controller.isReady, isFalse);
      expect(() => controller.addEvents(<String>['renderComplete']),
          returnsNormally);
      expect(() => controller.executeScript('void 0;'), returnsNormally);
    });

    test('executeScript passes raw JavaScript through unchanged', () async {
      final FakeWebViewHost host = FakeWebViewHost();
      final FusionChartsBridge bridge = makeBridge(host);
      final FusionChartsController controller = FusionChartsController();
      controller.attachBridge(bridge);
      await bridge.attach();
      host.completePageLoad();
      await pumpEventQueue();
      host.clear();

      controller.executeScript('globalFusionCharts.chartType("column2d")');
      await Future<void>.delayed(Duration.zero);
      expect(host.executedScripts.single,
          'globalFusionCharts.chartType("column2d")');
    });
  });
}
