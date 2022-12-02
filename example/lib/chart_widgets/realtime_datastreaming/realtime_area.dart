import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_fusioncharts/flutter_fusioncharts.dart';
import '../../constants.dart';
import 'dart:async';

class RealTimeArea extends StatefulWidget {
  const RealTimeArea({super.key});

  @override
  State<RealTimeArea> createState() => _RealTimeAreaState();
}

class _RealTimeAreaState extends State<RealTimeArea> {
  late FusionCharts _fusionChart2D;
  FusionChartsController fc = FusionChartsController();

  @override
  void initState() {
    super.initState();
    WidgetsFlutterBinding.ensureInitialized();

    Map<String, dynamic> chart = {
      "caption": "Real-time stock price monitor",
      "subCaption": "Harry's SuperMart",
      "xAxisName": "Time",
      "yAxisName": "Stock Price",
      "numberPrefix": "\$",
      "refreshinterval": "5",
      "updateinterval": "5",
      "yaxisminvalue": "35",
      "yaxismaxvalue": "36",
      "numdisplaysets": "20",
      "labeldisplay": "rotate",
      "showRealTimeValue": "1",
      "theme": "fusion"
    };

    List<dynamic> categories = [{"category": [{"label": "Day Start"}]}];
    List<dynamic> dataset = [{"data": [{"value": "35.27"}]}];

    Map<String, dynamic> dataSource = {
      "chart": chart,
      "categories": categories,
      "dataset": dataset
    };

    _fusionChart2D = FusionCharts(
        dataSource: dataSource,
        type: "realtimearea",
        width: "100%",
        height: "100%",
        licenseKey: licenseKey,
        fusionChartEvent: (eventType, eventDetail) =>
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content:
                Text("Event Raised: $eventType + Details: $eventDetail"))),
        fusionChartsController: fc,
    );
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
          title: const Text('Fusion Charts - RealTime Area'),
        ),
        body: Column(
          children: [
            Expanded(child: _fusionChart2D),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Text('RealTime Area'),
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
