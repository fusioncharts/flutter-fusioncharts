import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_fusioncharts/flutter_fusioncharts.dart';
import '../../constants.dart';

class ErrorBar extends StatefulWidget {
  const ErrorBar({super.key});

  @override
  State<ErrorBar> createState() => _ErrorBarState();
}

class _ErrorBarState extends State<ErrorBar> {
  late FusionCharts _fusionChart2D;
  FusionChartsController fc = FusionChartsController();

  @override
  void initState() {
    super.initState();
    WidgetsFlutterBinding.ensureInitialized();

    Map<String, dynamic> chart = {
      "caption": "Machinery lifespan range",
      "subcaption": "Means & standard deviations",
      "xAxisName": "Systems",
      "yAxisName": "Life Span",
      "numberSuffix": " Years",
      "halfErrorBar": "0",
      "theme": "carbon",
      
    };

    List<dynamic> categories = [
      {
        "category": [
          {"label": "Central AC"},
          {"label": "Computers"},
          {"label": "Bar-code Scanners"},
          {"label": "Packaging Machines"},
          {"label": "Chilling Compartments"}
        ]
      }
    ];

    List<dynamic> dataset = [
      {
        "seriesname": "Daly City Serramonte",
        "data": [
          {"value": "8", "errorvalue": "2"},
          {"value": "3", "errorvalue": "0.5"},
          {"value": "2", "errorvalue": "1"},
          {"value": "6", "errorvalue": "1.8"},
          {"value": "8", "errorvalue": "1.2"}
        ]
      },
      {
        "seriesname": "Bakersfield Central",
        "data": [
          {"value": "7", "errorvalue": "1"},
          {"value": "4", "errorvalue": "0.5"},
          {"value": "2", "errorvalue": "1"},
          {"value": "4", "errorvalue": "0.8"},
          {"value": "7", "errorvalue": "1"}
        ]
      },
      {
        "seriesname": "Garden Groove harbour",
        "data": [
          {"value": "9", "errorvalue": "2"},
          {"value": "3", "errorvalue": "0.7"},
          {"value": "3", "errorvalue": "1"},
          {"value": "6", "errorvalue": "1.8"},
          {"value": "7", "errorvalue": "1.2"}
        ]
      }
    ];
    Map<String, dynamic> dataSource = {
      "chart": chart,
      "categories": categories,
      "dataset": dataset

    };

    _fusionChart2D = FusionCharts(
        dataSource: dataSource,
        type: "errorbar2d",
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
          title: const Text('Fusion Charts - Error Bar'),
        ),
        body: Column(
          children: [
            Expanded(child: _fusionChart2D),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Text('Error Bar'),
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
