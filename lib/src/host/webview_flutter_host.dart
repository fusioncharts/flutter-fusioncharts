import 'package:flutter/widgets.dart';
import 'package:webview_flutter/webview_flutter.dart';

import 'fusion_charts_webview_host.dart';

/// Whether [url] is the one local page this host was asked to load.
///
/// A scheme check alone is not sufficient. Allowing any `file:` URL permits
/// navigation to an arbitrary local path, for example another application's
/// data directory, in a WebView that runs JavaScript without restriction and
/// carries this package's JavaScript channel. The target is therefore matched,
/// not just the scheme.
///
/// [assetKey] is the Flutter asset key passed to `loadFlutterAsset`. The
/// platform resolves it differently on each side, Android serving it from
/// `file:///android_asset/flutter_assets/...` and iOS from a path inside the
/// application bundle, so the comparison is an exact match on the final path
/// segments rather than on a full URL.
///
/// Passing `null` for [assetKey] means nothing has been loaded yet, in which
/// case only `about:` is allowed.
///
/// Kept outside the platform delegate so the exact iOS regression, and this
/// allowlist, can be tested without launching a platform view.
@visibleForTesting
bool isAllowedLocalNavigation(String url, {String? assetKey}) {
  final Uri? parsed = Uri.tryParse(url);
  if (parsed == null) {
    return false;
  }
  final String scheme = parsed.scheme.toLowerCase();
  if (scheme == 'about') {
    return true;
  }
  if (scheme != 'file') {
    return false;
  }
  if (assetKey == null || assetKey.isEmpty) {
    return false;
  }
  // Compare paths only: a fragment or query on an in-page navigation must not
  // turn the page itself into a refusal.
  final String path = Uri.decodeFull(parsed.path);
  final String key =
      assetKey.startsWith('/') ? assetKey.substring(1) : assetKey;
  return path == '/$key' || path.endsWith('/$key');
}

/// The production host, backed by the official `webview_flutter` package.
///
/// This file is the only place in `lib/` allowed to import `webview_flutter`.
/// It uses nothing beyond the 4.1.0 API surface, so the package keeps resolving
/// on the declared Flutter 3.3.8 floor:
/// `WebViewController`, `WebViewWidget`, `JavaScriptMode`, `NavigationDelegate`,
/// `addJavaScriptChannel`, `loadFlutterAsset` and `runJavaScript`.
class WebViewFlutterHost implements FusionChartsWebViewHost {
  WebViewController? _controller;
  bool _disposed = false;

  /// The asset key most recently handed to `loadFlutterAsset`, which is the
  /// only local document this host will navigate to.
  String? _loadedAssetKey;

  @override
  Future<void> initialize({
    required String channelName,
    required void Function(String message) onMessage,
    required void Function() onPageFinished,
    required void Function(FusionChartsHostError error) onError,
  }) async {
    final WebViewController controller = WebViewController();
    await controller.setJavaScriptMode(JavaScriptMode.unrestricted);

    await controller.addJavaScriptChannel(
      channelName,
      onMessageReceived: (JavaScriptMessage message) {
        if (_disposed) {
          return;
        }
        onMessage(message.message);
      },
    );

    await controller.setNavigationDelegate(
      NavigationDelegate(
        onPageFinished: (String url) {
          assert(() {
            debugPrint('[fc-host] pageFinished $url');
            return true;
          }());
          if (_disposed) {
            return;
          }
          onPageFinished();
        },
        onWebResourceError: (WebResourceError error) {
          assert(() {
            debugPrint('[fc-host] resourceError code=${error.errorCode} '
                'mainFrame=${error.isForMainFrame} ${error.description}');
            return true;
          }());
          if (_disposed) {
            return;
          }
          onError(
            FusionChartsHostError(
              description: error.description,
              errorCode: error.errorCode,
              isForMainFrame: error.isForMainFrame,
            ),
          );
        },
        onPageStarted: (String url) {
          assert(() {
            debugPrint('[fc-host] pageStarted $url');
            return true;
          }());
        },
        // Allow the bridge page itself to load, then refuse everything else,
        // matching on the loaded asset's path and not merely on the scheme.
        //
        // This delegate previously returned `prevent` unconditionally. On iOS
        // the initial `file://` asset load is itself dispatched through the
        // navigation delegate, so blanket prevention blocked the page from ever
        // loading; Android does not route the initial asset load through it,
        // which is why only iOS was affected.
        onNavigationRequest: (NavigationRequest request) {
          final bool isLocalAsset = isAllowedLocalNavigation(
            request.url,
            assetKey: _loadedAssetKey,
          );
          assert(() {
            debugPrint('[fc-host] navRequest ${request.url} '
                'mainFrame=${request.isMainFrame} '
                'allow=$isLocalAsset');
            return true;
          }());
          return isLocalAsset
              ? NavigationDecision.navigate
              : NavigationDecision.prevent;
        },
      ),
    );

    _controller = controller;
  }

  @override
  Future<void> loadFlutterAsset(String assetKey) async {
    final WebViewController? controller = _controller;
    if (controller == null || _disposed) {
      return;
    }
    // Recorded before the load starts, because on iOS the initial asset load
    // is itself dispatched through the navigation delegate and would otherwise
    // be refused by its own allowlist.
    _loadedAssetKey = assetKey;
    await controller.loadFlutterAsset(assetKey);
  }

  @override
  Future<void> runJavaScript(String javaScript) async {
    final WebViewController? controller = _controller;
    if (controller == null || _disposed) {
      return;
    }
    await controller.runJavaScript(javaScript);
  }

  @override
  Widget buildView() {
    final WebViewController? controller = _controller;
    if (controller == null) {
      return const SizedBox.shrink();
    }
    return WebViewWidget(controller: controller);
  }

  @override
  Future<void> dispose() async {
    // webview_flutter 4.1.0 has no controller disposal API; dropping the
    // reference and refusing further calls is the supported lifecycle.
    _disposed = true;
    _controller = null;
    _loadedAssetKey = null;
  }
}
