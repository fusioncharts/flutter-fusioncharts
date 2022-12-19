import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_fusioncharts/flutter_fusioncharts.dart';
import '../../constants.dart';

class DraggableArea extends StatefulWidget {
  const DraggableArea({super.key});

  @override
  State<DraggableArea> createState() => _DraggableAreaState();
}

class _DraggableAreaState extends State<DraggableArea> {
  late FusionCharts _fusionChart2D;
  FusionChartsController fc = FusionChartsController();

  @override
  void initState() {
    super.initState();
    WidgetsFlutterBinding.ensureInitialized();

    Map<String, dynamic> chart = {
      "caption": "Quarterly Sales Projections",
      "subCaption": "iPhone vs Samsung Galaxy",
      "xAxisName": "Quarter",
      "yAxisName": "No. of Units",
      "theme": "fint",
      "baseFontSize": "30px",
      "captionFontSize": "30px",
    };

    List<dynamic> dataset = [
      {
        "seriesname": "Apple",
        "valuePosition": "ABOVE",
        "allowDrag": "0",
        "data": [
          {"value": "1200"},
          {"value": "1500", "dashed": "1"},
          {"value": "1300", "allowDrag": "1", "dashed": "1"},
          {
            "value": "900",
            "allowDrag": "1",
            "tooltext": "Predicted sales \$value units"
          }
        ]
      },
      {
        "seriesname": "Samsung",
        "allowDrag": "0",
        "data": [
          {"value": "600"},
          {"value": "850", "dashed": "1"},
          {"value": "1000", "allowDrag": "1", "dashed": "1"},
          {
            "value": "1200",
            "allowDrag": "1",
            "tooltext": "Predicted sales \$value units"
          }
        ]
      }
    ];

    List<dynamic> categories = [
      {
        "category": [
          {"label": "Q1"},
          {"label": "Q2"},
          {"label": "Q3(E)"},
          {"label": "Q4(E)"}
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
        type: "dragarea",
        width: "100%",
        height: "100%",
        licenseKey: licenseKey,
        fusionChartEvent: (eventType, eventDetail) =>
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content:
                    Text("Event Raised: $eventType + Details: $eventDetail"))),
        fusionChartsController: fc);
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
          title: const Text('Fusion Charts - Draggable Area'),
        ),
        body: Column(
          children: [
            Expanded(child: _fusionChart2D),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Text('Draggable Area'),
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
