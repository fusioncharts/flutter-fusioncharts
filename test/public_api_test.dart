import 'dart:async';

import 'package:flutter/foundation.dart' show ChangeNotifier;
import 'package:flutter_fusioncharts/flutter_fusioncharts.dart';
import 'package:flutter_test/flutter_test.dart';

/// Locks the public surface against accidental change.
///
/// The documented 1.x API is the reference. Every existing entry point covered
/// here must keep compiling; additions must be optional.
void main() {
  group('FusionCharts widget constructor', () {
    test('accepts the full 1.x parameter set', () {
      // Broadcast: closing a single-subscription controller that never had a
      // listener returns a Future that never completes, which hangs teardown.
      final StreamController<dynamic> stream =
          StreamController<dynamic>.broadcast();
      addTearDown(stream.close);

      final FusionCharts chart = FusionCharts(
        dataSource: const <String, dynamic>{'chart': <String, dynamic>{}},
        type: 'column2d',
        height: '400',
        width: '600',
        events: const <String>['renderComplete'],
        fusionChartEvent: (dynamic a, dynamic b) {},
        fusionChartsController: FusionChartsController(),
        streamController: stream,
        timeSeriesSchema: const <dynamic>[],
        timeSeriesData: const <dynamic>[],
        isLocal: true,
        licenseKey: 'placeholder',
      );

      expect(chart.type, 'column2d');
      expect(chart.height, '400');
      expect(chart.width, '600');
      expect(chart.isLocal, isTrue);
      expect(chart.events, <String>['renderComplete']);
    });

    test('requires only dataSource and type', () {
      const FusionCharts chart = FusionCharts(
        dataSource: <String, dynamic>{},
        type: 'pie2d',
      );

      // 1.x defaults preserved exactly.
      expect(chart.height, '');
      expect(chart.width, '');
      expect(chart.isLocal, isTrue);
      expect(chart.events, isEmpty);
      expect(chart.licenseKey, isNull);
      expect(chart.fusionChartEvent, isNull);
      expect(chart.fusionChartsController, isNull);
      expect(chart.streamController, isNull);
      expect(chart.timeSeriesSchema, isNull);
      expect(chart.timeSeriesData, isNull);
    });

    test('additions are optional', () {
      const FusionCharts chart = FusionCharts(
        dataSource: <String, dynamic>{},
        type: 'column2d',
      );
      expect(chart.source, isNull);
      expect(chart.onError, isNull);
      expect(chart.onExport, isNull);
    });
  });

  group('FusionChartsController', () {
    test('exposes the 1.x methods', () {
      final FusionChartsController controller = FusionChartsController();
      addTearDown(controller.dispose);

      expect(controller.executeScript, isA<void Function(String)>());
      expect(controller.addEvents, isA<void Function(List<String>)>());
      expect(controller.removeEvents, isA<void Function(List<String>)>());
    });

    test('is a ChangeNotifier', () {
      final FusionChartsController controller = FusionChartsController();
      addTearDown(controller.dispose);
      expect(controller, isA<ChangeNotifier>());
    });
  });

  group('exported symbols', () {
    test('FusionChartsSource factories are public', () {
      expect(FusionChartsSource.asset().mode, FusionChartsSourceMode.asset);
      expect(FusionChartsSourceMode.values.length, 1,
          reason: 'offline assets are the only runtime mode');
      expect(kFusionChartsVersion, '4.2.2');
    });

    test('FusionChartsError carries a code and message', () {
      const FusionChartsError error =
          FusionChartsError(code: 'render-failed', message: 'boom');
      expect(error.code, 'render-failed');
      expect(error.message, 'boom');
    });
  });
}
