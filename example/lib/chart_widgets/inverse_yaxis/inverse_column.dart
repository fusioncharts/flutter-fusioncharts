import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_fusioncharts/flutter_fusioncharts.dart';
import '../../constants.dart';

class InverseColumn extends StatefulWidget {
  const InverseColumn({super.key});

  @override
  State<InverseColumn> createState() => _InverseColumnState();
}

class _InverseColumnState extends State<InverseColumn> {
  late FusionCharts _fusionChart2D;
  FusionChartsController fc = FusionChartsController();

  @override
  void initState() {
    super.initState();
    WidgetsFlutterBinding.ensureInitialized();

    Map<String, dynamic> chart = {
      "caption": "Average Page Load Time (hsm.com)",
      "subCaption": "Last Week",
      "yAxisName": "Time (In Sec)",
      "numberSuffix": "s",
      "xAxisLineThickness": "1",
      "theme": "umber",
      "baseFontSize": "30px",
      "captionFontSize": "30px",
    };

    List<dynamic> categories = [
      {
        "category": [
          {"label": "Mon"},
          {"label": "Tue"},
          {"label": "Wed"},
          {"label": "Thu"},
          {"label": "Fri"},
          {"label": "Sat"},
          {"label": "Sun"}
        ]
      }
    ];

    List<dynamic> dataset = [
      {
        "seriesname": "Loading Time",
        "allowDrag": "0",
        "data": [
          {"value": "6"},
          {"value": "5.8"},
          {"value": "5"},
          {"value": "4.3"},
          {"value": "4.1"},
          {"value": "3.8"},
          {"value": "3.2"}
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
        type: "InverseMSColumn2D",
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
          title: const Text('Fusion Charts - Inverse Column'),
        ),
        body: Column(
          children: [
            Expanded(child: _fusionChart2D),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Text('Inverse Column'),
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
