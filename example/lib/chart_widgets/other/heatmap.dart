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
      "theme": "fusion",
      "caption": "Top Smartphones by Features",
      "subcaption": "Source: Q1 Customer Satisfaction Survey",
      "showvalues": "1",
      "plottooltext":
      "<div><b>\$rowLabel</b><br/>\$columnLabel Rating: <b>\$datavalue</b>/10</div>"
    };
    Map<String, dynamic> rows = {
      "row": [
        {
          "id": "SGS9",
          "label": "Samsung Galaxy S9"
        },
        {
          "id": "iphonex",
          "label": "Iphone X"
        },
        {
          "id": "op6",
          "label": "One Plus 6"
        },
        {
          "id": "motoz2",
          "label": "Moto Z2 Force"
        }
      ]
    };
    Map<String, dynamic> columns = {
      "column": [
        {
          "id": "processor",
          "label": "Processor"
        },
        {
          "id": "screen",
          "label": "Screen Size"
        },
        {
          "id": "price",
          "label": "Price"
        },
        {
          "id": "backup",
          "label": "Battery Capacity"
        },
        {
          "id": "cam",
          "label": "Camera"
        }
      ]
    };
    Map<String, dynamic> colorrange = {
      "gradient": "1",
      "minvalue": "5",
      "maxvalue": "10",
      "mapbypercent": "0",
      "code": "#67CDF2",
      "startlabel": "Poor",
      "endlabel": "Outstanding"
    };

    List<dynamic> dataset =  [
      {
        "data": [
          {
            "rowid": "SGS9",
            "columnid": "processor",
            "value": "8.7",
            "tllabel": "Octa Core 2.8GHz"
          },
          {
            "rowid": "SGS9",
            "columnid": "screen",
            "value": "8.5",
            "bllabel": "5.8 inch"
          },
          {
            "rowid": "SGS9",
            "columnid": "price",
            "value": "9.3",
            "tllabel": "\$720"
          },
          {
            "rowid": "SGS9",
            "columnid": "backup",
            "value": "9.7",
            "brlabel": "3000 MAH"
          },
          {
            "rowid": "SGS9",
            "columnid": "cam",
            "value": "8",
            "trlabel": "8 MP"
          },
          {
            "rowid": "iphonex",
            "columnid": "processor",
            "value": "9.2",
            "tllabel": "A11 Bionic Chip "
          },
          {
            "rowid": "iphonex",
            "columnid": "screen",
            "value": "8.3",
            "bllabel": "5.8 inch"
          },
          {
            "rowid": "iphonex",
            "columnid": "price",
            "value": "7.3",
            "tllabel": "\$999"
          },
          {
            "rowid": "iphonex",
            "columnid": "backup",
            "value": "8.8",
            "brlabel": "2716 MAH"
          },
          {
            "rowid": "iphonex",
            "columnid": "cam",
            "value": "8.7",
            "trlabel": "12 MP"
          },
          {
            "rowid": "op6",
            "columnid": "processor",
            "value": "9.1",
            "tllabel": "Octa Core 2.8GHz"
          },
          {
            "rowid": "op6",
            "columnid": "screen",
            "value": "8.6",
            "bllabel": "6.28 inch"
          },
          {
            "rowid": "op6",
            "columnid": "price",
            "value": "7.2",
            "tllabel": "\$529"
          },
          {
            "rowid": "op6",
            "columnid": "backup",
            "value": "8.4",
            "brlabel": "3300 MAH"
          },
          {
            "rowid": "op6",
            "columnid": "cam",
            "value": "9.5",
            "trlabel": "16 MP"
          },
          {
            "rowid": "motoz2",
            "columnid": "processor",
            "value": "8.8",
            "tllabel": "Quad Core 2.35GHz"
          },
          {
            "rowid": "motoz2",
            "columnid": "screen",
            "value": "8.1",
            "bllabel": "5.5 inch"
          },
          {
            "rowid": "motoz2",
            "columnid": "price",
            "value": "9.7",
            "tllabel": "\$370"
          },
          {
            "rowid": "motoz2",
            "columnid": "backup",
            "value": "9.2",
            "brlabel": "2730 MAH"
          },
          {
            "rowid": "motoz2",
            "columnid": "cam",
            "value": "7.1",
            "trlabel": "24 MP"
          }
        ]
      }
    ];

    Map<String, dynamic> dataSource = {
      "chart": chart,
      "rows": rows,
      "columns": columns,
      "colorrange": colorrange,
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
