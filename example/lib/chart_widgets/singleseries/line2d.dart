import 'package:flutter/material.dart';
import 'package:flutter_fusioncharts/flutter_fusioncharts.dart';
import '../../constants.dart';

class Line2D extends StatefulWidget {
  const Line2D({super.key});

  @override
  State<Line2D> createState() => _Line2DState();
}

class _Line2DState extends State<Line2D> {
  late FusionCharts _fusionChart;
  @override
  void initState() {
    super.initState();
    WidgetsFlutterBinding.ensureInitialized();

    List<dynamic> chartData = [
      {"label": "Venezuela", "value": "290"},
      {"label": "Saudi", "value": "260"},
      {"label": "Canada", "value": "180"},
      {"label": "Iran", "value": "140"},
      {"label": "Russia", "value": "115"},
      {"label": "UAE", "value": "100"},
      {"label": "US", "value": "30"},
      {"label": "China", "value": "30"}
    ];

    Map<String, dynamic> chart = {
      "caption": "Countries With Most Oil Reserves [2017-18]",
      "subCaption": "In MMbbl = One Million barrels",
      "xAxisName": "Country",
      "yAxisName": "Reserves (MMbbl)",
      "numberSuffix": "K",
      "theme": "gammel",
      "baseFontSize": "30px",
      "captionFontSize": "30px",
    };
    FusionChartsController fusionChartsController = FusionChartsController();
    Map<String, dynamic> dataSource = {"chart": chart, "data": chartData};
    fusionChartsController.addEvents([]);

    _fusionChart = FusionCharts(
        dataSource: dataSource,
        type: "line",
        width: "100%",
        height: "100%",
        fusionChartEvent: (a, b) => {},
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
                icon: Icon(Icons.arrow_back),
                onPressed: () => Navigator.of(context).pop()),
            title: const Text('Fusion Charts - Line'),
          ),
          body: _fusionChart),
    );
  }
}
