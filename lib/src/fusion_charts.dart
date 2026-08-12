import 'dart:async';

import 'package:flutter/widgets.dart';

import 'bridge/fusion_charts_bridge.dart';
import 'export/fusion_charts_export.dart';
import 'bridge/fusion_charts_protocol.dart';
import 'fusion_charts_controller.dart';
import 'host/fusion_charts_webview_host.dart';
import 'host/webview_flutter_host.dart';
import 'source/fusion_charts_source.dart';

const String fcHome = 'fusioncharts';

/// A chart error surfaced to the application.
class FusionChartsError {
  const FusionChartsError({required this.code, required this.message});

  final String code;
  final String message;

  @override
  String toString() => 'FusionChartsError($code): $message';
}

/// Renders a FusionCharts chart inside a platform WebView.
///
/// Instantiate this widget and include it in the widget tree. Give it a
/// definite size: it fills its parent, so an unbounded parent collapses it.
class FusionCharts extends StatefulWidget {
  const FusionCharts({
    required this.dataSource,
    required this.type,
    this.height = "",
    this.width = "",
    this.events = const [],
    this.fusionChartEvent,
    this.fusionChartsController,
    this.streamController,
    this.timeSeriesSchema,
    this.timeSeriesData,
    this.isLocal = true,
    this.licenseKey,
    this.source,
    this.onError,
    this.onExport,
    super.key,
  });

  /// Supplies the data to the FusionCharts JS library. Typically comprises
  /// 'chart' (Map) and 'dataSet' (List), and may carry other objects such as
  /// 'annotation'.
  final Map<String, dynamic> dataSource;

  /// Type of chart to render. Example: 'column2d'.
  final String type;

  /// Width of the rendered chart in %, pixels or rem.
  final String width;

  /// Height of the rendered chart in %, pixels or rem.
  final String height;

  /// Event names subscribed to at chart load.
  final List<String> events;

  /// Called as `fusionChartEvent(senderId, eventName)` when a subscribed event
  /// fires. The 1.x argument order is preserved.
  final Function? fusionChartEvent;

  /// Enables adding/removing events and calling FusionCharts APIs.
  ///
  /// The controller may be replaced during a widget rebuild. The old controller
  /// is detached and the replacement is attached to the existing chart bridge.
  final FusionChartsController? fusionChartsController;

  /// Emits periodic updates for real-time charts.
  final StreamController? streamController;

  /// Whether to render from the local JS library rather than the CDN.
  ///
  /// Superseded by [source] when both are supplied.
  final bool isLocal;

  /// A valid license key, to remove the trial watermark.
  final String? licenseKey;

  /// Schema describing the time-series data.
  final List<dynamic>? timeSeriesSchema;

  /// Time-series dataset, which must comply with [timeSeriesSchema].
  final List<dynamic>? timeSeriesData;

  /// Explicit source selection. Wins over [isLocal] when both are given.
  ///
  /// Changing the effective source reloads its Flutter asset page and renders
  /// the chart again after the new page's bridge is ready.
  final FusionChartsSource? source;

  /// Reports page, bridge and chart errors as structured values.
  final ValueChanged<FusionChartsError>? onError;

  /// Receives export payloads as bytes plus MIME type and a suggested filename.
  ///
  /// The wrapper never writes files or asks for storage permissions; the
  /// application decides what to do with the bytes.
  final ValueChanged<FusionChartsExport>? onExport;

  /// Test seam: supplies a fake WebView host so widget tests can exercise the
  /// full lifecycle without a platform view. Never set in production.
  @visibleForTesting
  static FusionChartsWebViewHost Function()? debugHostFactory;

  /// Test seam: supplies the bridge script without touching the asset bundle.
  @visibleForTesting
  static Future<String> Function()? debugScriptLoader;

  @override
  State<FusionCharts> createState() => _FusionChartsState();
}

class _FusionChartsState extends State<FusionCharts> {
  static int _instanceCounter = 0;

  late final String _chartId;
  late final FusionChartsWebViewHost _host;
  late final FusionChartsBridge _bridge;
  late FusionChartsController _controller;

