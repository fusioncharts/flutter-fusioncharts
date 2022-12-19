import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_fusioncharts/flutter_fusioncharts.dart';
import '../../constants.dart';

class SparkColumn extends StatefulWidget {
  const SparkColumn({super.key});

  @override
  State<SparkColumn> createState() => _SparkColumnState();
}

class _SparkColumnState extends State<SparkColumn> {
  late FusionCharts _fusionChart2D;
  FusionChartsController fc = FusionChartsController();

  @override
  void initState() {
    super.initState();
    WidgetsFlutterBinding.ensureInitialized();

    Map<String, dynamic> chart = {
      "caption": "Revenue by Month",
      "subcaption": "Last year",
      "chartTopMargin": "10",
      "chartBottomMargin": "10",
      "chartRightMargin": "10",
      "numberPrefix": "\$",
      "theme": "fusion",
      
    };

    List<dynamic> dataset = [
      {
        "data": [
          {"value": "783000"},
          {"value": "601000"},
          {"value": "515000"},
          {"value": "315900"},
          {"value": "388000"},
          {"value": "433000"},
          {"value": "910000"},
          {"value": "798000"},
          {"value": "483300"},
          {"value": "562000"},
          {"value": "359400"},
          {"value": "485000"}
        ]
      }
    ];
    Map<String, dynamic> dataSource = {
      "chart": chart,
      "dataset": dataset,
    };

    _fusionChart2D = FusionCharts(
        dataSource: dataSource,
        type: "sparkcolumn",
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
          title: const Text('Fusion Charts - Spark Column'),
        ),
        body: Column(
          children: [
            Expanded(child: _fusionChart2D),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Text('Spark Column'),
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
