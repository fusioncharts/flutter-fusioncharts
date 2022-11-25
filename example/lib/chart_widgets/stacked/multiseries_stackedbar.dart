import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_fusioncharts/flutter_fusioncharts.dart';
import 'package:flutter_fusioncharts_example/chartdata.dart';
import '../../constants.dart';

class StackedBarMultiSeries extends StatefulWidget {
  const StackedBarMultiSeries({super.key});

  @override
  State<StackedBarMultiSeries> createState() => _StackedBarMultiSeriesState();
}

class _StackedBarMultiSeriesState extends State<StackedBarMultiSeries> {
  late FusionCharts _fusionChart2D;
  late FusionCharts _fusionChart3D;

  @override
  void initState() {
    super.initState();
    WidgetsFlutterBinding.ensureInitialized();

    Map<String, dynamic> chart = {
      "caption": "Product-wise break-up of quarterly revenue in last year",
      "subcaption": "Harry's SuperMart",
      "xaxisname": "Quarter",
      "yaxisname": "Sales (In USD)",
      "numberPrefix": "\$",
      "numbersuffix": "M",
      "theme": "carbon",
      "baseFontSize": "30px",
      "captionFontSize": "30px",
    };

    FusionChartsController fusionChartsController = FusionChartsController();
    Map<String, dynamic> dataSource = {
      "chart": chart,
      "dataset": ChartData.chartData4,
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
        type: "msstackedbar2d",
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
        title: const Text('Fusion Charts - MS Stacked Bar'),
      ),
      body: Column(
        children: [
          Expanded(child: _fusionChart2D),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Text('Multi Series Stacked Bar2D'),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
        ],
      ),
    );
  }
}
