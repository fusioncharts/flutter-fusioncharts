import 'package:flutter/material.dart';
import 'package:flutter_fusioncharts/flutter_fusioncharts.dart';
import '../../constants.dart';

class StackedColumnLineSingleYAxis extends StatefulWidget {
  const StackedColumnLineSingleYAxis({super.key});

  @override
  State<StackedColumnLineSingleYAxis> createState() =>
      _StackedColumnLineSingleYAxisState();
}

class _StackedColumnLineSingleYAxisState
    extends State<StackedColumnLineSingleYAxis> {
  late FusionCharts _fusionChart2d;
  late FusionCharts _fusionChart3d;
  FusionChartsController fusionChartsController = FusionChartsController();

  @override
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
        "seriesname": "Food Products",
        "data": [
          {"value": "110000"},
          {"value": "150000"},
          {"value": "135000"},
          {"value": "150000"}
        ]
      },
      {
        "seriesname": "Non-Food Products",
        "data": [
          {"value": "114000"},
          {"value": "148000"},
          {"value": "83000"},
          {"value": "118000"}
        ]
      },
      {
        "seriesname": "Profit",
        "renderAs": "line",
        "showValues": "0",
        "data": [
          {"value": "24000"},
          {"value": "45000"},
          {"value": "23000"},
          {"value": "38000"}
        ]
      }
    ];

    Map<String, dynamic> chart = {
      "caption": "Product-wise quarterly revenue Vs profit in last year",
      "subCaption": "Harry's SuperMart",
      "xAxisname": "Quarter",
      "yAxisName": "Revenue (In USD)",
      "numberPrefix": "\$",
      "theme": "fusion",
      "baseFontSize": "30",
      "captionFontSize": "30px",
    };

    Map<String, dynamic> dataSource = {
      "chart": chart,
      "dataset": dataset,
      "categories": categories
    };

    _fusionChart2d = FusionCharts(
        dataSource: dataSource,
        type: "stackedcolumn2dline",
        width: "100%",
        height: "100%",
        fusionChartsController: fusionChartsController,
        licenseKey: licenseKey);
    _fusionChart3d = FusionCharts(
        dataSource: dataSource,
        type: "stackedcolumn3dline",
        width: "100%",
        height: "100%",
        fusionChartsController: fusionChartsController,
        licenseKey: licenseKey);
  }

  void callBackFromPlugin(arg1, arg2) {
    print('Back to consumer: $arg1 , $arg2');
  }

  // changeType() {
  //   print('Change type msColumn3D');
  //   if (_2d) {
  //     _fusionChartsController
  //         .executeScript("globalFusionCharts.chartType('msColumn3D')");
  //   } else {
  //     _fusionChartsController
  //         .executeScript("globalFusionCharts.chartType('msColumn2D')");
  //   }
  //   _2d = !_2d;
  // }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          leading: IconButton(
              onPressed: () => Navigator.of(context).pop(),
              icon: const Icon(Icons.arrow_back)),
          title: const Text(
            'Fusion Charts - MultiSeries Stacked Combination',
            overflow: TextOverflow.ellipsis,
          ),
        ),
        body: SizedBox(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Column(
            children: [
              Expanded(child: _fusionChart2d),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Text('Combination 2D'),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              Expanded(child: _fusionChart3d),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Text('Combination 3D'),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
