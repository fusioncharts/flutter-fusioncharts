import 'package:flutter/foundation.dart';

import 'bridge/fusion_charts_bridge.dart';
import 'bridge/fusion_charts_protocol.dart';

/// Use FusionChartsController to subscribe/unsubscribe to chart events and to
/// call FusionCharts APIs.
///
/// Calls made before the chart is ready are queued and replayed in order, so a
/// controller may be driven from `initState` without a readiness check.
class FusionChartsController extends ChangeNotifier {
  FusionChartsController();

  FusionChartsBridge? _bridge;

  /// Attached by the [FusionCharts] widget. Not part of the supported API.
  ///
  /// This replaces the 1.x `setWebViewController(InAppWebViewController)`,
  /// which exposed a third-party WebView type on a public method. See
  /// `doc/migration/1.x-to-2.0.md`.
  void attachBridge(FusionChartsBridge bridge) {
    _bridge = bridge;
  }

  /// Detached by the [FusionCharts] widget. Not part of the supported API.
  void detachBridge() {
    _bridge = null;
  }

  /// True once the hosting page and bridge are installed.
  bool get isReady => _bridge?.isReady ?? false;

  /// Executes raw JavaScript in the chart page.
  ///
  /// Advanced, unsafe escape hatch retained for 1.x compatibility: the caller
  /// is responsible for escaping every value it interpolates. Prefer the typed
  /// methods below, which travel as validated JSON and cannot inject script.
  void executeScript(String js) {
    _bridge?.runUnsafeScript(js);
  }

  /// Registers chart event listeners.
  ///
  /// Event names are validated: anything outside a plain identifier is
  /// rejected before it reaches the page.
  void addEvents(List<String> events) {
    final List<String> valid = _validEventNames(events);
    if (valid.isEmpty) {
      return;
    }
    _send(FusionChartsOutbound.addEvents, <String, dynamic>{'events': valid});
  }

  /// Removes chart event listeners previously registered.
  void removeEvents(List<String> events) {
    final List<String> valid = _validEventNames(events);
    if (valid.isEmpty) {
      return;
    }
    _send(
        FusionChartsOutbound.removeEvents, <String, dynamic>{'events': valid});
  }

  /// Replaces the chart's data source without recreating the chart.
  void setData(Map<String, dynamic> dataSource) {
    _send(FusionChartsOutbound.update,
        <String, dynamic>{'dataSource': dataSource});
  }

  /// Requests an export. The bytes arrive on the widget's `onExport`.
  ///
  /// Format availability is platform-dependent; see the support matrix. An
  /// unavailable format reports `export-unsupported` through `onError`.
  void exportChart(String format) {
    _bridge?.requestExport(format);
  }

  /// Pushes a real-time data increment to the chart.
  void feedData(Object? data) {
    _send(FusionChartsOutbound.feedData, <String, dynamic>{'data': data});
  }

  List<String> _validEventNames(List<String> events) {
    final List<String> valid = <String>[];
    for (final String name in events) {
      if (FusionChartsMessage.isValidEventName(name)) {
        valid.add(name);
      }
    }
    return valid;
  }

  void _send(String type, Map<String, dynamic> payload) {
    final FusionChartsBridge? bridge = _bridge;
    if (bridge == null) {
      return;
    }
    bridge.send(FusionChartsMessage(
      type: type,
      chartId: bridge.chartId,
      payload: payload,
    ));
  }

  @override
  void dispose() {
    _bridge = null;
    super.dispose();
  }
}
