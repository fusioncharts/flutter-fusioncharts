import 'package:flutter/material.dart';
import 'package:flutter_fusioncharts/flutter_fusioncharts.dart';
import '../../constants.dart';

class MSColumn3DLineSingleYAxis extends StatefulWidget {
  const MSColumn3DLineSingleYAxis({super.key});

  @override
  State<MSColumn3DLineSingleYAxis> createState() =>
      _MSColumn3DLineSingleYAxisState();
}

class _MSColumn3DLineSingleYAxisState extends State<MSColumn3DLineSingleYAxis> {
  late FusionCharts _fusionChart2d;
  late FusionCharts _fusionChart3d;
  FusionChartsController fusionChartsController = FusionChartsController();

  @override
  void initState() {
    super.initState();
    WidgetsFlutterBinding.ensureInitialized();

    List<dynamic> categories = [{"category": [{"label": "Quarter 1"},{"label": "Quarter 2"},{"label": "Quarter 3"},{"label": "Quarter 4"}]}];
    // Construct the dataset comprising multiple series
    List<dynamic> dataset = [
      {
        "seriesname": "Fixed Cost",
        "data": [
          {"value": "235000"},
          {"value": "225100"},
          {"value": "222000"},
          {"value": "230500"}
        ]
      },
      {
        "seriesname": "Variable Cost",
        "data": [
          {"value": "230000"},
          {"value": "143000"},
          {"value": "198000"},
          {"value": "327600"}
        ]
      },
      {
        "seriesname": "Budgeted cost",
        "renderas": "Line",
        "data": [
          {"value": "455000"},
          {"value": "334000"},
          {"value": "426000"},
          {"value": "403000"}
        ]
      }
    ];

    Map<String, dynamic> chart = {
      "showvalues": "0",
      "caption": "Cost Analysis",
      "numberprefix": "\$",
      "xaxisname": "Quarters",
      "yaxisname": "Cost",
      "theme": "umber",
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
        type: "mscolumnline3d",
        width: "100%",
        height: "100%",
        fusionChartsController: fusionChartsController,
        licenseKey: licenseKey);
    _fusionChart3d = FusionCharts(
        dataSource: dataSource,
        type: "mscombidy3d",
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
            'Fusion Charts - Column3d-line-y-axis',
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
                  Text('Combination Column3d-line-y-axis'),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              // Expanded(child: _fusionChart3d),
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.center,
              //   children: const [
              //     Text('Combination 3D'),
              //   ],
              // ),
              // const SizedBox(
              //   height: 10,
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
