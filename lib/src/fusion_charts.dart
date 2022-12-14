import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_fusioncharts/src/utils/permission_manager.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'dart:convert';
import './utils/constants.dart';
import './fusion_charts_controller.dart';

class FusionCharts extends StatefulWidget {



  const FusionCharts(
      {
        required this.dataSource,

        ///this is the data source which is of the type map
        ///It has all the data tha a user is wishing to display using this plugin







      required this.type,


        ///this is the type of chart that a user want's to render
        ///if the user wants to render a simple column chart then he can use the string column2d as chart type.








      this.height = "",

        /// The height parameter specifies the height of the rendered chart
        /// when kep at 100% it takes all the available space of its parent widget in terms of height








      this.width = "",

        /// The width parameter specifies the width of the rendered chart
        /// when kep at 100% it takes all the available space of its parent widget in terms of width








      this.fusionChartEvent,


        ///Manish will write






      this.version = "latest",

        ///This refers to the version of fusion charts library used







      this.licenseKey,

        /// this is the license key which is required to render the charts






      this.events = const [],


        ///Manish will write this







      this.fusionChartsController,

        /// Fusion charts controller is handling events and scripts





      this.streamController,

        ///Stream controller is used ti listen to the stream of events


      super.key


      });





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
  /// variable to store the version of the fusion chart core library







  String? licenseKey;
  /// variable to store the license key of the fusion chart core library







  String chartString = "";
  /// variable to store the chart string






  bool gotData = false;
  /// when the chart is rendered this is set to true to load the chart on the UI








  String json = "";
  ///manish








  String eventString = "";
  ///variable to start the event string coming from the fusion chart object







  StreamController<dynamic>? _streamController;
  /// Stream controller to track the stream of the real time data and update the chart according to it







  late InAppWebViewController _webViewController;
  /// Web viewer controller to control the functions of web view when it is loaded in the UI







  late Uint8List base64decode;
  ///This variable is used to save the decoded base64 code coming from the webview side








  late String fileName;
  ///This variable is used to store the suggested file names coming from the web view download callback








  var data;
  /// This variable is used to check whether the data is downloaded in the internal storage or not







  late FusionChartsController _fusionChartsController;
  /// Manish






  @override
  void initState() {
    super.initState();
    WidgetsFlutterBinding.ensureInitialized();


    _fusionChartsController =
        widget.fusionChartsController ?? FusionChartsController();




    if (widget.streamController != null) {




      _streamController = widget.streamController;
      ///Initialising stream controller from the FusionChart object coming from the user side.


      _streamController?.stream.listen((event) {
        print('Event: $event');

        _fusionChartsController
            .executeScript("globalFusionCharts.feedData('" + event + "')");
        /// Executing the script using the fusion chart controller




      },



          onDone: () {
        _streamController = null;




      },


          onError: (error) => {print("Ignore Error: " + error)});




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
      print('Unlicensed Trial');
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

    ///The file name is checked accordingly and the data that comes with it is decoded accordingly









    saveFile();

    ///Save file is called to save the file after decoding the data








  }

  folderCreate() async {
    String folderName = "fusionCharts";

    ///This is the name of the folder that is made in the internal storage when user is exporting the files





    final path = Directory("storage/emulated/0/$folderName");

    ///Path of the folder name





    if ((await path.exists())) {
    } else {
      path.create();
    }
    return path.path;
  }



  saveFile() async {

    /// This method is for saving the downloaded file into the external storage








    if (PermissionManager().requestStatus == RequestStatus.denied) {








      /// here the permission request is checked if it is granted or not
      /// to save the file the permission to write in external storage should be given

      showSnack('Permission denied for storage');

      ///Snackbar alert when the permission is not given







    } else {




      final path = await folderCreate();

      /// path of the folder where the imports will be saved




      data = await File('$path/${widget.type}.$fileName')
          .writeAsBytes(base64decode, flush: true);
      showSnack('Downloaded ${widget.type}');

      ///Here the file is saved in the internal storage and a snackbar alert is shown is shown to alert the user that
      ///this particular file has been downloaded









    }
  }

  String addLeadingZero(int num) {
    return (num <= 9) ? "0" + num.toString() : num.toString();
  }
  ///Manish


  @override
  Widget build(BuildContext context) {
    return gotData
    ///Checking if there is valid data that user has passed onto the FusionChart plugin object






        ? Scaffold(

            body: InAppWebView(
              /// Flutter InAppWebView is used here to render the Fusion Charts on the mobile devices




              initialOptions: InAppWebViewGroupOptions(
                crossPlatform: InAppWebViewOptions(
                  useOnDownloadStart: true,
                  javaScriptCanOpenWindowsAutomatically: true,
                  javaScriptEnabled: true,
                  useShouldOverrideUrlLoading: true,
                  ///These are the cross platform configurations for the webview



                ),
                android: AndroidInAppWebViewOptions(
                  useHybridComposition: true,
                  /// This is android specific configuration



                ),
                ios: IOSInAppWebViewOptions(
                  sharedCookiesEnabled: true,
                  /// This is IOS specific configuration



                ),
              ),




              initialFile: '$fcHome/integrate/index.html',

              ///Manish
              onLoadStop: (controller, url) async {
                await controller.evaluateJavascript(source: chartString);
                await controller.evaluateJavascript(source: eventString);
                ///Manish
              },
              onDownloadStartRequest: (InAppWebViewController controller,
                  DownloadStartRequest request) async {
                  decode(request);
                  ///This is the download start request function which is invoked when the user exports the file
                  ///Here we get the data of the exported file and that data is getting decoded and saved in the internal storage with the
                  ///help of the funtions defined earlier


                String url = (await controller.getUrl()).toString();

              },
              onWebViewCreated: (InAppWebViewController controller) {

                ///Manish
                _webViewController = controller;

                _webViewController.addJavaScriptHandler(
                    handlerName: "webviewEvent",
                    callback: (args) {
                      print("Webview Event: " + args.toString());
                    });

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
                ///Manish
                print('Console Message: ' + message.toString());
              },
            ),
          )
        : const SizedBox();
  }
}
