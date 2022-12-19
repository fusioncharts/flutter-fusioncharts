import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_fusioncharts/flutter_fusioncharts.dart';
import '../../constants.dart';

class ErrorLine extends StatefulWidget {
  const ErrorLine({super.key});

  @override
  State<ErrorLine> createState() => _ErrorLineState();
}

class _ErrorLineState extends State<ErrorLine> {
  late FusionCharts _fusionChart2D;
  FusionChartsController fc = FusionChartsController();

  @override
  void initState() {
    super.initState();
    WidgetsFlutterBinding.ensureInitialized();

    Map<String, dynamic> chart = {
      "caption": "Revenues and Profits",
      "subCaption": "Predicted for next year",
      "xAxisname": "Month",
      "yAxisName": "Amount (In USD)",
      "numberPrefix": "\$",
      "halferrorbar": "0",
      "plotTooltext":
          "<div id='nameDiv' style='font-size: 14px; border-bottom: 1px dashed #999999; font-weight:bold; padding-bottom: 3px; margin-bottom: 5px; display: inline-block;'>\$label :</div>{br}\$seriesName : <b>\$dataValue</b>{br}Deviation : <b>± \$errorDataValue</b>",
      "theme": "umber",
      
    };

    List<dynamic> categories = [
      {
        "category": [
          {"label": "Jan"},
          {"label": "Feb"},
          {"label": "Mar"},
          {"label": "Apr"},
          {"label": "May"},
          {"label": "Jun"},
          {"label": "Jul"},
          {"label": "Aug"},
          {"label": "Sep"},
          {"label": "Oct"},
          {"label": "Nov"},
          {"label": "Dec"}
        ]
      }
    ];

    List<dynamic> dataset = [
      {
        "seriesName": "Revenues",
        "dashed": "1",
        "dashlen": "2",
        "dashGap": "2",
        "data": [
          {"value": "16000", "errorvalue": "2000"},
          {"value": "20000", "errorvalue": "4000"},
          {"value": "18000", "errorvalue": "1000"},
          {"value": "19000", "errorvalue": "1500"},
          {"value": "15000", "errorvalue": "1000"},
          {"value": "21000", "errorvalue": "4500"},
          {"value": "16000", "errorvalue": "1500"},
          {"value": "20000", "errorvalue": "3000"},
          {"value": "17000", "errorvalue": "2000"},
          {"value": "22000", "errorvalue": "4000"},
          {"value": "19000", "errorvalue": "2500"},
          {"value": "23000", "errorvalue": "3000"}
        ]
      },
      {
        "seriesName": "Profits",
        "dashed": "1",
        "dashlen": "2",
        "dashGap": "2",
        "data": [
          {"value": "8000", "errorvalue": "2000"},
          {"value": "9000", "errorvalue": "2000"},
          {"value": "7000", "errorvalue": "2700"},
          {"value": "8000", "errorvalue": "2750"},
          {"value": "6000", "errorvalue": "1200"},
          {"value": "11000", "errorvalue": "3000"},
          {"value": "6900", "errorvalue": "1250"},
          {"value": "8000", "errorvalue": "1400"},
          {"value": "6500", "errorvalue": "1200"},
          {"value": "12000", "errorvalue": "3000"},
          {"value": "6000", "errorvalue": "1500"},
          {"value": "11000", "errorvalue": "2500"}
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
        type: "errorline",
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
          title: const Text('Fusion Charts - Error Line'),
        ),
        body: Column(
          children: [
            Expanded(child: _fusionChart2D),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Text('Error Line'),
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
