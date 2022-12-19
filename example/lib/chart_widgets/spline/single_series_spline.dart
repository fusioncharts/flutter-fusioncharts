import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_fusioncharts/flutter_fusioncharts.dart';
import '../../constants.dart';

class SingleSeriesSpline extends StatefulWidget {
  const SingleSeriesSpline({super.key});

  @override
  State<SingleSeriesSpline> createState() => _SingleSeriesSplineState();
}

class _SingleSeriesSplineState extends State<SingleSeriesSpline> {
  late FusionCharts _fusionChart2D;
  FusionChartsController fc = FusionChartsController();

  @override
  void initState() {
    super.initState();
    WidgetsFlutterBinding.ensureInitialized();

    Map<String, dynamic> chart = {
      "caption": "Total footfall in Bakersfield Central",
      "subCaption": "Last week",
      "xAxisName": "Day",
      "yAxisName": "No. of Footfalls",
      "lineThickness": "2",
      "theme": "fusion",
      
    };

    List<dynamic> dataset = [
      {"label": "Mon", "value": "15123"},
      {"label": "Tue", "value": "14233"},
      {"label": "Wed", "value": "25507"},
      {
        "vline": "true",
        "lineposition": "0",
        "color": "#6baa01",
        "labelHAlign": "left",
        "label": "National holiday"
      },
      {"label": "Thu", "value": "9110"},
      {"label": "Fri", "value": "15529"},
      {"label": "Sat", "value": "20803"},
      {"label": "Sun", "value": "19202"}
    ];

    Map<String, dynamic> dataSource = {
      "chart": {
        "theme": "fusion",
        "caption": "Total footfall in Bakersfield Central",
        "subCaption": "Last week",
        "xAxisName": "Day",
        "yAxisName": "No. of Footfalls",
        "lineThickness": "2",
        "divlineAlpha": "100",
        "divlineColor": "#999999",
        "divlineThickness": "1",
        "divLineIsDashed": "1",
        "divLineDashLen": "1",
        "divLineGapLen": "1",
        "showXAxisLine": "1",
        "xAxisLineThickness": "1"
      },
      "data": [
        {"label": "Mon", "value": "15123"},
        {"label": "Tue", "value": "14233"},
        {"label": "Wed", "value": "25507"},
        {"label": "Thu", "value": "9110"},
        {"label": "Fri", "value": "15529"},
        {"label": "Sat", "value": "20803"},
        {"label": "Sun", "value": "19202"},
      ],
    };

    _fusionChart2D = FusionCharts(
        dataSource: dataSource,
        type: "spline",
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
          title: const Text('Fusion Charts - Spline'),
        ),
        body: Column(
          children: [
            Expanded(child: _fusionChart2D),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Text('Single Series Spline'),
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
