import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_fusioncharts/flutter_fusioncharts.dart';
import '../../constants.dart';

class HeatMap extends StatefulWidget {
  const HeatMap({super.key});

  @override
  State<HeatMap> createState() => _HeatMapState();
}

class _HeatMapState extends State<HeatMap> {
  late FusionCharts _fusionChart2D;

  @override
  void initState() {
    super.initState();
    WidgetsFlutterBinding.ensureInitialized();

    Map<String, dynamic> chart = {
      "caption": "Top Smartphone Ratings",
      "subcaption": "By Features",
      "xAxisName": "Features",
      "yAxisName": "Model",
      "plottooltext":
      "<div id='nameDiv' style='font-size: 12px; border-bottom: 1px dashed #666666; font-weight:bold; padding-bottom: 3px; margin-bottom: 5px; display: inline-block; color: #888888;' >\$rowLabel :</div>{br}Rating : <b>\$dataValue</b>{br}\$columnLabel : <b>\$tlLabel</b>{br}<b>\$trLabel</b>",
      "theme": "gammel",
      "baseFontSize": "30px",
      "captionFontSize": "30px",
    };
    Map<String, dynamic> rows = {
      "row": [
        {"id": "SGS5", "label": "Samsung Galaxy S5"},
        {"id": "HTC1M8", "label": "HTC One (M8)"},
        {"id": "IPHONES5", "label": "Apple iPhone 5S"},
        {"id": "LUMIA", "label": "Nokia Lumia 1520"}
      ]
    };
    Map<String, dynamic> columns = {
      "column": [
        {"id": "processor", "label": "Processor"},
        {"id": "screen", "label": "Screen Size"},
        {"id": "price", "label": "Price"},
        {"id": "backup", "label": "Battery Backup"},
        {"id": "cam", "label": "Camera"}
      ]
    };
    Map<String, dynamic> colorrange = {"gradient": "0","minvalue": "0","code": "E24B1A","startlabel": "Poor","endlabel": "Good","color": [{"code": "E24B1A","minvalue": "1","maxvalue": "5","label": "Bad"},{"code": "F6BC33","minvalue": "5","maxvalue": "8.5","label": "Average"},{"code": "6DA81E","minvalue": "8.5","maxvalue": "10","label": "Good"}]};

    List<dynamic> dataset = [
      {
        "data": [
          {
            "rowid": "SGS5",
            "columnid": "processor",
            "value": "8.7",
            "tllabel": "Quad Core 2.5 GHz",
            "trlabel": "OS : Android 4.4 Kitkat"
          },
          {
            "rowid": "SGS5",
            "columnid": "screen",
            "value": "8.5",
            "tllabel": "5.1 inch",
            "trlabel": "AMOLED screen"
          },
          {
            "rowid": "SGS5",
            "columnid": "price",
            "value": "9.3",
            "tllabel": "\$600"
          },
          {
            "rowid": "SGS5",
            "columnid": "backup",
            "value": "9.7",
            "tllabel": "29 Hrs",
            "trlabel": "Battery : 2800 MAH"
          },
          {
            "rowid": "SGS5",
            "columnid": "cam",
            "value": "8",
            "tllabel": "16 MP",
            "trlabel": "Front Camera : 2.1 MP"
          },
          {
            "rowid": "HTC1M8",
            "columnid": "processor",
            "value": "9.2",
            "tllabel": "Quad Core 2.3 GHz",
            "trlabel": "OS : Android 4.4 Kitkat"
          },
          {
            "rowid": "HTC1M8",
            "columnid": "screen",
            "value": "8.3",
            "tllabel": "5 inch",
            "trlabel": "LCD screen"
          },
          {
            "rowid": "HTC1M8",
            "columnid": "price",
            "value": "7.3",
            "tllabel": "\$600"
          },
          {
            "rowid": "HTC1M8",
            "columnid": "backup",
            "value": "8.8",
            "tllabel": "20 Hrs",
            "trlabel": "Battery : 2600 MAH"
          },
          {
            "rowid": "HTC1M8",
            "columnid": "cam",
            "value": "8.7",
            "tllabel": "4 MP",
            "trlabel": "Front Camera : 5 MP"
          },
          {
            "rowid": "IPHONES5",
            "columnid": "processor",
            "value": "9.1",
            "tllabel": "Dual Core",
            "trlabel": "OS : iOS 7"
          },
          {
            "rowid": "IPHONES5",
            "columnid": "screen",
            "value": "8.6",
            "tllabel": "4 inch",
            "trlabel": "Retina LCD screen"
          },
          {
            "rowid": "IPHONES5",
            "columnid": "price",
            "value": "7.2",
            "tllabel": "\$649"
          },
          {
            "rowid": "IPHONES5",
            "columnid": "backup",
            "value": "8.4",
            "tllabel": "10 Hrs",
            "trlabel": "Battery : 1560 MAH"
          },
          {
            "rowid": "IPHONES5",
            "columnid": "cam",
            "value": "9.5",
            "tllabel": "8 MP",
            "trlabel": "Front Camera : 1.2 MP"
          },
          {
            "rowid": "LUMIA",
            "columnid": "processor",
            "value": "8.8",
            "tllabel": "Quad Core 2.2 GHz",
            "trlabel": "OS: Windows Phone 8"
          },
          {
            "rowid": "LUMIA",
            "columnid": "screen",
            "value": "9.1",
            "tllabel": "6 inch",
            "trlabel": "LCD screen"
          },
          {
            "rowid": "LUMIA",
            "columnid": "price",
            "value": "9.7",
            "tllabel": "\$470"
          },
          {
            "rowid": "LUMIA",
            "columnid": "backup",
            "value": "9.2",
            "tllabel": "27 Hrs",
            "trlabel": "Battery : 3400 MAH"
          },
          {
            "rowid": "LUMIA",
            "columnid": "cam",
            "value": "8.1",
            "tllabel": "20MP",
            "trlabel": "Front Camera : 1.2 MP"
          }
        ]
      }
    ];

    Map<String, dynamic> dataSource = {
      "chart": chart,
      "rows": rows,
      "columns": columns,
      "colorrange":colorrange,
      "dataset": dataset
    };

    _fusionChart2D = FusionCharts(
        dataSource: dataSource,
        type: "heatmap",
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
          title: const Text('Fusion Charts - Heat Map'),
        ),
        body: Column(
          children: [
            Expanded(child: _fusionChart2D),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Text('HeatMap Chart'),
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