  /// Retained so it can be cancelled in [dispose]. The 1.x implementation
  /// discarded this, leaving the subscription alive after the widget was gone.
  StreamSubscription<dynamic>? _streamSubscription;

  bool _ownsController = false;
  bool _initialised = false;

  @override
  void initState() {
    super.initState();

    _instanceCounter += 1;
    _chartId = 'fc-${_instanceCounter.toRadixString(36)}';

    _controller = widget.fusionChartsController ?? FusionChartsController();
    _ownsController = widget.fusionChartsController == null;

    _host = FusionCharts.debugHostFactory?.call() ?? WebViewFlutterHost();
    _bridge = FusionChartsBridge(
      chartId: _chartId,
      host: _host,
      scriptLoader: FusionCharts.debugScriptLoader,
    )
      ..onEvent = _handleEvent
      ..onError = _handleError
      ..onExport = _handleExport;

    _controller.attachBridge(_bridge);

    _subscribeToStream();
    _startup();
  }

  Future<void> _startup() async {
    final FusionChartsSource? source = _resolveSource();
    if (source == null) {
      // Unsupported source already reported; do not touch the network.
      return;
    }
    await _bridge.attach();
    if (!mounted) {
      return;
    }
    await _bridge.load(source);
    if (!mounted) {
      return;
    }
    setState(() {
      _initialised = true;
    });
    await _bridge.send(_renderMessage());
  }

  Future<void> _reloadSource(FusionChartsSource source) async {
    // load() invalidates bridge readiness synchronously. Queue the render before
    // awaiting navigation so it is always the first envelope delivered to the
    // replacement page.
    final Future<void> pageLoad = _bridge.load(source);
    await _bridge.send(_renderMessage());
    await pageLoad;
    if (!mounted) {
      return;
    }
    if (!_initialised) {
      setState(() {
        _initialised = true;
      });
    }
  }

  void _subscribeToStream() {
    final StreamController? source = widget.streamController;
    if (source == null) {
      return;
    }
    _streamSubscription = source.stream.listen(
      (dynamic data) {
        // Travels as a JSON payload rather than being interpolated into a
        // feedData(...) call, as 1.x did.
        _bridge.send(FusionChartsMessage(
          type: FusionChartsOutbound.feedData,
          chartId: _chartId,
          payload: <String, dynamic>{'data': data},
        ));
      },
      onError: (Object error) {
        _handleError('stream-error', error.toString());
      },
    );
  }

  /// Resolves which page to load, or `null` when the request cannot be served.
  ///
  /// A request for the removed CDN mode is reported through [onError], and no
  /// load is attempted.
  ///
  /// The 1.x `maps` prefix override, which silently forced map chart types to
  /// CDN, is deliberately gone. The caller's configured source must be
  /// honoured, and map definitions must be bundled with the other assets.
  FusionChartsSource? _resolveSource() {
    final FusionChartsSource? explicit = widget.source;
    if (explicit != null) {
      assert(() {
        if (!widget.isLocal) {
          debugPrint('FusionCharts: both `source` and `isLocal` were supplied; '
              '`source` wins. `isLocal` is deprecated in 2.0.');
        }
        return true;
      }());
      return explicit;
    }
    try {
      return FusionChartsSource.fromIsLocal(widget.isLocal);
    } on FusionChartsSourceError catch (e) {
      _handleError(FusionChartsSource.unsupportedSourceCode, e.message);
      return null;
    }
  }

  FusionChartsMessage _renderMessage() {
    final Map<String, dynamic> payload = <String, dynamic>{
      'type': widget.type,
      'width': widget.width.isEmpty ? '100%' : widget.width,
      'height': widget.height.isEmpty ? '100%' : widget.height,
      'dataSource': widget.dataSource,
      'events': widget.events
          .where(FusionChartsMessage.isValidEventName)
          .toList(growable: false),
    };
    if (widget.licenseKey != null) {
      payload['licenseKey'] = widget.licenseKey;
    }
    if (widget.type == 'timeseries' &&
        widget.timeSeriesData != null &&
        widget.timeSeriesSchema != null) {
      payload['timeSeriesData'] = widget.timeSeriesData;
      payload['timeSeriesSchema'] = widget.timeSeriesSchema;
    }
    return FusionChartsMessage(
      type: FusionChartsOutbound.render,
      chartId: _chartId,
      payload: payload,
    );
  }

