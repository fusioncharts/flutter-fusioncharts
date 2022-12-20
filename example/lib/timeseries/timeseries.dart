import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_fusioncharts/flutter_fusioncharts.dart';
import '../../constants.dart';
import './ts_data.dart';

class TimeSeries extends StatefulWidget {
  const TimeSeries({super.key});

  @override
  State<TimeSeries> createState() => _TimeSeriesState();
}

class _TimeSeriesState extends State<TimeSeries> {
  late FusionCharts _fusionChart2D;
  FusionChartsController fc = FusionChartsController();

  @override
  void initState() {
    super.initState();
    WidgetsFlutterBinding.ensureInitialized();

    List<dynamic> timeSeriesSchema = [
      {"name": "Time", "type": "date", "format": "%d-%b-%y"},
      {"name": "Grocery Sales Value", "type": "number"}
    ];

    _fusionChart2D = FusionCharts(
        dataSource: const {
          "caption": {"text": "Sales Analysis"},
          "subcaption": {"text": "Grocery"},
          "yAxis": [
            {
              "plot": {"value": "Grocery Sales Value", "type": "column"},
              "format": {"prefix": "\$"},
              "title": "Sale Value"
            }
          ]
        },
        type: "timeseries",
        width: "100%",
        height: "100%",
        timeSeriesSchema: timeSeriesSchema,
        timeSeriesData: timeSeriesData,
        licenseKey: licenseKey,
        fusionChartEvent: callBackFromPlugin,
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
          title: const Text('Fusion Charts - Timeseries'),
        ),
        body: Column(
          children: [
            Expanded(child: _fusionChart2D),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Text('Timeseries'),
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
