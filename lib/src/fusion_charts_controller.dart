import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class FusionChartsController extends ChangeNotifier {
  FusionChartsController();

  InAppWebViewController? _webViewController;

  void executeScript(String js) async {
    if (_webViewController != null) {
      await _webViewController?.callAsyncJavaScript(functionBody: js);
    }
  }

  void addEvents(List<String> events) async {
    await _webViewController?.addUserScript(
        userScript: UserScript(
            source: 'addChartEvent("test")',
            injectionTime: UserScriptInjectionTime.AT_DOCUMENT_END));
  }

  void removeEvents(List<String> events) {}

  void setWebViewController(InAppWebViewController webViewController) {
    _webViewController = webViewController;
  }
}
