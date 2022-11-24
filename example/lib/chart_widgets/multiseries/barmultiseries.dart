import 'package:flutter/material.dart';
import 'package:flutter_fusioncharts/flutter_fusioncharts.dart';
import '../../constants.dart';

class BarMultiSeries extends StatefulWidget {
  const BarMultiSeries({super.key});

  @override
  State<BarMultiSeries> createState() => _BarMultiSeriesState();
}

class _BarMultiSeriesState extends State<BarMultiSeries> {
  late FusionCharts _fusionChart2d;
  late FusionCharts _fusionChart3d;
  FusionChartsController fusionChartsController = FusionChartsController();
  // late final FusionChartsController _fusionChartsController =
  // FusionChartsController();
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
      "theme": "zune",
      "caption": "Comparison of Quarterly Sales",
      "xAxisname": "Quarter",
      "yAxisName": "Sales",
      "baseFontSize": "30px",
      "captionFontSize": "30px",
    };

    Map<String, dynamic> dataSource = {
      "chart": chart,
      "dataset": dataset,
      "categories": categories
    };

    _fusionChart2d = FusionCharts(
        dataSource: dataSource,
        type: "msbar2d",
        width: "100%",
        height: "100%",
        fusionChartsController: fusionChartsController,
        licenseKey: licenseKey);
    _fusionChart3d = FusionCharts(
        dataSource: dataSource,
        type: "msbar3d",
        width: "100%",
        height: "100%",
        fusionChartsController: fusionChartsController,
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
          title: const Text('Fusion Charts - Bar MultiSeries'),
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
                  Text('Bar 2D'),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              Expanded(child: _fusionChart3d),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Text('Bar 3D'),
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
