import 'package:flutter/material.dart';
import 'package:flutter_fusioncharts/flutter_fusioncharts.dart';
import '../../constants.dart';

class MultiSeriesSingleCombo extends StatefulWidget {
  const MultiSeriesSingleCombo({super.key});

  @override
  State<MultiSeriesSingleCombo> createState() => _MultiSeriesSingleComboState();
}

class _MultiSeriesSingleComboState extends State<MultiSeriesSingleCombo> {
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
        "seriesName": "Actual Revenue",
        "showValues": "1",
        "data": [
          {"value": "16000"},
          {"value": "20000"},
          {"value": "18000"},
          {"value": "19000"},
          {"value": "15000"},
          {"value": "21000"},
          {"value": "16000"},
          {"value": "20000"},
          {"value": "17000"},
          {"value": "25000"},
          {"value": "19000"},
          {"value": "23000"}
        ]
      },
      {
        "seriesName": "Projected Revenue",
        "renderAs": "line",
        "data": [
          {"value": "15000"},
          {"value": "16000"},
          {"value": "17000"},
          {"value": "18000"},
          {"value": "19000"},
          {"value": "19000"},
          {"value": "19000"},
          {"value": "19000"},
          {"value": "20000"},
          {"value": "21000"},
          {"value": "22000"},
          {"value": "23000"}
        ]
      },
      {
        "seriesName": "Profit",
        "renderAs": "area",
        "data": [
          {"value": "4000"},
          {"value": "5000"},
          {"value": "3000"},
          {"value": "4000"},
          {"value": "1000"},
          {"value": "7000"},
          {"value": "1000"},
          {"value": "4000"},
          {"value": "1000"},
          {"value": "8000"},
          {"value": "2000"},
          {"value": "7000"}
        ]
      }
    ];

    Map<String, dynamic> chart = {
      "theme": "candy",
      "caption": "Comparison of Quarterly Sales",
      "xAxisname": "Quarter",
      "yAxisName": "Sales",
      "baseFontSize": "10px",
      "captionFontSize": "10px",
    };

    Map<String, dynamic> dataSource = {
      "chart": chart,
      "dataset": dataset,
      "categories": categories
    };

    _fusionChart2d = FusionCharts(
        dataSource: dataSource,
        type: "mscombi2d",
        width: "100%",
        height: "100%",
        fusionChartsController: fusionChartsController,
        licenseKey: licenseKey);
    _fusionChart3d = FusionCharts(
        dataSource: dataSource,
        type: "mscombi3d",
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
          title: const Text('Fusion Charts - MultiSeries Single Combination',overflow: TextOverflow.ellipsis,),
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
