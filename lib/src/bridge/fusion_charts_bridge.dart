import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart' show rootBundle;

import '../export/fusion_charts_export.dart';
import '../host/fusion_charts_webview_host.dart';
import '../source/fusion_charts_source.dart';
import 'fusion_charts_protocol.dart';

/// Asset key of the package-owned bridge script.
const String kBridgeScriptAsset =
    'packages/flutter_fusioncharts/assets/bridge/fc_bridge.js';

/// Name of the JavaScript channel the bridge posts envelopes on.
const String kBridgeChannelName = 'FusionChartsBridge';

typedef FusionChartsEventCallback = void Function(
  String eventName,
  String? senderId,
  Map<String, dynamic> args,
);

typedef FusionChartsErrorCallback = void Function(
  String code,
  String message,
);

typedef FusionChartsExportCallback = void Function(FusionChartsExport export);

/// Owns one chart instance's conversation with the hosted page.
///
/// Responsibilities kept here rather than in the widget so they can be tested
/// against a fake host, with no platform view involved.
class FusionChartsBridge {
  FusionChartsBridge({
    required this.chartId,
    required FusionChartsWebViewHost host,
    Future<String> Function()? scriptLoader,
  })  : _host = host,
        _scriptLoader = scriptLoader ?? _loadBundledScript;

  final String chartId;
  final FusionChartsWebViewHost _host;
  final Future<String> Function() _scriptLoader;

  /// Messages issued before the page and bridge script were ready.
  ///
  /// Controller calls made during `initState` are normal, so they are held
  /// rather than dropped, and flushed in order once the page settles.
  final List<FusionChartsMessage> _pending = <FusionChartsMessage>[];

  bool _bridgeInstalled = false;
  bool _disposed = false;
  String? _expectedFusionChartsVersion;

  FusionChartsEventCallback? onEvent;
  FusionChartsErrorCallback? onError;
  FusionChartsExportCallback? onExport;
  VoidCallback? onReady;

  int _exportSeq = 0;

  /// Asks the page to export the chart. The result arrives on [onExport], or a
  /// failure on [onError]; requesting a format the platform cannot produce
  /// reports `export-unsupported` rather than hanging.
  Future<void> requestExport(String format) async {
    final String fmt = format.toLowerCase();
    if (!FusionChartsExportFormat.isValid(fmt)) {
      onError?.call('invalid-format', 'unsupported export format "$format"');
      return;
    }
    _exportSeq += 1;
    await send(FusionChartsMessage(
      type: FusionChartsOutbound.export,
      chartId: chartId,
      requestId: 'x$_exportSeq',
      payload: <String, dynamic>{'format': fmt},
    ));
  }

  bool get isReady => _bridgeInstalled;

  @visibleForTesting
  List<FusionChartsMessage> get pendingMessages =>
      List<FusionChartsMessage>.unmodifiable(_pending);

  static Future<String> _loadBundledScript() =>
      rootBundle.loadString(kBridgeScriptAsset);

  /// Wires the host callbacks. Call once, before [load].
  Future<void> attach() async {
    await _host.initialize(
      channelName: kBridgeChannelName,
      onMessage: handleInbound,
      onPageFinished: _handlePageFinished,
      onError: (FusionChartsHostError error) {
        onError?.call('webview-error', error.description);
      },
    );
  }

  /// Loads the page described by [source].
  Future<void> load(FusionChartsSource source) {
    // Loading a new document removes the bridge script from the previous page.
    // Mark it unavailable before starting navigation so messages issued during
    // the load are queued and flushed only after the new page finishes.
    _bridgeInstalled = false;
    _expectedFusionChartsVersion = source.version;
    return _host.loadFlutterAsset(source.assetKey);
  }

  Future<void> _handlePageFinished() async {
    if (_disposed) {
      return;
    }
    try {
      final String script = await _scriptLoader();
      await _host.runJavaScript(script);
      _bridgeInstalled = true;
      await _flush();
      onReady?.call();
    } catch (e) {
      onError?.call('bridge-install-failed', e.toString());
    }
  }

