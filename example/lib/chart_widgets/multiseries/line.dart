import 'package:flutter/material.dart';
import 'package:flutter_fusioncharts/flutter_fusioncharts.dart';
import '../../constants.dart';

class LineMultiSeries extends StatefulWidget {
  const LineMultiSeries({super.key});

  @override
  State<LineMultiSeries> createState() => _LineMultiSeriesState();
}

class _LineMultiSeriesState extends State<LineMultiSeries> {
  late FusionCharts _fusionChart2d;
  FusionChartsController fusionChartsController = FusionChartsController();

  // late final FusionChartsController _fusionChartsController =
  // FusionChartsController();
  @override
  void initState() {
    super.initState();
    WidgetsFlutterBinding.ensureInitialized();

    List<dynamic> categories = [
      {
        "category": [
          {"label": "Mon"},
          {"label": "Tue"},
          {"label": "Wed"},
          {
            "vline": "true",
            "lineposition": "0",
            "color": "#6baa01",
            "labelHAlign": "center",
            "labelPosition": "0",
            "label": "National holiday",
            "dashed": "1"
          },
          {"label": "Thu"},
          {"label": "Fri"},
          {"label": "Sat"},
          {"label": "Sun"}
        ]
      }
    ];
    // Construct the dataset comprising multiple series
    List<dynamic> dataset = [
      {
        "seriesname": "Bakersfield Central",
        "data": [
          {"value": "15123"},
          {"value": "14233"},
          {"value": "25507"},
          {"value": "9110"},
          {"value": "15529"},
          {"value": "20803"},
          {"value": "19202"}
        ]
      },
      {
        "seriesname": "Los Angeles Topanga",
        "data": [
          {"value": "13400"},
          {"value": "12800"},
          {"value": "22800"},
          {"value": "12400"},
          {"value": "15800"},
          {"value": "19800"},
          {"value": "21800"}
        ]
      }
    ];

    Map<String, dynamic> chart = {
      "caption": "Number of visitors last week",
      "subCaption": "Bakersfield Central vs Los Angeles Topanga",
      "xAxisName": "Day",
      "theme": "fusion",
      "baseFontSize": "30px",
      "captionFontSize": "30px",
    };

    Map<String, dynamic> dataSource = {
      "chart": chart,
      "dataset": dataset,
      "categories": categories,
      "trendlines": [
        {
          "line": [
            {
              "startvalue": "17022",
              "color": "#6baa01",
              "valueOnRight": "1",
              "displayvalue": "Average"
            }
          ]
        }
      ]
    };

    _fusionChart2d = FusionCharts(
        dataSource: dataSource,
        type: "msline",
        width: "100%",
        height: "100%",
        fusionChartsController: fusionChartsController,
        licenseKey: licenseKey);
  }

  void callBackFromPlugin(arg1, arg2) {
    print('Back to consumer: $arg1 , $arg2');
  }

  // changeType() {
  //   print('Change type msColumn3D');
  //   if (_2d) {
  //     _fusionChartsController
  //         .executeScript("globalFusionCharts.chartType('msColumn3D')");
  //   } else {
  //     _fusionChartsController
  //         .executeScript("globalFusionCharts.chartType('msColumn2D')");
  //   }
  //   _2d = !_2d;
  // }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          leading: IconButton(
              onPressed: () => Navigator.of(context).pop(),
              icon: const Icon(Icons.arrow_back)),
          title: const Text('Fusion Charts - Line2D MultiSeries'),
        ),
        body: SizedBox(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Column(
            children: [
              Expanded(child: _fusionChart2d),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Text('Line2D'),
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
