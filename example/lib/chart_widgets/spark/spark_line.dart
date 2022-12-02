import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_fusioncharts/flutter_fusioncharts.dart';
import '../../constants.dart';

class SparkLine extends StatefulWidget {
  const SparkLine({super.key});

  @override
  State<SparkLine> createState() => _SparkLineState();
}

class _SparkLineState extends State<SparkLine> {
  late FusionCharts _fusionChart2D;
  FusionChartsController fc = FusionChartsController();

  @override
  void initState() {
    super.initState();
    WidgetsFlutterBinding.ensureInitialized();

    Map<String, dynamic> chart = {
      "caption": "Stock Price",
      "subcaption": "Last month",
      "numberPrefix": "\$",
      "canvasleftmargin": "145",
      "chartTopMargin": "10",
      "chartRightMargin": "10",
      "theme": "candy",
      "baseFontSize": "30px",
      "captionFontSize": "30px",
    };

    List<dynamic> dataset = [
      {
        "data": [
          {"value": "38.42"},
          {"value": "41.43"},
          {"value": "34.78"},
          {"value": "40.67"},
          {"value": "44.12"},
          {"value": "38.45"},
          {"value": "40.71"},
          {"value": "49.90"},
          {"value": "40.12"},
          {"value": "34.91"},
          {"value": "42.02"},
          {"value": "35.21"},
          {"value": "43.31"},
          {"value": "40.21"},
          {"value": "40.54"},
          {"value": "40.90"},
          {"value": "54.21"},
          {"value": "41.90"},
          {"value": "33.43"},
          {"value": "46.73"},
          {"value": "50.42"},
          {"value": "40.74"},
          {"value": "42.31"},
          {"value": "50.39"},
          {"value": "51.10"},
          {"value": "44.84"},
          {"value": "51.64"},
          {"value": "47.62"},
          {"value": "39.61"},
          {"value": "35.13"}
        ]
      }
    ];
    Map<String, dynamic> dataSource = {
      "chart": chart,
      "dataset": dataset,
    };

    _fusionChart2D = FusionCharts(
        dataSource: dataSource,
        type: "sparkline",
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
          title: const Text('Fusion Charts - Spark Line'),
        ),
        body: Column(
          children: [
            Expanded(child: _fusionChart2D),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Text('Spark Line'),
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
