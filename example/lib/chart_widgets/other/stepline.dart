import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_fusioncharts/flutter_fusioncharts.dart';
import '../../constants.dart';

class StepLine extends StatefulWidget {
  const StepLine({super.key});

  @override
  State<StepLine> createState() => _StepLineState();
}

class _StepLineState extends State<StepLine> {
  late FusionCharts _fusionChart2D;

  @override
  void initState() {
    super.initState();
    WidgetsFlutterBinding.ensureInitialized();

    Map<String, dynamic> chart = {
      "caption": "Revenue Vs Expense",
      "subCaption": "Last year",
      "xaxisname": "Month",
      "yaxisname": "Amount (In USD)",
      "numberprefix": "\$",
      "useforwardsteps": "0",
      "theme": "fusion",
      
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
        "seriesname": "Revenue",
        "linethickness": "3",
        "anchorradius": "3",
        "data": [
          {"value": "374000"},
          {"value": "350000"},
          {"value": "380000"},
          {"value": "340000"},
          {"value": "398000"},
          {"value": "326000"},
          {"value": "448000"},
          {"value": "379000"},
          {"value": "355000"},
          {"value": "374000"},
          {"value": "348000"},
          {"value": "402000"}
        ]
      },
      {
        "seriesname": "Expense",
        "linethickness": "3",
        "anchorradius": "3",
        "data": [
          {"value": "100000"},
          {"value": "115000"},
          {"value": "135000"},
          {"value": "150000"},
          {"value": "110000"},
          {"value": "98000"},
          {"value": "118000"},
          {"value": "197000"},
          {"value": "228000"},
          {"value": "249000"},
          {"value": "229000"},
          {"value": "208000"}
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
        type: "msstepLine",
        width: "100%",
        height: "100%",
        licenseKey: licenseKey);
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
              onPressed: () => Navigator.of(context).pop(),
              icon: const Icon(Icons.arrow_back)),
          title: const Text('Fusion Charts - StepLine'),
        ),
        body: Column(
          children: [
            Expanded(child: _fusionChart2D),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Text('StepLine Chart'),
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