  /// Sends an envelope, queueing it if the bridge is not installed yet.
  Future<void> send(FusionChartsMessage message) async {
    if (_disposed) {
      return;
    }
    if (!_bridgeInstalled) {
      _pending.add(message);
      return;
    }
    await _dispatch(message);
  }

  Future<void> _dispatch(FusionChartsMessage message) async {
    final String encoded;
    try {
      encoded = message.encode();
    } on FusionChartsProtocolError catch (e) {
      // Rejected in Dart, so a malformed envelope never reaches the page.
      onError?.call('invalid-message', e.reason);
      return;
    }
    // jsonEncode of the already-encoded envelope yields a correctly escaped
    // JavaScript string literal, so no payload character can terminate it.
    await _host.runJavaScript(
      'window.__fcBridgeReceive(${jsonEncode(encoded)});',
    );
  }

  Future<void> _flush() async {
    final List<FusionChartsMessage> queued =
        List<FusionChartsMessage>.from(_pending);
    _pending.clear();
    for (final FusionChartsMessage message in queued) {
      await _dispatch(message);
    }
  }

  /// Handles one raw JavaScript channel message.
  @visibleForTesting
  void handleInbound(String raw) {
    if (_disposed) {
      return;
    }
    final FusionChartsMessage message;
    try {
      message = FusionChartsMessage.decodeInbound(raw);
    } on FusionChartsProtocolError catch (e) {
      onError?.call('invalid-inbound', e.reason);
      return;
    }

    // A page hosting several charts posts on one channel; ignore traffic that
    // belongs to another instance.
    if (message.chartId != chartId && message.chartId != 'fc-page') {
      return;
    }

    switch (message.type) {
      case FusionChartsInbound.ready:
        final Object? actual = message.payload['fusionChartsVersion'];
        final String? expected = _expectedFusionChartsVersion;
        if (actual is! String || actual.isEmpty) {
          onError?.call(
            'runtime-version-missing',
            'the loaded page did not report its FusionCharts version',
          );
          return;
        }
        if (expected != null && actual != expected) {
          onError?.call(
            'runtime-version-mismatch',
            'expected FusionCharts $expected but the page reported $actual',
          );
          return;
        }
        onReady?.call();
        break;
      case FusionChartsInbound.event:
        final Object? name = message.payload['eventName'];
        if (name is! String) {
          return;
        }
        final Object? args = message.payload['args'];
        onEvent?.call(
          name,
          message.payload['senderId'] as String?,
          args is Map ? Map<String, dynamic>.from(args) : <String, dynamic>{},
        );
        break;
      case FusionChartsInbound.export:
        final FusionChartsExport? export = FusionChartsExport.fromPayload(
          message.payload,
          fallbackFormat: 'bin',
        );
        if (export == null) {
          onError?.call('export-empty',
              'the page returned an export message with no payload');
          return;
        }
        onExport?.call(export);
        break;
      case FusionChartsInbound.error:
        onError?.call(
          (message.payload['code'] as String?) ?? 'unknown',
          (message.payload['message'] as String?) ?? '',
        );
        break;
      default:
        break;
    }
  }

  /// Raw JavaScript escape hatch retained for API compatibility.
  ///
  /// Documented as unsafe: the caller owns escaping. New code should use the
  /// typed controller methods, which travel as validated JSON envelopes.
  Future<void> runUnsafeScript(String javaScript) async {
    if (_disposed) {
      return;
    }
    await _host.runJavaScript(javaScript);
  }

  Future<void> dispose() async {
    if (_disposed) {
      return;
    }
    if (_bridgeInstalled) {
      await _dispatch(FusionChartsMessage(
        type: FusionChartsOutbound.dispose,
        chartId: chartId,
      ));
    }
    _disposed = true;
    _pending.clear();
    onEvent = null;
    onError = null;
    onExport = null;
    onReady = null;
    await _host.dispose();
  }
}
