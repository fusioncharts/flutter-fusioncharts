import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_fusioncharts/src/utils/permission_manager.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'dart:convert';
import './utils/constants.dart';
import './fusion_charts_controller.dart';

/// FusionCharts is the widget that renders charts. The plugin user should
/// instantiate this widget and include within the UI widget tree.
class FusionCharts extends StatefulWidget {
  const FusionCharts(
      {required this.dataSource,
      required this.type,
      this.height = "",
      this.width = "",
      this.events = const [],
      this.fusionChartEvent,
      this.fusionChartsController,
      this.streamController,
      this.isLocal = true,
      this.licenseKey,
      super.key});

  final Map<String, dynamic> dataSource;

  /// dataSource is used to supply the data to the FusionCharts JS library
  /// Typically the dousource comprises of 'chart' (Map) and 'dataSet' (List) which
  ///  is used by FusionCharts to render the chart. However dataSource may also have
  /// other objects such as 'annotation'

  final String type;

  /// type of chart that the user want's to render. Example: 'column2d'

  final String width;

  /// The width parameter specifies the width of the rendered chart in % or pixels or rem
  /// It is advisable to keep at 100% and manage the chart size by wrapping within a Container or a SizedBox

  final String height;

  /// The height parameter specifies the height of the rendered chart in % or pixels or rem
  /// It is advisable to keep at 100% and manage the size by wrapping within a Container or a SizedBox

  final List<String> events;

  /// User can use events to specify the list of events that should be subscribed to,
  /// at the chart load event

  final Function? fusionChartEvent;

  /// Callback method on trigger of any subscribed event from the FusionCharts

  final FusionChartsController? fusionChartsController;

  /// fusionChartsController enables the user to add/remove events and call FusionCharts API

  final StreamController? streamController;

  /// User can pass refernce to a streamController which emits periodic updates to real time
  /// data charts. The plugin will listen to events on the streamController and update the chart

  final bool isLocal;

  /// User can specifiy if the charts should be renderd from local JS library or the CDN version
  /// By default the value is true implying local version

  final String? licenseKey;

  /// User can pass a valid license key to avoid Trial watermark on the chart

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
  StreamController<dynamic>? _streamController;
  late InAppWebViewController _webViewController;

  /// _webViewController manages integration with JS library which uses webview plugin

  /// local variables

  late FusionChartsController _fusionChartsController;

  @override
  void initState() {
    super.initState();
    WidgetsFlutterBinding.ensureInitialized();

    _fusionChartsController =
        widget.fusionChartsController ?? FusionChartsController();

    if (widget.streamController != null) {
      _streamController = widget.streamController;

      _streamController?.stream.listen((data) {
        _fusionChartsController
            .executeScript("globalFusionCharts.feedData('$data')");
      }, onDone: () {
        //print("Fusion Chart Done);
      }, onError: (error) {
        //print("Fusion Chart Error: " + error.message);
      });
    }

    String jsonDataSource = jsonEncode(widget.dataSource);

    /// Encoding the data source coming from the user end to pass it into the chart string
    /// This will eventually provide all the chart data necessary to render the chart

    String licenseString = "";

    if (widget.dataSource["chart"]["exportEnabled"] == "1") {
      ///when the export is set to 1, the user will get an export button on the top right corner of the chart
      ///The user will get the permission popup when the export is set to 1
      ///if the permission is granted the exported file will be saved in the fusion charts folder in the internal storage

      PermissionManager().requestPermission();

      ///Permission is asked if not already given

    }

    if (widget.licenseKey != null) {
      licenseString = """

      FusionCharts.options.license({
        key: '${widget.licenseKey}',
        creditLabel: false
      });

    """;

      ///The licensed string is checked whether provided or not
      ///If not provided the unlicensed trial is run

    } else {
      // print('Unlicensed Trial');
    }

    if (widget.events.isNotEmpty) {
      /// Events data is checked if it is coming as empty from the FusionChart object from the user side.

      for (int i = 0; i < widget.events.length; i++) {
        eventString = """
        $eventString

        globalFusionCharts.addEventListener('${widget.events[i]}', chartAddEventsListener)
      
      """;
      }

      ///Manish

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

    /// this multiline string is having the data coming from the user end as well as a js function wrapped inside which will
    /// eventually render the chart for the user

    setState(() {
      gotData = true;

      /// got data is set to true after setting data into the chartString variable
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  String addLeadingZero(int num) {
    return (num <= 9) ? "0" + num.toString() : num.toString();
  }

  @override
  Widget build(BuildContext context) {
    return gotData
        ? Scaffold(
            body: InAppWebView(
              initialOptions: InAppWebViewGroupOptions(
                crossPlatform: InAppWebViewOptions(
                  useOnDownloadStart: true,
                  javaScriptCanOpenWindowsAutomatically: true,
                  javaScriptEnabled: true,
                  useShouldOverrideUrlLoading: true,
                ),
                android: AndroidInAppWebViewOptions(

                  defaultFixedFontSize: 10,
                  useWideViewPort: true,
                  defaultFontSize: 10,
                  minimumLogicalFontSize: 50  ,
                  useHybridComposition: true,
                ),
                ios: IOSInAppWebViewOptions(
                  enableViewportScale: true,
                  sharedCookiesEnabled: true,
                ),
              ),
              initialFile: widget.isLocal
                  ? '$fcHome/integrate/index_local.html'
                  : '$fcHome/integrate/index_cdn.html',
              onLoadStop: (controller, url) async {
                await controller.evaluateJavascript(source: chartString);
                await controller.evaluateJavascript(source: eventString);
              },
              onDownloadStartRequest: (InAppWebViewController controller,
                  DownloadStartRequest request) async {
                PermissionManager().decode(request, widget.type, context);
                String url = (await controller.getUrl()).toString();
              },
              onWebViewCreated: (InAppWebViewController controller) {
                _webViewController = controller;
                _fusionChartsController
                    .setWebViewController(_webViewController);
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
                //       print('Console Message: ' + message.toString());
              },
            ),
          )
        : const SizedBox();
  }
}
