import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_fusioncharts/flutter_fusioncharts.dart';
import '../../constants.dart';

class SparkWinLoss extends StatefulWidget {
  const SparkWinLoss({super.key});

  @override
  State<SparkWinLoss> createState() => _SparkWinLossState();
}

class _SparkWinLossState extends State<SparkWinLoss> {
  late FusionCharts _fusionChart2D;
  FusionChartsController fc = FusionChartsController();

  @override
  void initState() {
    super.initState();
    WidgetsFlutterBinding.ensureInitialized();

    Map<String, dynamic> chart = {
      "caption": "On-target sales by month",
      "subcaption": "Last year",
      "numberPrefix": "\$",
      "chartTopMargin": "10",
      "chartBottomMargin": "10",
      "chartRightMargin": "10",
      "theme": "zune",
      
    };

    List<dynamic> dataset = [
      {
        "data": [
          {"value": "W"},
          {"value": "W"},
          {"value": "W"},
          {"value": "L"},
          {"value": "W"},
          {"value": "W"},
          {"value": "L"},
          {"value": "L"},
          {"value": "W"},
          {"value": "L"},
          {"value": "W"},
          {"value": "W"}
        ]
      }
    ];
    Map<String, dynamic> dataSource = {
      "chart": chart,
      "dataset": dataset,
    };

    _fusionChart2D = FusionCharts(
        dataSource: dataSource,
        type: "sparkwinloss",
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
          title: const Text('Fusion Charts - Spark Win/Loss'),
        ),
        body: Column(
          children: [
            Expanded(child: _fusionChart2D),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Text('Spark Win/Loss'),
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
