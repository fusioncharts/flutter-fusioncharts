import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_fusioncharts/flutter_fusioncharts.dart';
import '../../constants.dart';

class WorldMap extends StatefulWidget {
  const WorldMap({super.key});

  @override
  State<WorldMap> createState() => _WorldMapState();
}

class _WorldMapState extends State<WorldMap> {
  late FusionCharts _fusionChart;

  FusionChartsController fusionChartsController = FusionChartsController();

  @override
  void initState() {
    super.initState();
    WidgetsFlutterBinding.ensureInitialized();

    List<dynamic> dataset = [
      {"id": "NA", "value": "515","label":"North America",
      },
      {"id": "SA", "value": "373","label":"South America"},
      {"id": "AS", "value": "3875","label":"Asia"},
      {"id": "EU", "value": "727","label":"Europe"},
      {"id": "AF", "value": "885","label":"Africa"},
      {"id": "AU", "value": "32","label":"Australia",
        "Font": "Helvetica",
        "FontSize": "40",
        "FontColor": "#383838",
        "FontBold": "1"
      }
    ];

    Map<String, dynamic> chart = {
      "caption": "Global Population",
      "theme": "fusion",
      "formatNumberScale": "0",
      "numberSuffix": "M",
      "baseFontSize": "30px",
      "captionFontSize": "30px",
      "showLabels": "1",
      "useSNameInLabels": "1",
    };
    Map<String, dynamic> markers = {
      "items": [
        {
          "id": "lon",
          "shapeid": "triangle",
          "x": "340.23",
          "y": "125.9",
          "label": "LHR",
          "tooltext": "Heathrow International Airport {br}IACL Code : EGLL",
          "labelpos": "left"
        },
        {
          "id": "alt",
          "shapeid": "triangle",
          "x": "160.14",
          "y": "164.9",
          "label": "ATL",
          "tooltext":
              "Hartsfield Jackson Atlanta International Airport {br}IACL Code : KATL",
          "labelpos": "bottom"
        },
        {
          "id": "dub",
          "shapeid": "triangle",
          "x": "458.14",
          "y": "203.9",
          "label": "DXB",
          "tooltext": "Dubai International Airport {br} IACL Code : OMDB",
          "labelpos": "bottom"
        },
        {
          "id": "tok",
          "shapeid": "triangle",
          "x": "628.14",
          "y": "165.9",
          "label": "HND",
          "tooltext": "Tokyo Haneda Airport{br} IACL Code : RJTT",
          "labelpos": "bottom"
        },
        {
          "id": "beij",
          "shapeid": "triangle",
          "x": "573.14",
          "y": "161.9",
          "label": "PEK",
          "tooltext":
              "Beijing Capital International Airport {br} IACL Code : ZBAA",
          "labelpos": "bottom"
        }
      ]
    };
    Map<String, dynamic> colorrange = {
      "color": [
        {
          "minvalue": "0",
          "maxvalue": "100",
          "code": "#D0DFA3",
          "displayValue": "< 100M"
        },
        {
          "minvalue": "100",
          "maxvalue": "500",
          "code": "#B0BF92",
          "displayValue": "100-500M"
        },
        {
          "minvalue": "500",
          "maxvalue": "1000",
          "code": "#91AF64",
          "displayValue": "500M-1B"
        },
        {
          "minvalue": "1000",
          "maxvalue": "5000",
          "code": "#A9FF8D",
          "displayValue": "> 1B"
        }
      ]
    };

    Map<String, dynamic> dataSource = {
      "chart": chart,
      "data": dataset,
      "colorrange": colorrange,
      "markers": markers
    };

    _fusionChart = FusionCharts(
        dataSource: dataSource,
        type: "maps/world",
        width: "100%",
        height: "100%",
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
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          leading: IconButton(
              onPressed: () => Navigator.of(context).pop(),
              icon: const Icon(Icons.arrow_back)),
          title: const Text('Fusion Charts - World Map'),
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
                  Text('World Map'),
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
