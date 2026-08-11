import 'dart:async';

// Material is imported only so the test can assert the package does NOT use it.
import 'package:flutter/material.dart' show Scaffold;
import 'package:flutter/widgets.dart';
import 'package:flutter_fusioncharts/flutter_fusioncharts.dart';
import 'package:flutter_test/flutter_test.dart';

import 'bridge_message_test.dart' show envelopeOf;
import 'fakes/fake_webview_host.dart';

late List<FakeWebViewHost> hosts;

Map<String, dynamic> chartData() => <String, dynamic>{
      'chart': <String, dynamic>{'caption': 'Revenue'},
      'data': <dynamic>[
        <String, dynamic>{'label': 'Q1', 'value': '100'}
      ],
    };

Widget wrap(Widget child) => Directionality(
      textDirection: TextDirection.ltr,
      child: SizedBox(width: 320, height: 240, child: child),
    );

/// Drives the widget's async startup to completion.
///
/// The startup path crosses several microtask boundaries (attach, load,
/// setState, render), so each stage needs a pump to drain.
Future<void> settle(WidgetTester tester) async {
  for (int i = 0; i < 4; i++) {
    await tester.pump(Duration.zero);
  }
  for (final FakeWebViewHost host in hosts) {
    host.completePageLoad();
  }
  for (int i = 0; i < 4; i++) {
    await tester.pump(Duration.zero);
  }
}

