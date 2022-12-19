import 'package:flutter/material.dart';
import 'package:flutter_fusioncharts/flutter_fusioncharts.dart';
import '../../constants.dart';

class StackedAreaLineColumn extends StatefulWidget {
  const StackedAreaLineColumn({super.key});

  @override
  State<StackedAreaLineColumn> createState() =>
      _StackedAreaLineColumnState();
}

class _StackedAreaLineColumnState
    extends State<StackedAreaLineColumn> {
  late FusionCharts _fusionChart2d;
  late FusionCharts _fusionChart3d;
  FusionChartsController fusionChartsController = FusionChartsController();

  @override
  void initState() {
    super.initState();
    WidgetsFlutterBinding.ensureInitialized();

    List<dynamic> categories = [{"category": [{"label": "2016"},{"label": "2017"},{"label": "2018"},{"label": "2019"},{"label": "2020"},{"label": "2021"}]}];
    // Construct the dataset comprising multiple series
    List<dynamic> dataset = [{"seriesname": "RPA Software","data": [{"value": "73"},{"value": "113"},{"value": "153"},{"value": "192"},{"value": "232"},{"value": "272"}]},{"seriesname": "RPA Services","data": [{"value": "198"},{"value": "330"},{"value": "476"},{"value": "630"},{"value": "790"},{"value": "952"}]},{"seriesname": "YoY Growth","parentyaxis": "S","plottooltext": "demodatavalue growth expected in demolabel","renderas": "line","data": [{"value": "73"},{"value": "63"},{"value": "42"},{"value": "31"},{"value": "24"},{"value": "20"}]}];

    Map<String, dynamic> chart = {
      "caption": "Global Robotic Process Automation Market",
      "subcaption": "2016 - 2021",
      "yaxisname": "Market Size (in \$ Millions)",
      "syaxisname": "YoY growth in %",
      "formatnumberscale": "0",
      "numberprefix": "\$",
      "numbersuffix": "M",
      "snumbersuffix": "%",
      "showvalues": "0",
      "plottooltext": "Market size for Demo Series in demo is <b>demob</b>",
      "theme": "fusion",

    };



    Map<String, dynamic> dataSource = {
      "chart": chart,
      "dataset": dataset,
      "categories": categories
    };

    _fusionChart2d = FusionCharts(
        dataSource: dataSource,
        type: "stackedcolumn2dlinedy",
        width: "100%",
        height: "100%",
        fusionChartsController: fusionChartsController,
        licenseKey: licenseKey);
    _fusionChart3d = FusionCharts(
        dataSource: dataSource,
        type: "stackedarea2dlinedy",
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
                  Text('Stacked Column-Line'),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              Expanded(child: _fusionChart3d),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Text('Stacked Area-Line'),
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
