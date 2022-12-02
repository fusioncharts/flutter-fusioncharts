import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_fusioncharts/flutter_fusioncharts.dart';
import '../../constants.dart';

class ErrorScatter extends StatefulWidget {
  const ErrorScatter({super.key});

  @override
  State<ErrorScatter> createState() => _ErrorScatterState();
}

class _ErrorScatterState extends State<ErrorScatter> {
  late FusionCharts _fusionChart2D;
  FusionChartsController fc = FusionChartsController();

  @override
  void initState() {
    super.initState();
    WidgetsFlutterBinding.ensureInitialized();

    Map<String, dynamic> chart = {
      "xaxisname": "Month",
      "yaxisname": "Revenue (In USD)",
      "caption": "Revenue forecast",
      "subcaption": "For Next Year",
      "halfverticalerrorbar": "0",
      "numberPrefix": "\$",
      "theme": "fusion",
      "baseFontSize": "30px",
      "captionFontSize": "30px",
    };

    List<dynamic> categories = [
      {
        "category": [
          {"label": "Jan", "x": "20"},
          {"label": "Feb", "x": "30"},
          {"label": "Mar", "x": "40"},
          {"label": "Apr", "x": "50"},
          {"label": "May", "x": "60"},
          {"label": "Jun", "x": "70"},
          {"label": "Jul", "x": "80"},
          {"label": "Aug", "x": "90"},
          {"label": "Sep", "x": "100"},
          {"label": "Oct", "x": "110"},
          {"label": "Nov", "x": "120"},
          {"label": "Dec", "x": "130"}
        ]
      }
    ];

    List<dynamic> dataset = [
      {
        "seriesname": "This Year",
        "color": "",
        "anchorradius": "8",
        "anchorbgcolor": "#1aaf5d",
        "data": [
          {"y": "450000", "x": "20", "verticalErrorValue": "50000"},
          {"y": "860000", "x": "30", "verticalErrorValue": "69000"},
          {"y": "750000", "x": "40", "verticalErrorValue": "69000"},
          {"y": "570000", "x": "50", "verticalErrorValue": "60000"},
          {"y": "910000", "x": "60", "verticalErrorValue": "50000"},
          {"y": "580000", "x": "70", "verticalErrorValue": "55000"},
          {"y": "610000", "x": "80", "verticalErrorValue": "87000"},
          {"y": "620000", "x": "90", "verticalErrorValue": "45000"},
          {"y": "520000", "x": "100", "verticalErrorValue": "59000"},
          {"y": "530000", "x": "110", "verticalErrorValue": "72000"},
          {"y": "950000", "x": "120", "verticalErrorValue": "69000"},
          {"y": "770000", "x": "130", "verticalErrorValue": "69000"}
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
        type: "errorscatter",
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
          title: const Text('Fusion Charts - Error Scatter'),
        ),
        body: Column(
          children: [
            Expanded(child: _fusionChart2D),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Text('Error Scatter'),
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
