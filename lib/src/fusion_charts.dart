import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
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
  late Uint8List base64decode;
  late String fileName;
  var data;
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

  void showSnack(String title) {
    final snackbar = SnackBar(
        content: Text(
      title,
      textAlign: TextAlign.center,
      style: const TextStyle(
        fontSize: 15,
      ),
    ));
    ScaffoldMessenger.of(context).showSnackBar(snackbar);
  }

  /// This is the snackbar funtion that is invoked when the file is downloaded or when the
  /// download permission is not given and the user is trying to export the file

  decode(request) {
    fileName = request.suggestedFilename.toString().split('.')[1];

    ///The file name variable is initialised with suggested file name from the download request callback of the in app web view

    if (fileName == 'svg' ||
        fileName == 'png' ||
        fileName == 'jpg' ||
        fileName == 'pdf') {
      base64decode = base64.decode(request.url.toString().split(';base64,')[1]);
    } else {
      base64decode = base64.decode(request.url.toString().split('/')[1]);
    }

    print(request.url);
    print(request);

    ///The file name is checked accordingly and the data that comes with it is decoded accordingly

    saveFile();

    ///Save file is called to save the file after decoding the data
  }

  createFolder() async {
    try {
      String folderName = "fusionCharts";

      ///This is the name of the folder that is created on the device when user exports charts

      final path = Directory("storage/emulated/0/$folderName");

      ///Path of the folder name

      if ((await path.exists())) {
      } else {
        path.create();
      }
      return path.path;
    } catch (e) {
      // print(e.message);
    }
  }

  saveFile() async {
    try {
      /// saveFile saves the downloaded file into the external storage

      if (PermissionManager().requestStatus == RequestStatus.denied) {
        /// here the permission request is checked if it is granted or not
        /// to save the file the permission to write in external storage should be given

        showSnack('Permission denied for storage');

        ///Snackbar alert when the permission is not given

      } else {
        final path = await createFolder();

        /// path of the folder where the imports will be saved

        data = await File('$path/${widget.type}.$fileName')
            .writeAsBytes(base64decode, flush: true);

        showSnack('Downloaded ${widget.type}');

        /// Snackbar alert is shown once the file is created

      }
    } catch (e) {
      // print(e.message);
    }
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
                  useHybridComposition: true,
                ),
                ios: IOSInAppWebViewOptions(
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
                decode(request);
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
