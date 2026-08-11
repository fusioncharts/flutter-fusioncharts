import 'package:flutter/widgets.dart';
import 'package:webview_flutter/webview_flutter.dart';

import 'fusion_charts_webview_host.dart';

/// Whether [url] belongs to the package-owned local WebView page.
///
/// Kept outside the platform delegate so the exact iOS regression can be
/// tested without launching a platform view.
@visibleForTesting
bool isAllowedLocalNavigation(String url) {
  final String scheme = Uri.tryParse(url)?.scheme.toLowerCase() ?? '';
  return scheme == 'file' || scheme == 'about';
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
        // Allow the bridge page itself to load, then refuse everything else.
        //
        // This delegate previously returned `prevent` unconditionally. On iOS
        // the initial `file://` asset load is itself dispatched through the
        // navigation delegate, so blanket prevention blocked the page from ever
        // loading; Android does not route the initial asset load through it,
        // which is why only iOS was affected.
        onNavigationRequest: (NavigationRequest request) {
          final bool isLocalAsset = isAllowedLocalNavigation(request.url);
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
  }
}
