import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_fusioncharts/flutter_fusioncharts.dart';
import '../../constants.dart';
import 'dart:async';

class RealTimeArea extends StatefulWidget {
  const RealTimeArea({super.key});

  @override
  State<RealTimeArea> createState() => _RealTimeAreaState();
}

class _RealTimeAreaState extends State<RealTimeArea> {
  late FusionCharts _fusionChart2D;
  FusionChartsController fc = FusionChartsController();
  int currentDatasetCount = 1;
  final streamController = StreamController<String>();
  bool cancel = false;
  List<dynamic> dataset = [
    {"data": 35.65, "label": "Mon"},
    {"data": 35.15, "label": "Tue"},
    {"data": 35.75, "label": "Wed"},
    {"data": 35.25, "label": "Thu"},
    {"data": 35.89, "label": "Fri"},
    {"data": 35.12, "label": "Sat"},
    {"data": 35.42, "label": "Sun"}
  ];

  @override
  void dispose() {
    cancel = true;
    fc.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    WidgetsFlutterBinding.ensureInitialized();
    Timer timer;
    Map<String, dynamic> chart = {
      "caption": "Real-time stock price monitor",
      "subCaption": "Harry's SuperMart",
      "xAxisName": "Time",
      "yAxisName": "Stock Price",
      "numberPrefix": "\$",
      "refreshinterval": "5",
      "updateinterval": "5",
      "yaxisminvalue": "35",
      "yaxismaxvalue": "36",
      "numdisplaysets": "20",
      "labeldisplay": "rotate",
      "showRealTimeValue": "1",
      "theme": "fusion"
    };

    List<dynamic> categories = [
      {
        "category": [
          {"label": "Day Start"}
        ]
      }
    ];

    Map<String, dynamic> dataSource = {
      "chart": chart,
      "categories": categories,
      "dataset":
          '&label=${dataset[currentDatasetCount]["label"]}&value=${dataset[currentDatasetCount]["data"]}'
    };

    _fusionChart2D = FusionCharts(
      dataSource: dataSource,
      type: "realtimearea",
      width: "100%",
      height: "100%",
      licenseKey: licenseKey,
      fusionChartEvent: callBackFromPlugin,
      streamController: streamController,
      fusionChartsController: fc,
    );

    updateDataset();
  }

  void updateDataset() {
    Timer.periodic(const Duration(seconds: 3), (timer) {
      if (cancel) timer.cancel;

      if (currentDatasetCount == dataset.length - 1) {
        currentDatasetCount = 0;
      }

      String nextData =
          '&label=${dataset[currentDatasetCount]["label"]}&value=${dataset[currentDatasetCount]["data"]}';

      streamController.add(nextData);
      currentDatasetCount++;
      if (mounted) {
        setState(() {});
      }
    });
  }

  void callBackFromPlugin(arg1, arg2) {
    if (kDebugMode) {
      print('Back to consumer: $arg1 , $arg2');
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => Navigator.of(context).pop()),
          title: const Text('Fusion Charts - RealTime Area'),
        ),
        body: Column(
          children: [
            SizedBox(
                height: MediaQuery.of(context).size.width,
                child: _fusionChart2D),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Text('RealTime Area'),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
          ],
        ),
      ),
    );
  }
}
