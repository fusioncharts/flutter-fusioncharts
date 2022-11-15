import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'dart:convert';

import './utils/constants.dart';

class FusionCharts extends StatefulWidget {
  const FusionCharts(
      {required this.dataSource,
      required this.type,
      this.height = "",
      this.width = "",
      required this.callBackFromPlugin,
      this.version = "latest",
      this.licenseKey,
      this.events = const [],
      super.key});

  final Map<String, dynamic> dataSource;
  final String type;
  final String width;
  final String height;
  final Function callBackFromPlugin;
  final String? licenseKey;
  final String? version;
  final List<String> events;

  @override
  State<FusionCharts> createState() => _FusionChartsState();
}

class _FusionChartsState extends State<FusionCharts> {
  String? version;
  String? licenseKey;
  String chartString = "";

  bool gotData = false;
  String json = "";

  @override
  void initState() {
    super.initState();
    WidgetsFlutterBinding.ensureInitialized();

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
            dataSource: $jsonDataSource,
              
            });

      $registerEvents

      fusionChart.render();
    
    });
    """;
    
    // "dataset": $jsonDataset,
    // "categories": $jsonCategories
    setState(() {
      gotData = true;
    });
  }

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
              controller.addJavaScriptHandler(
                  handlerName: 'eventHandler',
                  callback: (args) {
                    print('evenHandler : $args');
                    widget.callBackFromPlugin(args[0], args[1]);
                  });
            },
            onConsoleMessage: (controller, message) {
              print('Console Message: ' + message.toString());
            },
          ))
        : const SizedBox();
  }
}
