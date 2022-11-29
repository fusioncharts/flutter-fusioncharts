import 'package:flutter/material.dart';
import 'package:flutter_fusioncharts/flutter_fusioncharts.dart';
import 'package:flutter_fusioncharts_example/chartdata.dart';
import '../../constants.dart';

class AnnotatedBar extends StatefulWidget {
  const AnnotatedBar({super.key});

  @override
  State<AnnotatedBar> createState() => _AnnotatedBarState();
}

class _AnnotatedBarState extends State<AnnotatedBar> {
  late FusionCharts _fusionChart2D;
  late FusionCharts _fusionChart3D;
  void initState() {
    super.initState();
    WidgetsFlutterBinding.ensureInitialized();

    Map<String, dynamic> chart = {
      "caption": "Bakersfield Central - Total footfalls",
      "subCaption": "Last week",
      "xAxisName": "Day",
      "yAxisName": "No. of Visitors",
      "theme": "fusion",
      "baseFontSize": "30px",
      "captionFontSize": "30px",
    };

    Map<String, dynamic> annotations = {
      "origw": "400",
      "origh": "300",
      "autoscale": "1",
      "groups": [
        {
          "items": [
            {
              "id": "high-labels-zone",
              "type": "rectangle",
              "x": "\$yaxis.0.label.5.startx + 5",
              "y": "\$yaxis.0.label.5.starty",
              "tox": "\$yaxis.0.label.3.endx + 200",
              "toy": "\$yaxis.0.label.3.starty + 50",
              "color": "#6baa01",
              "alpha": "20"
            },
            {
              "id": "high-label",
              "type": "text",
              "text": "High",
              "x": "\$yaxis.0.label.4.startx - 5 + 200",
              "y": "\$yaxis.0.label.4.starty + 50",
              "rotateText": "1",
              "color": "#6baa01"
            },
            {
              "id": "moderate-labels-zone",
              "type": "rectangle",
              "x": "\$yaxis.0.label.3.startx + 5",
              "y": "\$yaxis.0.label.3.starty",
              "tox": "\$yaxis.0.label.2.endx + 200",
              "toy": "\$yaxis.0.label.1.starty+ 50",
              "color": "#f8bd19",
              "alpha": "20"
            },
            {
              "id": "moderate-label",
              "type": "text",
              "text": "Moderate",
              "x": "\$yaxis.0.label.2.startx - 5 + 100",
              "y": "\$yaxis.0.label.2.starty + 50",
              "rotateText": "1",
              "color": "#f8bd19"
            },
            {
              "id": "low-labels-zone",
              "type": "rectangle",
              "x": "\$yaxis.0.label.1.startx - 3",
              "y": "\$yaxis.0.label.1.starty",
              "tox": "\$yaxis.0.label.0.endx + 200",
              "toy": "\$yaxis.0.label.0.endy + 50",
              "color": "#e44a00",
              "alpha": "20"
            },
            {
              "id": "low-label",
              "type": "text",
              "text": "Low",
              "x": "\$yaxis.0.label.1.startx - 12",
              "y": "\$yaxis.0.label.0.starty - 5",
              "rotateText": "1",
              "color": "#e44a00"
            }
          ]
        }
      ]
    };

    List<dynamic> chartData = [
      {"label": "Mon", "value": "15123"},
      {"label": "Tue", "value": "14233"},
      {"label": "Wed", "value": "25507"},
      {
        "vline": "true",
        "lineposition": "0",
        "color": "#6baa01",
        "labelHAlign": "left",
        "label": "National holiday"
      },
      {"label": "Thu", "value": "9110"},
      {"label": "Fri", "value": "15529"},
      {"label": "Sat", "value": "20803"},
      {"label": "Sun", "value": "19202"}
    ];
    FusionChartsController fusionChartsController = FusionChartsController();
    Map<String, dynamic> dataSource = {
      "chart": chart,
      "data": chartData,
      "annotations": annotations
    };
    fusionChartsController.addEvents([]);

    _fusionChart2D = FusionCharts(
        dataSource: dataSource,
        type: "column2d",
        width: "100%",
        height: "100%",
        webviewEvent: (a, b) => {},
        fusionChartEvent: (a, b) => {},
        fusionChartsController: fusionChartsController,
        licenseKey: licenseKey);
    _fusionChart3D = FusionCharts(
        dataSource: dataSource,
        type: "bar3d",
        width: "100%",
        height: "100%",
        webviewEvent: (a, b) => {},
        fusionChartEvent: (a, b) => {},
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
              icon: const Icon(Icons.arrow_back),
              onPressed: () => Navigator.of(context).pop()),
          title: const Text('Fusion Charts - Annotated Bar'),
        ),
        body: Column(
          children: [
            Expanded(
                child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: _fusionChart2D,
            )),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Text('AnnotatedBar 2D'),
              ],
            ),
            // const SizedBox(
            //   height: 10,
            // ),
            // Expanded(child: _fusionChart3D),
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.center,
            //   children: const [
            //     Text('AnnotatedBar 3D'),
            //   ],
            // ),
            const SizedBox(
              height: 10,
            ),
          ],
        ),
      ),
    );
  }
}
