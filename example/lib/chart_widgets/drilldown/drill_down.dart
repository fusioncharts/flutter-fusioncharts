import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_fusioncharts/flutter_fusioncharts.dart';
import 'package:flutter_fusioncharts_example/chartdata.dart';
import '../../constants.dart';

class DrillDown extends StatefulWidget {
  const DrillDown({super.key});

  @override
  State<DrillDown> createState() => _DrillDownState();
}

class _DrillDownState extends State<DrillDown> {
  late FusionCharts _fusionCharDrillDown;

  @override
  void initState() {
    super.initState();
    WidgetsFlutterBinding.ensureInitialized();

    Map<String, dynamic> chart = {
      "subcaption": "Last year",
      "xaxisName": "Flavor",
      "yaxisName": "Amount (In USD)",
      "numberPrefix": "\$",
      "theme": "fusion",
      "rotateValues": "0",
      "baseFontSize": "30px",
      "captionFontSize": "30px",
    };

    List<dynamic> data = [
      {"label": "Apple", "value": "810000", "link": "newchart-xml-apple"},
      {
        "label": "Cranberry",
        "value": "620000",
        "link": "newchart-xml-cranberry"
      },
      {"label": "Grapes", "value": "350000", "link": "newchart-xml-grapes"}
    ];

    List<dynamic> linkeddata = [
      {
        "id": "apple",
        "linkedchart": {
          "chart": {
            "caption": "Apple Juice - Quarterly Sales",
            "subcaption": "Last year",
            "xaxisname": "Quarter",
            "yaxisname": "Amount (In USD)",
            "numberprefix": "\$",
            "theme": "fusion",
            "rotateValues": "0"
          },
          "data": [
            {"label": "Q1", "value": "157000"},
            {"label": "Q2", "value": "172000"},
            {"label": "Q3", "value": "206000"},
            {"label": "Q4", "value": "275000", "rotateValues": "0"}
          ]
        }
      },
      {
        "id": "cranberry",
        "linkedchart": {
          "chart": {
            "caption": "Cranberry Juice - Quarterly Sales",
            "subcaption": "Last year",
            "xaxisname": "Quarter",
            "yaxisname": "Amount (In USD)",
            "numberprefix": "\$",
            "theme": "fusion",
            "rotateValues": "0"
          },
          "data": [
            {"label": "Q1", "value": "102000"},
            {"label": "Q2", "value": "142000"},
            {"label": "Q3", "value": "187000"},
            {"label": "Q4", "value": "189000"}
          ]
        }
      },
      {
        "id": "grapes",
        "linkedchart": {
          "chart": {
            "caption": "Grape Juice - Quarterly Sales",
            "subcaption": "Last year",
            "xaxisname": "Quarter",
            "yaxisname": "Amount (In USD)",
            "numberprefix": "\$",
            "theme": "fusion",
            "rotateValues": "0"
          },
          "data": [
            {"label": "Q1", "value": "45000"},
            {"label": "Q2", "value": "72000"},
            {"label": "Q3", "value": "95000"},
            {"label": "Q4", "value": "108000"}
          ]
        }
      }
    ];

    FusionChartsController fusionChartsController = FusionChartsController();

    fusionChartsController.addEvents([]);

    _fusionCharDrillDown = FusionCharts(
        dataSource: {"chart": chart, "data": data, "linkeddate": linkeddata},
        type: "DrillDown2d",
        width: "100%",
        height: "100%",
        fusionChartEvent: (a, b) => {},
        fusionChartsController: fusionChartsController,
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
          title: const Text('Fusion Charts - Drill Down'),
        ),
        body: _fusionCharDrillDown);
  }
}
