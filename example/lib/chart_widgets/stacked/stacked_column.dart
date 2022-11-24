import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_fusioncharts/flutter_fusioncharts.dart';
import 'package:flutter_fusioncharts_example/chartdata.dart';
import '../../constants.dart';

class StackedColumn extends StatefulWidget {
  const StackedColumn({super.key});

  @override
  State<StackedColumn> createState() => _StackedColumnState();
}

class _StackedColumnState extends State<StackedColumn> {
  late FusionCharts _fusionChart2D;
  late FusionCharts _fusionChart3D;

  @override
  void initState() {
    super.initState();
    WidgetsFlutterBinding.ensureInitialized();

    Map<String, dynamic> chart = {
      "caption": "Product-wise quarterly revenue in current year",
      "subCaption": "Harry's SuperMart",
      "xAxisname": "Quarter",
      "yAxisName": "Revenue (In USD)",
      "numberPrefix": "\$",
      "theme": "fusion"
    };
    FusionChartsController fusionChartsController = FusionChartsController();
    Map<String, dynamic> dataSource = {
      "chart": chart,
      "data": ChartData.chartData3,
      "categories": [
        {
          "category": [
            {"label": "Q1"},
            {"label": "Q2"},
            {"label": "Q3"},
            {"label": "Q4"}
          ]
        }
      ]
    };

    fusionChartsController.addEvents([]);

    _fusionChart2D = FusionCharts(
        dataSource: dataSource,
        type: "stackedarea2d",
        width: "100%",
        height: "100%",
        webviewEvent: (a, b) => {},
        fusionChartEvent: (a, b) => {},
        fusionChartsController: fusionChartsController,
        licenseKey: licenseKey);

    dataSource = {
      "chart": {
        "caption": "Revenue split by product category",
        "subCaption": "For current year",
        "xAxisname": "Quarter",
        "yAxisName": "Revenues (In USD)",
        "showSum": "1",
        "numberPrefix": "\$",
        "theme": "fusion"
      },
      "categories": [
        {
          "category": [
            {"label": "Q1"},
            {"label": "Q2"},
            {"label": "Q3"},
            {"label": "Q4"}
          ]
        }
      ],
      "dataset": [
        {
          "seriesname": "Food Products",
          "data": [
            {"value": "11000"},
            {"value": "15000"},
            {"value": "13500"},
            {"value": "15000"}
          ]
        },
        {
          "seriesname": "Non-Food Products",
          "data": [
            {"value": "11400"},
            {"value": "14800"},
            {"value": "8300"},
            {"value": "11800"}
          ]
        }
      ]
    };
 
    _fusionChart3D = FusionCharts(
        dataSource: dataSource,
        type: "stackedcolumn2d",
        width: "100%",
        height: "100%",
        webviewEvent: (a, b) => {},
        fusionChartEvent: (a, b) => {},
        fusionChartsController: fusionChartsController,
        licenseKey: licenseKey);
  }

  void callBackFromPlugin(arg1, arg2) {
    if (kDebugMode) {
      print('Back to consumer: $arg1 , $arg2');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.of(context).pop()),
        title: const Text('Fusion Charts - Stacked Column'),
      ),
      body: Column(
        children: [
          Expanded(child: _fusionChart3D),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Text('Stacked Column2D'),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          // Expanded(child: _fusionChart3D),
          // Row(
          //   mainAxisAlignment: MainAxisAlignment.center,
          //   children: const [
          //     Text('Stacked Column3D'),
          //   ],
          // ),
          // const SizedBox(
          //   height: 10,
          // ),
        ],
      ),
    );
  }
}
