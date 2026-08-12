import 'package:flutter/widgets.dart';
import 'package:flutter_fusioncharts/src/host/fusion_charts_webview_host.dart';

/// An in-memory [FusionChartsWebViewHost] for unit and widget tests.
///
/// Exists so the whole bridge, controller and widget lifecycle can be tested
/// without launching a platform view. It records every script the package
/// would have run, which is what lets tests assert exact serialized messages
/// instead of asserting on generated JavaScript text.
class FakeWebViewHost implements FusionChartsWebViewHost {
  final List<String> executedScripts = <String>[];
  final List<String> loadedAssets = <String>[];

  String? channelName;
  bool disposed = false;
  int initializeCount = 0;

  void Function(String message)? _onMessage;
  void Function()? _onPageFinished;
  void Function(FusionChartsHostError error)? _onError;

  /// Scripts the package sent through the bridge envelope entry point.
  List<String> get bridgeEnvelopes => executedScripts
      .where((String s) => s.startsWith('window.__fcBridgeReceive('))
      .toList(growable: false);

  @override
  Future<void> initialize({
    required String channelName,
    required void Function(String message) onMessage,
    required void Function() onPageFinished,
    required void Function(FusionChartsHostError error) onError,
  }) async {
    initializeCount += 1;
    this.channelName = channelName;
    _onMessage = onMessage;
    _onPageFinished = onPageFinished;
    _onError = onError;
  }

  @override
  Future<void> loadFlutterAsset(String assetKey) async {
    loadedAssets.add(assetKey);
  }

  @override
  Future<void> runJavaScript(String javaScript) async {
    executedScripts.add(javaScript);
  }

  @override
  Widget buildView() => const SizedBox.shrink();

  @override
  Future<void> dispose() async {
    disposed = true;
  }

  // ---- test drivers -------------------------------------------------------

  /// Simulates the hosted page finishing load.
  ///
  /// Deliberately synchronous. The bridge then installs its script across
  /// several microtask hops, and it is the caller's job to drain them:
  /// `await pumpEventQueue()` in a plain test, `await tester.pump()` in a
  /// widget test. Awaiting a real timer here would deadlock under FakeAsync.
  void completePageLoad() {
    _onPageFinished?.call();
  }

  /// Simulates the page posting a message on the JavaScript channel.
  void emitMessage(String raw) => _onMessage?.call(raw);

  /// Simulates a WebView resource error.
  void emitError(String description, {int? code}) =>
      _onError?.call(FusionChartsHostError(
        description: description,
        errorCode: code,
      ));

  void clear() {
    executedScripts.clear();
    loadedAssets.clear();
  }
}
