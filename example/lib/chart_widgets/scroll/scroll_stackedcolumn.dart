import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_fusioncharts/flutter_fusioncharts.dart';
import '../../constants.dart';

class ScrollStackedColumn2D extends StatefulWidget {
  const ScrollStackedColumn2D({super.key});

  @override
  State<ScrollStackedColumn2D> createState() => _ScrollStackedColumn2DState();
}

class _ScrollStackedColumn2DState extends State<ScrollStackedColumn2D> {
  late FusionCharts _fusionChart2D;
  FusionChartsController fc = FusionChartsController();

  @override
  void initState() {
    super.initState();
    WidgetsFlutterBinding.ensureInitialized();

    Map<String, dynamic> chart = {
      "caption": "Sales Comparison",
      "subCaption": "(2018 to 2019)",
      "xaxisname": "Month",
      "yaxisname": "Revenue",
      "numberprefix": "\$",
      "lineThickness": "3",
      "flatScrollBars": "1",
      "scrollheight": "10",
      "theme": "fusion",
      
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
        "seriesname": "Products",
        "color": "008ee4",
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
          {"value": "25400"},
          {"value": "27800"},
          {"value": "23800"},
          {"value": "23800"},
          {"value": "21600"},
          {"value": "30600"},
          {"value": "24800"},
          {"value": "30700"},
          {"value": "27400"},
          {"value": "28200"},
          {"value": "31500"},
          {"value": "24300"}
        ]
      },
      {
        "seriesname": "Services",
        "color": "f8bd19",
        "data": [
          {"value": "10000"},
          {"value": "11500"},
          {"value": "12500"},
          {"value": "15000"},
          {"value": "11000"},
          {"value": "9800"},
          {"value": "11800"},
          {"value": "19700"},
          {"value": "21700"},
          {"value": "21900"},
          {"value": "22900"},
          {"value": "20800"},
          {"value": "12000"},
          {"value": "10300"},
          {"value": "11200"},
          {"value": "13000"},
          {"value": "15000"},
          {"value": "11800"},
          {"value": "9800"},
          {"value": "14600"},
          {"value": "19200"},
          {"value": "20100"},
          {"value": "21200"},
          {"value": "19500"}
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
        type: "scrollstackedcolumn2d",
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
          title: const Text('Fusion Charts - Scroll Stacked Column'),
        ),
        body: Column(
          children: [
            Expanded(child: _fusionChart2D),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Text('Scroll Stacked Column 2D'),
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
