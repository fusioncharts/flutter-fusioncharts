import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_fusioncharts/flutter_fusioncharts.dart';
import '../../constants.dart';

class DraggableColumn extends StatefulWidget {
  const DraggableColumn({super.key});

  @override
  State<DraggableColumn> createState() => _DraggableColumnState();
}

class _DraggableColumnState extends State<DraggableColumn> {
  late FusionCharts _fusionChart2D;
  FusionChartsController fc = FusionChartsController();

  @override
  void initState() {
    super.initState();
    WidgetsFlutterBinding.ensureInitialized();

    Map<String, dynamic> chart = {
      "caption": "Inventory status - Bakersfield Central",
      "subCaption": "Top 5 Food items",
      "xAxisName": "Food Item",
      "yAxisName": "No. of Units",
      "theme": "carbon",
      
    };

    List<dynamic> dataset = [
      {
        "seriesname": "Available Stock",
        "allowDrag": "0",
        "data": [
          {"value": "6000"},
          {"value": "9500"},
          {"value": "11900"},
          {"value": "8000"},
          {"value": "9700"}
        ]
      },
      {
        "seriesname": "Estimated Demand",
        "dashed": "1",
        "data": [
          {"value": "19000"},
          {"value": "16500"},
          {"value": "14300"},
          {"value": "10000"},
          {"value": "9800"}
        ]
      }
    ];

    List<dynamic> categories = [
      {
        "category": [
          {"label": "Poultry"},
          {"label": "Rice"},
          {"label": "Peanut Butter"},
          {"label": "Salmon"},
          {"label": "Cereal"}
        ]
      }
    ];
    Map<String, dynamic> dataSource = {
      "chart": chart,
      "categories": categories,
      "dataset": dataset
    };

    _fusionChart2D = FusionCharts(
        dataSource: dataSource,
        type: "dragcolumn2d",
        width: "100%",
        height: "100%",
        licenseKey: licenseKey,
        fusionChartEvent: (eventType, eventDetail) =>
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content:
                    Text("Event Raised: $eventType + Details: $eventDetail"))),
        fusionChartsController: fc,
      events: [],
    );
  }

  void callBackFromPlugin(arg1, arg2) {
    if (kDebugMode) {
      print('Back to consumer: $arg1 , $arg2');
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => Navigator.of(context).pop()),
          title: const Text('Fusion Charts - Drag Column'),
        ),
        body: Column(
          children: [
            Expanded(child: _fusionChart2D),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Text('Drag Column'),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
          ],
        ),
      ),
    );
  }
}
