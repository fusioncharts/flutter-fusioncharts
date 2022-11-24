import 'package:flutter/material.dart';
import 'package:flutter_fusioncharts/flutter_fusioncharts.dart';
import '../../constants.dart';

class MultiSeries extends StatefulWidget {
  const MultiSeries({super.key});

  @override
  State<MultiSeries> createState() => _MultiSeriesState();
}

class _MultiSeriesState extends State<MultiSeries> {
  late FusionCharts _fusionChart;
  late FusionChartsController _fusionChartsController =
      FusionChartsController();
  bool _2d = true;
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
      "theme": "candy",
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
        fusionChartsController: _fusionChartsController,
        licenseKey: licenseKey);
  }

  void callBackFromPlugin(arg1, arg2) {
    print('Back to consumer: $arg1 , $arg2');
  }

  changeType() {
    print('Change type msColumn3D');
    if (_2d) {
      _fusionChartsController
          .executeScript("globalFusionCharts.chartType('msColumn3D')");
    } else {
      _fusionChartsController
          .executeScript("globalFusionCharts.chartType('msColumn2D')");
    }
    _2d = !_2d;
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
        body: SizedBox(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: SizedBox(height: 700, width: 500, child: _fusionChart),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                    onPressed: () => changeType(),
                    child: Container(
                        width: 100,
                        height: 40,
                        color: Colors.blue,
                        child: Center(child: Text('Change Type'))))
              ],
            )),
      ),
    );
  }
}
