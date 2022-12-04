import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class FusionChartsController extends ChangeNotifier {
  FusionChartsController();

  InAppWebViewController? _webViewController;

  void executeScript(String js) async {
    String script = "executeAPI('$js')";
    print(js);
    await _webViewController?.evaluateJavascript(source: script);
  }

  void addEvents(List<String> events) async {
    String addEvents = events.join(',');
    await _webViewController?.evaluateJavascript(
        source: "addChartEvents('$addEvents')");
  }

  void removeEvents(List<String> events) async {
    String removeEvents = events.join(',');
    await _webViewController?.evaluateJavascript(
        source: "removeChartEvents('$removeEvents')");
  }

  void setWebViewController(InAppWebViewController webViewController) {
    _webViewController = webViewController;
  }
}