void main() {
  setUp(() {
    hosts = <FakeWebViewHost>[];
    FusionCharts.debugHostFactory = () {
      final FakeWebViewHost host = FakeWebViewHost();
      hosts.add(host);
      return host;
    };
    FusionCharts.debugScriptLoader = () async => '/* bridge */';
  });

  tearDown(() {
    FusionCharts.debugHostFactory = null;
    FusionCharts.debugScriptLoader = null;
  });

  testWidgets('renders once the page is ready and sends a render envelope',
      (WidgetTester tester) async {
    await tester.pumpWidget(wrap(FusionCharts(
      dataSource: chartData(),
      type: 'column2d',
    )));
    await settle(tester);

    final Map<String, dynamic> envelope =
        envelopeOf(hosts.single.bridgeEnvelopes.single);
    expect(envelope['type'], 'render');
    final Map<String, dynamic> payload =
        envelope['payload'] as Map<String, dynamic>;
    expect(payload['type'], 'column2d');
    expect(payload['dataSource'], chartData());
  });

  testWidgets('does not wrap the chart in its own Scaffold',
      (WidgetTester tester) async {
    await tester.pumpWidget(wrap(FusionCharts(
      dataSource: chartData(),
      type: 'column2d',
    )));
    await settle(tester);

    // 1.x embedded a Scaffold, which forced Material into package code and
    // broke composition inside an existing page.
    expect(find.byType(Scaffold, skipOffstage: false), findsNothing);
  });

  testWidgets('isLocal: true loads the asset page',
      (WidgetTester tester) async {
    await tester.pumpWidget(wrap(FusionCharts(
      dataSource: chartData(),
      type: 'column2d',
    )));
    await settle(tester);
    expect(hosts.single.loadedAssets.single, FusionChartsSource.packageAsset);
  });

  testWidgets('isLocal: false reports unsupported-source and loads nothing',
      (WidgetTester tester) async {
    // There is no CDN runtime mode or network fallback. The removed mode must
    // fail loudly rather than quietly reaching the network.
    final List<FusionChartsError> errors = <FusionChartsError>[];
    await tester.pumpWidget(wrap(FusionCharts(
      dataSource: chartData(),
      type: 'column2d',
      isLocal: false,
      onError: errors.add,
    )));
    await settle(tester);

    expect(errors.single.code, FusionChartsSource.unsupportedSourceCode);
    expect(errors.single.message, contains('assets bundled with this package'));
    expect(hosts.single.loadedAssets, isEmpty,
        reason: 'no page may be loaded for an unsupported source');
    expect(hosts.single.executedScripts, isEmpty);
  });

  testWidgets('two charts on one screen get isolated ids and hosts',
      (WidgetTester tester) async {
    await tester.pumpWidget(wrap(Column(children: <Widget>[
      SizedBox(
        height: 100,
        child: FusionCharts(
            key: const ValueKey<String>('a'),
            dataSource: chartData(),
            type: 'column2d'),
      ),
      SizedBox(
        height: 100,
        child: FusionCharts(
            key: const ValueKey<String>('b'),
            dataSource: chartData(),
            type: 'pie2d'),
      ),
    ])));
    await settle(tester);

    expect(hosts, hasLength(2));
    final String idA =
        envelopeOf(hosts[0].bridgeEnvelopes.single)['chartId'] as String;
    final String idB =
        envelopeOf(hosts[1].bridgeEnvelopes.single)['chartId'] as String;
    expect(idA, isNot(idB),
        reason: '1.x used a single globalFusionCharts, so charts collided');
  });

  testWidgets('didUpdateWidget pushes a data change as an update',
      (WidgetTester tester) async {
    await tester.pumpWidget(wrap(FusionCharts(
      key: const ValueKey<String>('k'),
      dataSource: chartData(),
      type: 'column2d',
    )));
    await settle(tester);
    hosts.single.clear();

    final Map<String, dynamic> next = chartData();
    next['chart'] = <String, dynamic>{'caption': 'Updated'};
    await tester.pumpWidget(wrap(FusionCharts(
      key: const ValueKey<String>('k'),
      dataSource: next,
      type: 'column2d',
    )));
    await tester.pump(Duration.zero);

    final Map<String, dynamic> envelope =
        envelopeOf(hosts.single.bridgeEnvelopes.single);
    expect(envelope['type'], 'update');
    expect(
      ((envelope['payload'] as Map<String, dynamic>)['dataSource']
          as Map<String, dynamic>)['chart'],
      <String, dynamic>{'caption': 'Updated'},
    );
  });

  testWidgets('a chart type change recreates rather than patches the chart',
      (WidgetTester tester) async {
    await tester.pumpWidget(wrap(FusionCharts(
      key: const ValueKey<String>('k'),
      dataSource: chartData(),
      type: 'column2d',
    )));
    await settle(tester);
    hosts.single.clear();

    await tester.pumpWidget(wrap(FusionCharts(
      key: const ValueKey<String>('k'),
      dataSource: chartData(),
      type: 'pie2d',
    )));
    await tester.pump(Duration.zero);

    expect(envelopeOf(hosts.single.bridgeEnvelopes.single)['type'], 'render');
  });

  testWidgets('a source change loads the new page before rendering again',
      (WidgetTester tester) async {
    final Map<String, dynamic> data = chartData();
    await tester.pumpWidget(wrap(FusionCharts(
      key: const ValueKey<String>('k'),
      dataSource: data,
      type: 'column2d',
    )));
    await settle(tester);
    final FakeWebViewHost host = hosts.single;
    host.clear();

    await tester.pumpWidget(wrap(FusionCharts(
      key: const ValueKey<String>('k'),
      dataSource: data,
      type: 'column2d',
      source: FusionChartsSource.asset(assetKey: 'custom/replacement.html'),
    )));
    await tester.pump(Duration.zero);

    expect(host.loadedAssets, <String>['custom/replacement.html']);
    expect(host.bridgeEnvelopes, isEmpty,
        reason: 'render must wait for the replacement page bridge');

    host.completePageLoad();
    for (int i = 0; i < 4; i++) {
      await tester.pump(Duration.zero);
    }

    expect(envelopeOf(host.bridgeEnvelopes.single)['type'], 'render');
  });

  testWidgets('a replacement controller is attached and the old one detached',
      (WidgetTester tester) async {
    final Map<String, dynamic> data = chartData();
    final FusionChartsController first = FusionChartsController();
    final FusionChartsController replacement = FusionChartsController();
    addTearDown(first.dispose);
    addTearDown(replacement.dispose);

    await tester.pumpWidget(wrap(FusionCharts(
      key: const ValueKey<String>('k'),
      dataSource: data,
      type: 'column2d',
      fusionChartsController: first,
    )));
    await settle(tester);
    final FakeWebViewHost host = hosts.single;
    host.clear();

    await tester.pumpWidget(wrap(FusionCharts(
      key: const ValueKey<String>('k'),
      dataSource: data,
      type: 'column2d',
      fusionChartsController: replacement,
    )));
    await tester.pump(Duration.zero);

    expect(first.isReady, isFalse);
    expect(replacement.isReady, isTrue);

    first.setData(<String, dynamic>{
      'chart': <String, dynamic>{'old': true}
    });
    await tester.pump(Duration.zero);
    expect(host.bridgeEnvelopes, isEmpty);

    replacement.setData(<String, dynamic>{
      'chart': <String, dynamic>{'new': true}
    });
    await tester.pump(Duration.zero);
    expect(envelopeOf(host.bridgeEnvelopes.single)['type'], 'update');
  });

  testWidgets('stream data is forwarded as a feedData envelope',
      (WidgetTester tester) async {
    final StreamController<dynamic> stream =
        StreamController<dynamic>.broadcast();
    addTearDown(stream.close);

    await tester.pumpWidget(wrap(FusionCharts(
      dataSource: chartData(),
      type: 'realtimeline',
      streamController: stream,
    )));
    await settle(tester);
    hosts.single.clear();

    stream.add('&label=10:30&value=42');
    await tester.pump(Duration.zero);
    await tester.pump(Duration.zero);

    final Map<String, dynamic> envelope =
        envelopeOf(hosts.single.bridgeEnvelopes.single);
    expect(envelope['type'], 'feedData');
    expect((envelope['payload'] as Map<String, dynamic>)['data'],
        '&label=10:30&value=42');
  });

  testWidgets('disposal cancels the stream subscription and the host',
      (WidgetTester tester) async {
    // Broadcast, so teardown's close() completes even with no live listener.
    final StreamController<dynamic> stream =
        StreamController<dynamic>.broadcast();
    addTearDown(() {
      if (!stream.isClosed) {
        stream.close();
      }
    });

    await tester.pumpWidget(wrap(FusionCharts(
      dataSource: chartData(),
      type: 'realtimeline',
      streamController: stream,
    )));
    await settle(tester);
    final FakeWebViewHost host = hosts.single;
    expect(stream.hasListener, isTrue);

    await tester.pumpWidget(wrap(const SizedBox.shrink()));
    await tester.pump(Duration.zero);

    // 1.x discarded the StreamSubscription, so it outlived the widget.
    expect(stream.hasListener, isFalse);
    expect(host.disposed, isTrue);
  });

  testWidgets('map chart types honour the configured asset source',
      (WidgetTester tester) async {
    // 1.x silently rewrote isLocal to false for any type starting with "maps",
    // forcing CDN. With no CDN runtime mode that override is both impossible
    // and forbidden: the caller's source must be honoured, and map definitions
    // are bundled with the other assets.
    await tester.pumpWidget(wrap(FusionCharts(
      dataSource: chartData(),
      type: 'maps/world',
    )));
    await settle(tester);

    expect(hosts.single.loadedAssets.single, FusionChartsSource.packageAsset);
  });

  testWidgets('an explicit source wins over isLocal',
      (WidgetTester tester) async {
    await tester.pumpWidget(wrap(FusionCharts(
      dataSource: chartData(),
      type: 'maps/world',
      source: FusionChartsSource.asset(assetKey: 'custom/page.html'),
    )));
    await settle(tester);

    expect(hosts.single.loadedAssets.single, 'custom/page.html');
  });

  testWidgets('chart events reach the 1.x callback shape',
      (WidgetTester tester) async {
    final List<List<dynamic>> received = <List<dynamic>>[];
    await tester.pumpWidget(wrap(FusionCharts(
      dataSource: chartData(),
      type: 'column2d',
      events: const <String>['dataPlotClick'],
      fusionChartEvent: (dynamic senderId, dynamic eventName) {
        received.add(<dynamic>[senderId, eventName]);
      },
    )));
    await settle(tester);

    final String chartId =
        envelopeOf(hosts.single.bridgeEnvelopes.single)['chartId'] as String;
    hosts.single.emitMessage('{"protocolVersion":1,"chartId":"$chartId",'
        '"type":"event","payload":{"eventName":"dataPlotClick",'
        '"senderId":"chart-1"}}');
    await tester.pump(Duration.zero);

    expect(received.single, <dynamic>['chart-1', 'dataPlotClick']);
  });

  testWidgets('errors are reported through onError',
      (WidgetTester tester) async {
    final List<FusionChartsError> errors = <FusionChartsError>[];
    await tester.pumpWidget(wrap(FusionCharts(
      dataSource: chartData(),
      type: 'column2d',
      onError: errors.add,
    )));
    await settle(tester);

    hosts.single.emitError('net::ERR_NAME_NOT_RESOLVED', code: -105);
    await tester.pump(Duration.zero);

    expect(errors.single.code, 'webview-error');
    expect(errors.single.message, 'net::ERR_NAME_NOT_RESOLVED');
  });
}
