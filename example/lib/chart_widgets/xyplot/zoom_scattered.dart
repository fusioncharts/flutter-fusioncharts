import 'package:flutter/material.dart';
import 'package:flutter_fusioncharts/flutter_fusioncharts.dart';
import '../../constants.dart';

class ZoomScattered extends StatefulWidget {
  const ZoomScattered({super.key});

  @override
  State<ZoomScattered> createState() => _ZoomScatteredState();
}

class _ZoomScatteredState extends State<ZoomScattered> {
  late FusionCharts _fusionChart;

  FusionChartsController fusionChartsController = FusionChartsController();

  @override
  void initState() {
    super.initState();
    WidgetsFlutterBinding.ensureInitialized();

    List<dynamic> categories = [
      {
        "verticalLineDashed": "1",
        "verticalLineDashLen": "1",
        "verticalLineDashGap": "1",
        "verticalLineThickness": "1",
        "verticalLineColor": "#000000",
        "category": [
          {"x": "23", "label": "23° F", "showverticalline": "0"},
          {"x": "32", "label": "32° F", "showverticalline": "1"},
          {"x": "50", "label": "50° F", "showverticalline": "1"},
          {"x": "68", "label": "68° F", "showverticalline": "1"},
          {"x": "80", "label": "80° F", "showverticalline": "1"},
          {"x": "95", "label": "95° F", "showverticalline": "1"}
        ]
      }
    ];

    List<dynamic> trendlines = [
      {
        "line": [
          {
            "startvalue": "5.2",
            "displayvalue": "Check",
            "linethickness": "2",
            "color": "FF0000",
            "valueonright": "1",
            "dashed": "1",
            "dashgap": "5"
          }
        ]
      }
    ];

    List<dynamic> dataset = [
      {
        "drawline": "1",
        "seriesname": "Server 1",
        "color": "009900",
        "anchorsides": "3",
        "anchorradius": "4",
        "anchorbgcolor": "D5FFD5",
        "anchorbordercolor": "009900",
        "data": [
          {"y": "2.4", "x": "21"},
          {"y": "3.5", "x": "32"},
          {"y": "2.5", "x": "43"},
          {"y": "4.1", "x": "48"},
          {"y": "3.5", "x": "50"},
          {"y": "4.6", "x": "56"},
          {"y": "4.8", "x": "59"},
          {"y": "4.9", "x": "73"},
          {"y": "4.6", "x": "89"},
          {"y": "4.2", "x": "93"}
        ]
      },
      {
        "seriesname": "Server 2",
        "color": "0000FF",
        "anchorsides": "4",
        "anchorradius": "4",
        "anchorbgcolor": "C6C6FF",
        "anchorbordercolor": "0000FF",
        "data": [
          {"y": "1.4", "x": "23"},
          {"y": "1.5", "x": "29"},
          {"y": "1.5", "x": "33"},
          {"y": "1.1", "x": "41"},
          {"y": "1.5", "x": "47"},
          {"y": "1.6", "x": "49"},
          {"y": "1.8", "x": "51"},
          {"y": "1.9", "x": "53"},
          {"y": "1.6", "x": "57"},
          {"y": "1.2", "x": "58"},
          {"y": "1.9", "x": "61"},
          {"y": "1.1", "x": "63"},
          {"y": "1.9", "x": "64"},
          {"y": "1.7", "x": "71"},
          {"y": "1.1", "x": "77"},
          {"y": "1.3", "x": "79"},
          {"y": "1.7", "x": "83"},
          {"y": "1.8", "x": "89"},
          {"y": "1.9", "x": "91"},
          {"y": "1.0", "x": "93"}
        ]
      }
    ];

    List<dynamic> vtrendlines = [
      {
        "line": [
          {
            "startvalue": "23",
            "endvalue": "32",
            "istrendzone": "1",
            "displayvalue": " ",
            "color": "#adebff",
            "alpha": "25"
          },
          {
            "startvalue": "23",
            "endvalue": "32",
            "istrendzone": "1",
            "alpha": "0",
            "displayvalue": "Very cold"
          },
          {
            "startvalue": "32",
            "endvalue": "50",
            "istrendzone": "1",
            "displayvalue": " ",
            "color": "#adebff",
            "alpha": "15"
          },
          {
            "startvalue": "32",
            "endvalue": "50",
            "istrendzone": "1",
            "alpha": "0",
            "displayvalue": "Cold"
          },
          {
            "startvalue": "50",
            "endvalue": "68",
            "istrendzone": "1",
            "alpha": "0",
            "displayvalue": "Moderate"
          },
          {
            "startvalue": "68",
            "endvalue": "80",
            "istrendzone": "1",
            "alpha": "0",
            "displayvalue": "Hot"
          },
          {
            "startvalue": "68",
            "endvalue": "80",
            "istrendzone": "1",
            "displayvalue": " ",
            "color": "#f2a485",
            "alpha": "15"
          },
          {
            "startvalue": "80",
            "endvalue": "95",
            "istrendzone": "1",
            "alpha": "0",
            "displayvalue": "Very hot"
          },
          {
            "startvalue": "80",
            "endvalue": "95",
            "istrendzone": "1",
            "displayvalue": " ",
            "color": "#f2a485",
            "alpha": "25"
          }
        ]
      }
    ];

    Map<String, dynamic> chart = {
      "caption": "Server Performance",
      "yaxisname": "Response Time (sec)",
      "xaxisname": "Server Load (TPS)",
      "xaxismaxvalue": "100",
      "xaxisminvalue": "20",
      "yaxismaxvalue": "7",
      "theme": "carbon",
      
    };

    Map<String, dynamic> dataSource = {
      "chart": chart,
      "dataset": dataset,
      "categories": categories,
      "vtrendlines": vtrendlines,
      "trendlines": trendlines
    };

    _fusionChart = FusionCharts(
        dataSource: dataSource,
        type: "zoomscatter",
        width: "100%",
        height: "100%",
        fusionChartsController: fusionChartsController,
        licenseKey: licenseKey);
  }

  void callBackFromPlugin(arg1, arg2) {
    print('Back to consumer: $arg1 , $arg2');
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          leading: IconButton(
              onPressed: () => Navigator.of(context).pop(),
              icon: const Icon(Icons.arrow_back)),
          title: const Text(
            'Fusion Charts - Zoom Scattered',
            style: TextStyle(fontSize: 16),
          ),
        ),
        body: SizedBox(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Column(
            children: [
              Expanded(child: _fusionChart),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Text('Zoom Scattered'),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
