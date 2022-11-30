import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_fusioncharts/flutter_fusioncharts.dart';
import '../../constants.dart';

class ScrollMultiseries extends StatefulWidget {
  const ScrollMultiseries({super.key});

  @override
  State<ScrollMultiseries> createState() => _ScrollMultiseriesState();
}

class _ScrollMultiseriesState extends State<ScrollMultiseries> {
  late FusionCharts _fusionChart2D;
  FusionChartsController fc = FusionChartsController();

  @override
  void initState() {
    super.initState();
    WidgetsFlutterBinding.ensureInitialized();

    Map<String, dynamic> chart = {
      "caption": "Market Share of Korean Automobile Manufacturers in US",
      "subcaption": "2005 - 2019",
      "pyaxisname": "Units Sold",
      "syaxisname": "% of total market share",
      "snumbersuffix": "%",
      "syaxismaxvalue": "25",
      "theme": "fusion",
      "showvalues": "0",
      "drawcrossline": "1",
      "divlinealpha": "20",
      "baseFontSize": "30px",
      "captionFontSize": "30px",
    };

    List<dynamic> categories = [
      {
        "category": [
          {"label": "2005"},
          {"label": "2006"},
          {"label": "2007"},
          {"label": "2008"},
          {"label": "2009"},
          {"label": "2010"},
          {"label": "2011"},
          {"label": "2012"},
          {"label": "2013"},
          {"label": "2014"},
          {"label": "2015"},
          {"label": "2016"},
          {"label": "2017"},
          {"label": "2018"},
          {"label": "2019"}
        ]
      }
    ];
    List<dynamic> dataset = [
      {
        "dataset": [
          {
            "seriesname": "Honda City",
            "data": [
              {"value": "997281"},
              {"value": "1063599"},
              {"value": "1063964"},
              {"value": "1152123"},
              {"value": "1289128"},
              {"value": "1394972"},
              {"value": "1331194"},
              {"value": "1047958"},
              {"value": "974751"},
              {"value": "983243"},
              {"value": "1294208"},
              {"value": "1435345"},
              {"value": "1217785"},
              {"value": "1163621"},
              {"value": "1161561"}
            ]
          },
          {
            "seriesname": "Honda Civic",
            "data": [
              {"value": "196354"},
              {"value": "259493"},
              {"value": "234755"},
              {"value": "205717"},
              {"value": "205081"},
              {"value": "224978"},
              {"value": "1277225"},
              {"value": "1132872"},
              {"value": "852656"},
              {"value": "1234768"},
              {"value": "205081"},
              {"value": "1027759"},
              {"value": "1141363"},
              {"value": "1277225"},
              {"value": "1285716"}
            ]
          }
        ]
      },
      {
        "dataset": [
          {
            "seriesname": "Hyundai Verna",
            "data": [
              {"value": "373709"},
              {"value": "391276"},
              {"value": "380002"},
              {"value": "411456"},
              {"value": "476001"},
              {"value": "500537"},
              {"value": "413815"},
              {"value": "496356"},
              {"value": "514865"},
              {"value": "697118"},
              {"value": "567824"},
              {"value": "525457"},
              {"value": "576222"},
              {"value": "484427"},
              {"value": "491488"}
            ]
          },
          {
            "seriesname": "Hyundai Sonata",
            "data": [
              {"value": "47548"},
              {"value": "73130"},
              {"value": "107659"},
              {"value": "179783"},
              {"value": "202390"},
              {"value": "156107"},
              {"value": "88315"},
              {"value": "103964"},
              {"value": "191982"},
              {"value": "120271"},
              {"value": "125909"},
              {"value": "138739"},
              {"value": "179152"},
              {"value": "131125"},
              {"value": "181549"}
            ]
          }
        ]
      }
    ];
    List<dynamic> lineset = [
      {
        "seriesname": "Market Share %",
        "plottooltext":
            "Total market share of Korean cars in \$label is <b>\$dataValue</b> in US",
        "showvalues": "0",
        "data": [
          {"value": "17.74"},
          {"value": "19.23"},
          {"value": "15.43"},
          {"value": "12.34"},
          {"value": "15.34"},
          {"value": "21.17"},
          {"value": "13.14"},
          {"value": "18.13"},
          {"value": "13.13"},
          {"value": "15.34"},
          {"value": "14.74"},
          {"value": "18.17"},
          {"value": "19.22"},
          {"value": "17.74"},
          {"value": "20.17"}
        ]
      }
    ];
    Map<String, dynamic> dataSource = {
      "chart": chart,
      "dataset": dataset,
      "categories": categories,
      "lineset":lineset
    };

    _fusionChart2D = FusionCharts(
        dataSource: dataSource,
        type: "scrollmsstackedcolumn2dlinedy",
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
          title: const Text('Fusion Charts - Multiseries'),
        ),
        body: Column(
          children: [
            Expanded(child: _fusionChart2D),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Text('Scroll Multiseries'),
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
