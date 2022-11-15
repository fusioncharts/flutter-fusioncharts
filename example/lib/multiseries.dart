import 'package:flutter/material.dart';
import 'package:flutter_fusioncharts/flutter_fusioncharts.dart';
import './constants.dart';

class MultiSeries extends StatefulWidget {
  const MultiSeries({super.key});

  @override
  State<MultiSeries> createState() => _MultiSeriesState();
}

class _MultiSeriesState extends State<MultiSeries> {
  late FusionCharts _fusionChart;
  void initState() {
    super.initState();
    WidgetsFlutterBinding.ensureInitialized();

    List<dynamic> categories = [
      {
        "category": [
          {"label": "Q1"},
          {"label": "Q2"},
          {"label": "Q3"},
          {"label": "Q4"}
        ]
      }
    ];
    // Construct the dataset comprising multiple series
    List<dynamic> dataset = [
      {
        "seriesname": "Previous Year",
        "data": [
          {"value": "12000"},
          {"value": "10500"},
          {"value": "23500"},
          {"value": "16000"}
        ]
      },
      {
        "seriesname": "Current Year",
        "data": [
          {"value": "24400"},
          {"value": "29800"},
          {"value": "20800"},
          {"value": "26800"}
        ]
      }
    ];

    Map<String, dynamic> chart = {
      "theme": "fusion",
      "caption": "Comparison of Quarterly Sales",
      "xAxisname": "Quarter",
      "yAxisName": "Sales"
    };

    Map<String, dynamic> dataSource = {
      "chart": chart,
      "dataset": dataset,
      "categories": categories
    };

    _fusionChart = FusionCharts(
        dataSource: dataSource,
        type: "mscolumn2d",
        width: "100%",
        height: "100%",
        callBackFromPlugin: callBackFromPlugin,
        licenseKey: licenseKey);
  }

  void callBackFromPlugin(arg1, arg2) {
    print('Back to consumer: $arg1 , $arg2');
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          leading: IconButton(
              onPressed: () => Navigator.of(context).pop(),
              icon: const Icon(Icons.arrow_back)),
          title: const Text('Fusion Charts - MultiSeries'),
        ),
        body: Center(child: _fusionChart),
      ),
    );
  }
}
