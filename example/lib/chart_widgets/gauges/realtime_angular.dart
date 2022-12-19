import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_fusioncharts/flutter_fusioncharts.dart';
import '../../constants.dart';

class RealTimeAngular extends StatefulWidget {
  const RealTimeAngular({super.key});

  @override
  State<RealTimeAngular> createState() => _RealTimeAngularState();
}

class _RealTimeAngularState extends State<RealTimeAngular> {
  late FusionCharts _fusionChart2D;
  FusionChartsController fc = FusionChartsController();

  @override
  void initState() {
    super.initState();
    WidgetsFlutterBinding.ensureInitialized();

    Map<String, dynamic> chart = {
      "caption": "Speedometer",
      "origw": "320",
      "origh": "320",
      "tickvaluedistance": "-10",
      "upperlimit": "240",
      "lowerlimit": "0",
      "basefontcolor": "#FFFFFF",
      "majortmnumber": "9",
      "majortmcolor": "#FFFFFF",
      "majortmheight": "8",
      "majortmthickness": "5",
      "minortmnumber": "5",
      "minortmcolor": "#FFFFFF",
      "minortmheight": "3",
      "minortmthickness": "2",
      "pivotradius": "10",
      "pivotbgcolor": "#000000",
      "pivotbordercolor": "#FFFFFF",
      "pivotborderthickness": "2",
      "tooltipbordercolor": "#FFFFFF",
      "tooltipbgcolor": "#333333",
      "gaugeouterradius": "115",
      "gaugestartangle": "240",
      "gaugeendangle": "-60",
      "decimals": "0",
      "placevaluesinside": "1",
      "pivotfillmix": "",
      "showpivotborder": "1",
      "annrenderdelay": "0",
      "gaugeoriginx": "160",
      "gaugeoriginy": "160",
      "theme": "zune",
      
    };
    Map<String, dynamic> dials = {
      "dial": [
        {
          "value": "65",
          "bgcolor": "000000",
          "bordercolor": "#FFFFFF",
          "borderalpha": "100",
          "basewidth": "4",
          "topwidth": "4",
          "borderthickness": "2",
          "valuey": "260"
        }
      ]
    };
    Map<String, dynamic> annotations = {
      "groups": [
        {
          "x": "160",
          "y": "160",
          "items": [
            {
              "type": "circle",
              "radius": "130",
              "fillasgradient": "1",
              "fillcolor": "#4B4B4B,#AAAAAA",
              "fillalpha": "100,100",
              "fillratio": "95,5"
            },
            {
              "type": "circle",
              "x": "0",
              "y": "0",
              "radius": "120",
              "showborder": "1",
              "bordercolor": "cccccc",
              "fillasgradient": "1",
              "fillcolor": "#ffffff,#000000",
              "fillalpha": "50,100",
              "fillratio": "1,99"
            }
          ]
        },
        {
          "x": "160",
          "y": "160",
          "showbelow": "0",
          "scaletext": "1",
          "items": [
            {
              "type": "text",
              "y": "100",
              "label": "KPH",
              "fontcolor": "#FFFFFF",
              "fontsize": "14",
              "bold": "1"
            }
          ]
        }
      ]
    };

    Map<String, dynamic> dataSource = {
      "chart": chart,
      "dials": dials,
      "annotations": annotations
    };

    _fusionChart2D = FusionCharts(
        dataSource: dataSource,
        type: "angulargauge",
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
          title: const Text('FC - Realtime Angular Chart'),
        ),
        body: Column(
          children: [
            Expanded(child: _fusionChart2D),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Text('Realtime Angular Chart'),
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
