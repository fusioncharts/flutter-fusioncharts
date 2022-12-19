import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_fusioncharts/flutter_fusioncharts.dart';
import '../../constants.dart';

class LogColumn extends StatefulWidget {
  const LogColumn({super.key});

  @override
  State<LogColumn> createState() => _LogColumnState();
}

class _LogColumnState extends State<LogColumn> {
  late FusionCharts _fusionChart2D;
  FusionChartsController fc = FusionChartsController();

  @override
  void initState() {
    super.initState();
    WidgetsFlutterBinding.ensureInitialized();

    Map<String, dynamic> chart = {
      "caption": "Store footfall vs Online visitors ",
      "subCaption": "Last Year",
      "xAxisName": "Quarter",
      "yAxisName": "No of visitors",
      "base": "10",
      "theme": "candy",
      
    };

    List<dynamic> dataset = [
      {
        "seriesname": "Total footfalls",
        "data": [
          {"value": "126734"},
          {"value": "159851"},
          {"value": "197393"},
          {"value": "168560"},
          {"value": "199428"}
        ]
      },
      {
        "seriesname": "Online Visits",
        "data": [
          {"value": "1126059"},
          {"value": "1292145"},
          {"value": "1496849"},
          {"value": "1460249"},
          {"value": "1083962"}
        ]
      }
    ];

    List<dynamic> categories = [
      {
        "category": [
          {"label": "Q1"},
          {"label": "Q2"},
          {"label": "Q3"},
          {"label": "Q4"}
        ]
      }
    ];

    Map<String, dynamic> dataSource = {
      "chart": chart,
      "categories": categories,
      "dataset": dataset,
    };

    _fusionChart2D = FusionCharts(
        dataSource: dataSource,
        type: "LogMSColumn2D",
        width: "100%",
        height: "100%",
        licenseKey: licenseKey,
        fusionChartEvent: (eventType, eventDetail) =>
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content:
                    Text("Event Raised: $eventType + Details: $eventDetail"))),
        fusionChartsController: fc);
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
          title: const Text('Fusion Charts - Log Column'),
        ),
        body: Column(
          children: [
            SizedBox(
                height: MediaQuery.of(context).size.height / 2,
                child: _fusionChart2D),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Text('Logarithmic Column'),
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
