import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_fusioncharts/src/utils/dialogue.dart';
import 'package:flutter_fusioncharts/src/utils/permission_manager.dart';
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
      this.fusionChartEvent,
      this.version = "latest",
      this.licenseKey,
      this.events = const [],
      this.fusionChartsController,
      this.streamController,
      super.key});

  final Map<String, dynamic> dataSource;
  final String type;
  final String width;
  final String height;
  final StreamController? streamController;
  final Function(String eventType, String eventDetail)? fusionChartEvent;
  final List<String> events;
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
  String eventString = "";
  bool fcLoaded = false;
  late InAppWebViewController _webViewController;
  late FusionChartsController _fusionChartsController;
  @override
  void initState() {
    super.initState();
    WidgetsFlutterBinding.ensureInitialized();

    String jsonDataSource = jsonEncode(widget.dataSource);
    _fusionChartsController =
        widget.fusionChartsController ?? FusionChartsController();

    String licenseString = "";
    if (widget.dataSource["chart"]["exportEnabled"] == "1") {
      PermissionManager().requestPermission();
    }

    if (widget.licenseKey != null) {
      licenseString = """

      FusionCharts.options.license({
        key: '${widget.licenseKey}',
        creditLabel: false
      });

    """;
    } else {
      print('Unlicensed Trial');
    }

    if (widget.events.isNotEmpty) {
      for (int i = 0; i < widget.events.length; i++) {
        eventString = """
        $eventString

        globalFusionCharts.addEventListener('${widget.events[i]}', chartAddEventsListener)
      
      """;
      }
    }
    jsonDataSource = jsonEncode(jsonDataSource);
    chartString = """

      $licenseString

      FusionCharts.ready(function() {
        var fusionChart = new FusionCharts({
        type: "${widget.type}",
        width: "${widget.width}",
        height: "${widget.height}",
        renderAt: "chart-container",
        dataFormat: "json",
        dataSource: $jsonDataSource   
      });
      
      fusionChart.render();
      globalFusionCharts = fusionChart;
    });

    $eventString
    
    """;
    int x = 0;
    setState(() {
      gotData = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return gotData
        ? InAppWebView(
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
            initialFile: '$fcHome/integrate/index.html',
            onLoadStop: (controller, url) async {
              await controller.evaluateJavascript(source: chartString);
              await controller.evaluateJavascript(source: eventString);
            },
            onDownloadStartRequest: (InAppWebViewController controller,
                DownloadStartRequest request) async {
              print(controller.getUrl());

              String url = (await controller.getUrl()).toString();
              print("url:" + url);
              showDialog(
                context: context,
                builder: (context) =>
                    DownloadingDialog(fileName: widget.type, request: request),
              );
            },
            onWebViewCreated: (InAppWebViewController controller) {
              _webViewController = controller;

              _webViewController.addJavaScriptHandler(
                  handlerName: "webviewEvent",
                  callback: (args) {
                    print("Webview Event: " + args.toString());
                  });

              _fusionChartsController.setWebViewController(_webViewController);
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
          )
        : const SizedBox();
  }
}
