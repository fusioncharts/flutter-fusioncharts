import 'package:flutter/material.dart';
import 'package:flutter_fusioncharts/flutter_fusioncharts.dart';
import '../../constants.dart';

class Marimekko extends StatefulWidget {
  const Marimekko({super.key});

  @override
  State<Marimekko> createState() => _MarimekkoState();
}

class _MarimekkoState extends State<Marimekko> {
  late FusionCharts _fusionChart2d;
  FusionChartsController fusionChartsController = FusionChartsController();

  @override
  void initState() {
    super.initState();
    WidgetsFlutterBinding.ensureInitialized();

    List<dynamic> categories = [
      {
        "category": [
          {"label": "Q1"},
          {"label": "Q2"},
          {"label": "Q3"},
          {"label": "Q4"}
        ]
      }
    ];
    // Construct the dataset comprising multiple series
    List<dynamic> dataset = [
      {
        "seriesname": "Food Products",
        "data": [
          {"value": "17000"},
          {"value": "19500"},
          {"value": "12500"},
          {"value": "14500"},
          {"value": "17500"}
        ]
      },
      {
        "seriesname": "Non-Food Products",
        "data": [
          {"value": "25400"},
          {"value": "29800"},
          {"value": "21800"},
          {"value": "19500"},
          {"value": "11500"}
        ]
      }
    ];

    Map<String, dynamic> chart = {
      "caption": "Split of Sales by Product Category",
      "subCaption": "In top 5 stores last month",
      "yAxisname": "Sales (In USD)",
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
              "startvalue": "15000",
              "color": "#0075c2",
              "valueOnRight": "1",
              "displayvalue": "Avg. for{br}Food"
            },
            {
              "startvalue": "22000",
              "color": "#1aaf5d",
              "valueOnRight": "1",
              "displayvalue": "Avg. for{br}Non-food"
            }
          ]
        }
      ]
    };

    _fusionChart2d = FusionCharts(
        dataSource: dataSource,
        type: "marimekko",
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
          title: const Text('Fusion Charts -Marimekko'),
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
                  Text('Marimekko'),
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
