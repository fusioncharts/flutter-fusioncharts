import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_fusioncharts/flutter_fusioncharts.dart';
import '../../constants.dart';

class Radar extends StatefulWidget {
  const Radar({super.key});

  @override
  State<Radar> createState() => _RadarState();
}

class _RadarState extends State<Radar> {
  late FusionCharts _fusionChart2D;

  @override
  void initState() {
    super.initState();
    WidgetsFlutterBinding.ensureInitialized();

    Map<String, dynamic> chart = {
      "caption": "Budget analysis",
      "subCaption": "Current month",
      "numberPrefix": "\$",
      "theme": "umber",
      "baseFontSize": "30px",
      "captionFontSize": "30px",
    };
    List<dynamic> dataset = [
      {
        "seriesname": "Allocated Budget",
        "data": [
          {"value": "19000"},
          {"value": "16500"},
          {"value": "14300"},
          {"value": "10000"},
          {"value": "9800"}
        ]
      },
      {
        "seriesname": "Actual Cost",
        "data": [
          {"value": "6000"},
          {"value": "9500"},
          {"value": "11900"},
          {"value": "8000"},
          {"value": "9700"}
        ]
      }
    ];

    List<dynamic> categories = [
      {
        "category": [
          {"label": "Marketing"},
          {"label": "Product Management"},
          {"label": "Customer Service"},
          {"label": "Human Resource"},
          {"label": "Sales & Distribution"}
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
        type: "radar",
        width: "100%",
        height: "100%",
        licenseKey: licenseKey);
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
              onPressed: () => Navigator.of(context).pop(),
              icon: const Icon(Icons.arrow_back)),
          title: const Text('Fusion Charts - Radar'),
        ),
        body: Column(
          children: [
            Expanded(child: _fusionChart2D),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Text('Radar Chart'),
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