  @override
  void didUpdateWidget(covariant FusionCharts oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (!identical(
        oldWidget.fusionChartsController, widget.fusionChartsController)) {
      final FusionChartsController oldController = _controller;
      final bool disposedOwnedController = _ownsController;

      oldController.detachBridge();
      _controller = widget.fusionChartsController ?? FusionChartsController();
      _ownsController = widget.fusionChartsController == null;
      _controller.attachBridge(_bridge);

      if (disposedOwnedController) {
        oldController.dispose();
      }
    }

    if (!identical(oldWidget.streamController, widget.streamController)) {
      _streamSubscription?.cancel();
      _streamSubscription = null;
      _subscribeToStream();
    }

    final bool sourceChanged = oldWidget.source?.mode != widget.source?.mode ||
        oldWidget.source?.assetKey != widget.source?.assetKey ||
        oldWidget.source?.version != widget.source?.version ||
        (oldWidget.source == null &&
            widget.source == null &&
            oldWidget.isLocal != widget.isLocal);

    if (sourceChanged) {
      final FusionChartsSource? source = _resolveSource();
      if (source == null) {
        if (_initialised) {
          setState(() {
            _initialised = false;
          });
        }
        return;
      }
      _reloadSource(source);
      return;
    }

    // A chart-type or license change needs a fresh chart; anything else can be
    // applied in place. 1.x built the render string once in initState and so
    // ignored every subsequent change.
    final bool needsRecreate = oldWidget.type != widget.type ||
        oldWidget.licenseKey != widget.licenseKey;

    if (needsRecreate) {
      _bridge.send(_renderMessage());
      return;
    }

    final Map<String, dynamic> changes = <String, dynamic>{};
    if (!identical(oldWidget.dataSource, widget.dataSource)) {
      changes['dataSource'] = widget.dataSource;
    }
    if (oldWidget.width != widget.width) {
      changes['width'] = widget.width;
    }
    if (oldWidget.height != widget.height) {
      changes['height'] = widget.height;
    }
    if (changes.isNotEmpty) {
      _bridge.send(FusionChartsMessage(
        type: FusionChartsOutbound.update,
        chartId: _chartId,
        payload: changes,
      ));
    }

    final List<String> added = widget.events
        .where((String e) => !oldWidget.events.contains(e))
        .toList(growable: false);
    final List<String> removed = oldWidget.events
        .where((String e) => !widget.events.contains(e))
        .toList(growable: false);
    if (added.isNotEmpty) {
      _controller.addEvents(added);
    }
    if (removed.isNotEmpty) {
      _controller.removeEvents(removed);
    }
  }

  void _handleEvent(
      String eventName, String? senderId, Map<String, dynamic> _) {
    if (!mounted) {
      return;
    }
    final Function? callback = widget.fusionChartEvent;
    if (callback != null) {
      callback(senderId, eventName);
    }
  }

  void _handleExport(FusionChartsExport export) {
    if (!mounted) {
      return;
    }
    widget.onExport?.call(export);
  }

  void _handleError(String code, String message) {
    if (!mounted) {
      return;
    }
    widget.onError?.call(FusionChartsError(code: code, message: message));
  }

  @override
  void dispose() {
    // Ordering matters: release our own resources before handing control to
    // the framework. 1.x called super.dispose() first.
    _streamSubscription?.cancel();
    _streamSubscription = null;
    _controller.detachBridge();
    _bridge.dispose();
    if (_ownsController) {
      _controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // No Scaffold: the widget renders the WebView directly so it composes
    // inside whatever layout the application already has.
    return _initialised ? _host.buildView() : const SizedBox.shrink();
  }
}
