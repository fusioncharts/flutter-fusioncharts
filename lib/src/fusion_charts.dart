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
  final Function(String eventType, String eventDetail)? webviewEvent;
  final Function(String eventType, String eventDetail)? fusionChartEvent;
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

    if (widget.fusionChartsController == null) {
      _fusionChartsController = FusionChartsController();
    } else {
      _fusionChartsController = widget.fusionChartsController;
    }

    String jsonDataSource = jsonEncode(widget.dataSource);

    String licenseString = "";

    if (widget.licenseKey != null) {
      licenseString = """

      FusionCharts.options.license({
        key:
    "vtA3dB-11wF2A2H2A9C6E5A5F6B3E3E1G2C11tgoB4F1h1fdzoE6F4B-9jH-9D2I3B6A8B6E5G5B1C3D4A1C8B6D1D3D1rmoA32B2B9gC6B5G4zyhA9C5A5vraA2A1A1zbnE2D6G2E3E2B2C6D5C8B4E6aikC3A5RA5moB-9D3G4F2wqE4D2C2pzC1I2A3B-16hE1G3D1fvH4A6B7ueA4D4C3llC7PE7E4uufC2B2C4D8E6B4A3G2F3A28D2C7A6E7C-11==",
    creditLabel: false
      });

    """;
    } else {
      print('Unlicensed Trial');
    }

    jsonDataSource = jsonEncode(jsonDataSource);
    chartString = """

      $licenseString

      let globalFusionCharts;
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
      $registerEvents
    });
    """;

    print(chartString);
    setState(() {
      gotData = true;
    });
  }

  _onLoadComplete() {}

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
            initialFile: fcHome + '/integrate/index.html',
            onLoadStop: (controller, url) async {
              await controller.evaluateJavascript(source: chartString);
            },
            onWebViewCreated: (InAppWebViewController controller) {
              _webViewController = controller;
              _fusionChartsController?.setWebViewController(_webViewController);
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
