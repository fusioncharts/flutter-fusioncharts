import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_fusioncharts/flutter_fusioncharts.dart';
import './examples_menu.dart';

void main() async {
  await dotenv.load(fileName: ".env");
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String chartDataHardCoded = '';
  @override
  void initState() {
    super.initState();
    WidgetsFlutterBinding.ensureInitialized();
  }

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Column2D(),
    );
  }
}

class Column2D extends StatefulWidget {
  const Column2D({super.key});

  @override
  State<Column2D> createState() => _Column2DState();
}

class _Column2DState extends State<Column2D> {
  late FusionCharts _fusionChart2D;
  FusionChartsController fusionChartsController = FusionChartsController();

  @override
  void initState() {
    super.initState();

    Map<String, String> chart = {
      "caption": "Countries With Most Oil Reserves [2017-18]",
      "subCaption": "In MMbbl = One Million barrels",
      "xAxisName": "Country",
      "yAxisName": "Reserves (MMbbl)",
      "numberSuffix": "K",
      "theme": "candy",
    };

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

    Map<String, dynamic> dataSource = {"chart": chart, "data": chartData};

    _fusionChart2D = FusionCharts(
      dataSource: dataSource,
      type: "column2d",
      width: "100%",
      height: "100%",
      events: const ['chartClick'],
      fusionChartEvent: callBackFromPlugin,
      fusionChartsController: fusionChartsController,
      isLocal: false,
    );
  }

  void callBackFromPlugin(senderId, eventType) {
    print('Event Back to consumer: $senderId , $eventType');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Fusion Charts - Column'),
      ),
      body: Column(
        children: [
          SizedBox(
              height: MediaQuery.of(context).size.height / 2,
              child: _fusionChart2D),
          const SizedBox(height: 20),
          ElevatedButton(
              onPressed: () => Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) => const Menu())),
              child: const SizedBox(
                  child: Text(
                "All Charts Menu",
                style: TextStyle(fontSize: 16),
              )))
        ],
      ),
    );
  }
}
