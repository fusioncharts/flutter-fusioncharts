import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

/// Use FusionChartsController to subscribe/unsubscribe to the chat events and
/// call FusionCharts API

class FusionChartsController extends ChangeNotifier {
  FusionChartsController();

  InAppWebViewController? _webViewController;

  /// executeScript enables FC API calls. You can pass js code in string variable and
  /// the function will execute the script. Refer the chart object in your js code
  /// using a global variable like so: globalFusionCharts.chartType('column2d')

  void executeScript(String js) async {
    if (_webViewController != null) {
      try {
        await _webViewController?.evaluateJavascript(source: js);
      } catch (e) {
        print(e.toString());
      }
    }
  }

// addEvents function is called from Flutter side to register event(s).
// The flutter program should send a list of event names which should be subscribed

  void addEvents(List<String> events) async {
    String addEvents = events.join(',');
    await _webViewController?.evaluateJavascript(
        source: "addChartEvents('$addEvents')");
  }

// removeEvents function is called to register FusionCharts event(s).
// The flutter program should send a list of event names which should be unsubscribed

  void removeEvents(List<String> events) async {
    String removeEvents = events.join(',');
    await _webViewController?.evaluateJavascript(
        source: "removeChartEvents('$removeEvents')");
  }

  void setWebViewController(InAppWebViewController webViewController) {
    _webViewController = webViewController;
  }
}
