import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class FusionChartsController extends ChangeNotifier {
  FusionChartsController();

  InAppWebViewController? _webViewController;

  void executeScript(String js) async {
    if (_webViewController != null) {
      await _webViewController?.evaluateJavascript(source: js);
    }
  }

  void addEvents(List<String> events) async {
    String addEvents = events.join(',');
    await _webViewController?.evaluateJavascript(
        source: 'addChartEvents($addEvents)');
  }

  void removeEvents(List<String> events) async {
    await _webViewController?.evaluateJavascript(
        source: 'removeChartEvents($addEvents)');
  }

  void setWebViewController(InAppWebViewController webViewController) {
    _webViewController = webViewController;
  }
}
