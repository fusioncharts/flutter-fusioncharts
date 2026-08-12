import 'package:flutter/widgets.dart';

/// A page, script or resource failure reported by the platform WebView.
///
/// This is a package-owned shape so that unit tests, and any future host
/// implementation, do not depend on a WebView vendor's error class.
class FusionChartsHostError {
  const FusionChartsHostError({
    required this.description,
    this.errorCode,
    this.isForMainFrame,
  });

  final String description;
  final int? errorCode;
  final bool? isForMainFrame;

  @override
  String toString() =>
      'FusionChartsHostError(code: $errorCode, description: $description)';
}

/// The seam between the widget and whichever WebView package hosts the page.
///
/// Everything above this interface is testable without a platform view, which
/// lets the unit and widget tests run on a fake. Keep this surface no wider than
/// the `webview_flutter 4.1.0` API actually used, so the declared package floor
/// stays honest.
abstract class FusionChartsWebViewHost {
  /// Prepares the underlying controller and wires the callbacks.
  ///
  /// [onMessage] receives raw JavaScript channel text, which is untrusted and
  /// must be validated by the protocol layer before use.
  Future<void> initialize({
    required String channelName,
    required void Function(String message) onMessage,
    required void Function() onPageFinished,
    required void Function(FusionChartsHostError error) onError,
  });

  /// Loads a page from the Flutter asset bundle.
  ///
  /// Asset loading is the only supported route for the package-owned bridge.
  /// It keeps the rendering page versioned with the wrapper.
  Future<void> loadFlutterAsset(String assetKey);

  /// Runs JavaScript in the hosted page without awaiting a result.
  Future<void> runJavaScript(String javaScript);

  /// The widget that renders the hosted page.
  Widget buildView();

  /// Releases the host. Safe to call more than once.
  Future<void> dispose();
}
