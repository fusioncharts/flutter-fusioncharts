import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_fusioncharts/flutter_fusioncharts.dart';
import '../../constants.dart';

class MultiSeriesSpline extends StatefulWidget {
  const MultiSeriesSpline({super.key});

  @override
  State<MultiSeriesSpline> createState() => _MultiSeriesSplineState();
}

class _MultiSeriesSplineState extends State<MultiSeriesSpline> {
  late FusionCharts _fusionChart2D;
  FusionChartsController fc = FusionChartsController();

  @override
  void initState() {
    super.initState();
    WidgetsFlutterBinding.ensureInitialized();

    Map<String, dynamic> chart = {
      "caption": "Number of visitors last week",
      "subCaption": "Bakersfield Central vs Los Angeles Topanga",
      "xAxisName": "Day",
      "yAxisName": "No. of Visitor",
      "theme": "fusion",
      "baseFontSize": "30px",
      "captionFontSize": "30px",
    };

    List<dynamic> categories = [
      {
        "category": [
          {"label": "Mon"},
          {"label": "Tue"},
          {"label": "Wed"},
          {
            "vline": "true",
            "lineposition": "0",
            "color": "#6baa01",
            "labelHAlign": "right",
            "labelPosition": "0",
            "label": "National holiday"
          },
          {"label": "Thu"},
          {"label": "Fri"},
          {"label": "Sat"},
          {"label": "Sun"}
        ]
      }
    ];

    List<dynamic> dataset = [
      {
        "seriesname": "Bakersfield Central",
        "data": [
          {"value": "15123"},
          {"value": "14233"},
          {"value": "25507"},
          {"value": "9110"},
          {"value": "15529"},
          {"value": "20803"},
          {"value": "19202"}
        ]
      },
      {
        "seriesname": "Los Angeles Topanga",
        "data": [
          {"value": "13400"},
          {"value": "12800"},
          {"value": "22800"},
          {"value": "12400"},
          {"value": "15800"},
          {"value": "19800"},
          {"value": "21800"}
        ]
      }
    ];

    Map<String, dynamic> dataSource = {
      "chart": chart,
      "dataset": dataset,
      "categories": categories
    };

    _fusionChart2D = FusionCharts(
        dataSource: dataSource,
        type: "msspline",
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
          title: const Text('Fusion Charts - MS Spline'),
        ),
        body: Column(
          children: [
            Expanded(child: _fusionChart2D),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Text('Multi Series Spline'),
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
