import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_fusioncharts/flutter_fusioncharts.dart';
import '../../constants.dart';

class ScrollArea2D extends StatefulWidget {
  const ScrollArea2D({super.key});

  @override
  State<ScrollArea2D> createState() => _ScrollArea2DState();
}

class _ScrollArea2DState extends State<ScrollArea2D> {
  late FusionCharts _fusionChart2D;
  FusionChartsController fc = FusionChartsController();

  @override
  void initState() {
    super.initState();
    WidgetsFlutterBinding.ensureInitialized();

    Map<String, dynamic> chart = {
      "caption": "Sales Trends",
      "subCaption": "(FY 2012 to FY 2013)",
      "xAxisname": "Month",
      "pYAxisName": "Amount",
      "labelDisplay": "AUTO",
      "sYAxisName": "Employees",
      "numberPrefix": "\$",
      "numVisiblePlot": "8",
      "flatScrollBars": "1",
      "scrollheight": "10",
      "theme": "gammel",
      "baseFontSize": "30px",
      "captionFontSize": "30px",
    };


    List<dynamic> categories = [
      {
        "category": [
          {"label": "Jan 2012"},
          {"label": "Feb 2012"},
          {"label": "Mar 2012"},
          {"label": "Apr 2012"},
          {"label": "May 2012"},
          {"label": "Jun 2012"},
          {"label": "Jul 2012"},
          {"label": "Aug 2012"},
          {"label": "Sep 2012"},
          {"label": "Oct 2012"},
          {"label": "Nov 2012"},
          {"label": "Dec 2012"},
          {"label": "Jan 2013"},
          {"label": "Feb 2013"},
          {"label": "Mar 2013"},
          {"label": "Apr 2013"},
          {"label": "May 2013"},
          {"label": "Jun 2013"},
          {"label": "Jul 2013"},
          {"label": "Aug 2013"},
          {"label": "Sep 2013"},
          {"label": "Oct 2013"},
          {"label": "Nov 2013"},
          {"label": "Dec 2013"}
        ]
      }
    ];
    List<dynamic> dataset = [
      {
        "data": [
          {"value": "27400"},
          {"value": "29800"},
          {"value": "25800"},
          {"value": "26800"},
          {"value": "29600"},
          {"value": "32600"},
          {"value": "31800"},
          {"value": "36700"},
          {"value": "29700"},
          {"value": "31900"},
          {"value": "34800"},
          {"value": "24800"},
          {"value": "26300"},
          {"value": "31800"},
          {"value": "30900"},
          {"value": "33000"},
          {"value": "36200"},
          {"value": "32100"},
          {"value": "37500"},
          {"value": "38500"},
          {"value": "35400"},
          {"value": "38200"},
          {"value": "33300"},
          {"value": "38300"}
        ]
      }
    ];
    Map<String, dynamic> dataSource = {
      "chart": chart,
      "dataset": dataset,
      "categories": categories
    };

    _fusionChart2D = FusionCharts(
        dataSource: dataSource,
        type: "scrollarea2d",
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
          title: const Text('Fusion Charts - Scroll Area'),
        ),
        body: Column(
          children: [
            Expanded(child: _fusionChart2D),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Text('Scroll Area 2D'),
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
