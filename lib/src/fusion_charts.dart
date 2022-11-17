import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'dart:convert';

import './utils/constants.dart';
import './fusion_charts_controller.dart';

class FusionCharts extends StatefulWidget {
  const FusionCharts(
      {required this.dataSource,
      required this.type,
      this.height = "",
      this.width = "",
      this.webviewEvent,
      this.fusionChartEvent,
      this.version = "latest",
      this.licenseKey,
      this.events = const [],
      this.fusionChartsController,
      super.key});

  final Map<String, dynamic> dataSource;
  final String type;
  final String width;
  final String height;
  final Function? webviewEvent;
  final Function? fusionChartEvent;
  final List<String>? events;
  final String? licenseKey;
  final String? version;
  final FusionChartsController? fusionChartsController;

  @override
  State<FusionCharts> createState() => _FusionChartsState();
}

class _FusionChartsState extends State<FusionCharts> {
  String? version;
  String? licenseKey;
  String chartString = "";

  bool gotData = false;
  String json = "";

  late InAppWebViewController _webViewController;
  FusionChartsController? _fusionChartsController;
  @override
  void initState() {
    super.initState();
    WidgetsFlutterBinding.ensureInitialized();

    if (widget.fusionChartsController != null) {
      _fusionChartsController = FusionChartsController();
    } else {
      _fusionChartsController = widget.fusionChartsController;
    }
    _fusionChartsController?.setWebViewController(_webViewController);
    String jsonDataSource = jsonEncode(widget.dataSource);

    if (widget.licenseKey != null) {
      print('Licensed: ${widget.licenseKey}');
    } else {
      print('Unlicensed Trial');
    }

    chartString = """

      FusionCharts.ready(function() {
        var fusionChart = new FusionCharts({
        type: "${widget.type}",
        width: "${widget.width}",
        height: "${widget.height}",
        renderAt: "chart-container",
        dataFormat: "json",
        dataSource: $jsonDataSource   
      });

      $registerEvents

      fusionChart.render();
    
    });
    """;

    setState(() {
      gotData = true;
    });
  }

  _onLoadComplete() {}
  @override
  Widget build(BuildContext context) {
    return gotData
        ? SizedBox(
            child: InAppWebView(
            initialOptions: InAppWebViewGroupOptions(
              crossPlatform: InAppWebViewOptions(
                useOnDownloadStart: true,
                javaScriptCanOpenWindowsAutomatically: true,
                javaScriptEnabled: true,
                useShouldOverrideUrlLoading: true,
              ),
              ios: IOSInAppWebViewOptions(
                sharedCookiesEnabled: true,
              ),
            ),
            initialFile: jsIntegrationFolder,
            onLoadStop: (controller, url) async {
              await controller.evaluateJavascript(source: chartString);
            },
            onWebViewCreated: (InAppWebViewController controller) {
              _webViewController = controller;
              controller.addJavaScriptHandler(
                  handlerName: 'webviewEventHandler',
                  callback: (args) {
                    print('Webview evenHandler cons: $args');
                     if (widget.webviewEvent != null) {
                      widget.webviewEvent!(args[0], args[1]);
                    }
                  });

              controller.addJavaScriptHandler(
                  handlerName: 'fusionChartEventHandler',
                  callback: (args) {
                    print('FC evenHandler cons: $args');
                    if (widget.fusionChartEvent != null) {
                      widget.fusionChartEvent!(args[0], args[1]);
                    }
                  });
            },
            onConsoleMessage: (controller, message) {
              print('Console Message: ' + message.toString());
            },
          ))
        : const SizedBox();
  }
}
