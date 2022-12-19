import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_fusioncharts/flutter_fusioncharts.dart';
import '../../constants.dart';

class InverseArea extends StatefulWidget {
  const InverseArea({super.key});

  @override
  State<InverseArea> createState() => _InverseAreaState();
}

class _InverseAreaState extends State<InverseArea> {
  late FusionCharts _fusionChart2D;
  FusionChartsController fc = FusionChartsController();

  @override
  void initState() {
    super.initState();
    WidgetsFlutterBinding.ensureInitialized();

    Map<String, dynamic> chart = {
      "caption": "Daily bounce rate",
      "subCaption": "Last week",
      "xAxisName": "Day",
      "yAxisName": "Percentage",
      "numberSuffix": "%",
      "plotFillAlpha": "50",
      "theme": "fusion",
      
    };

    List<dynamic> categories = [
      {
        "category": [
          {"label": "Mon"},
          {"label": "Tue"},
          {"label": "Wed"},
          {"label": "Thu"},
          {"label": "Fri"},
          {"label": "Sat"},
          {"label": "Sun"}
        ]
      }
    ];

    List<dynamic> dataset = [
      {
        "seriesname": "food.hsm.com",
        "data": [
          {"value": "27"},
          {"value": "22"},
          {"value": "25"},
          {"value": "27"},
          {"value": "21"},
          {"value": "29"},
          {"value": "22"}
        ]
      },
      {
        "seriesname": "cloth.hsm.com",
        "data": [
          {"value": "42"},
          {"value": "38"},
          {"value": "39"},
          {"value": "36"},
          {"value": "43"},
          {"value": "44"},
          {"value": "35"}
        ]
      }
    ];
    Map<String, dynamic> dataSource = {
      "chart": chart,
      "categories": categories,
      "dataset":dataset
    };

    _fusionChart2D = FusionCharts(
        dataSource: dataSource,
        type: "InverseMSArea",
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
          title: const Text('Fusion Charts - Inverse Area'),
        ),
        body: Column(
          children: [
            Expanded(child: _fusionChart2D),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Text('Inverse Area'),
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
