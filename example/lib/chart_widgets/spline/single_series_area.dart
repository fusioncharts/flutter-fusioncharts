import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_fusioncharts/flutter_fusioncharts.dart';
import '../../constants.dart';

class SingleSeriesArea extends StatefulWidget {
  const SingleSeriesArea({super.key});

  @override
  State<SingleSeriesArea> createState() => _SingleSeriesAreaState();
}

class _SingleSeriesAreaState extends State<SingleSeriesArea> {
  late FusionCharts _fusionChart2D;
  FusionChartsController fc = FusionChartsController();

  @override
  void initState() {
    super.initState();
    WidgetsFlutterBinding.ensureInitialized();

    Map<String, dynamic> chart = {
      "caption": "Total sales of iPhone",
      "subCaption": "Last month",
      "xAxisName": "Week",
      "yAxisName": "Units sold",
      "xAxisLineThickness": "1",
      "theme": "gammel",
      "baseFontSize": "30px",
      "captionFontSize": "30px",
    };

    List<dynamic> dataset = [
      {"label": "Week 1", "value": "530"},
      {"label": "Week 2", "value": "660"},
      {"label": "Week 3", "value": "420"},
      {"label": "Week 4", "value": "580"},
      {"label": "Week 5", "value": "560"}
    ];


    Map<String, dynamic> dataSource = {
      "chart": chart,
      "data": dataset,
    };

    _fusionChart2D = FusionCharts(
        dataSource: dataSource,
        type: "splinearea",
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
          title: const Text('Fusion Charts - Spline Area'),
        ),
        body: Column(
          children: [
            Expanded(child: _fusionChart2D),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Text('Single Series Spline Area'),
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
