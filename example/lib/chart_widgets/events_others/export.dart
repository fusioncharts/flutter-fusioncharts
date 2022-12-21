import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_fusioncharts/flutter_fusioncharts.dart';
import 'package:flutter_fusioncharts_example/chartdata.dart';
import '../../constants.dart';

class ColumnChartExport extends StatefulWidget {
  const ColumnChartExport({super.key});

  @override
  State<ColumnChartExport> createState() => _ColumnChartExportState();
}

class _ColumnChartExportState extends State<ColumnChartExport> {
  late FusionCharts _fusionChart2D;
  late FusionCharts _fusionChart3D;
  FusionChartsController fcController2d = FusionChartsController();
  FusionChartsController fcController3d = FusionChartsController();

  @override
  void initState() {
    super.initState();
    WidgetsFlutterBinding.ensureInitialized();

    Map<String, dynamic> chart = {
      "caption": "Countries With Most Oil Reserves [2017-18]",
      "subCaption": "In MMbbl = One Million barrels",
      "xAxisName": "Country",
      "yAxisName": "Reserves (MMbbl)",
      "numberSuffix": "K",
      "theme": "fusion",
      "exportEnabled": "1",
      "exportMode": "client"
    };
    Map<String, dynamic> dataSource = {
      "chart": chart,
      "data": ChartData.chartData
    };

    _fusionChart2D = FusionCharts(
        dataSource: dataSource,
        type: "column2d",
        width: "100%",
        height: "100%",
        fusionChartEvent: (a, b) => {},
        fusionChartsController: fcController2d,
        licenseKey: licenseKey);
    _fusionChart3D = FusionCharts(
        dataSource: dataSource,
        type: "column3d",
        width: "100%",
        height: "100%",
        fusionChartEvent: (a, b) => callBackFromPlugin(a, b),
        fusionChartsController: fcController3d,
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
        title: const Text('Fusion Charts - Column'),
      ),
      body: Column(
        children: [
          Expanded(child: _fusionChart2D),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Text('Column2D'),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          Expanded(child: _fusionChart3D),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Text('Column3D'),
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
