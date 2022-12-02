import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_fusioncharts/flutter_fusioncharts.dart';
import '../../constants.dart';

class India extends StatefulWidget {
  const India({super.key});

  @override
  State<India> createState() => _IndiaState();
}

class _IndiaState extends State<India> {
  late FusionCharts _fusionChart;

  FusionChartsController fusionChartsController = FusionChartsController();

  @override
  void initState() {
    super.initState();
    WidgetsFlutterBinding.ensureInitialized();

    Map<String, dynamic> chart = {
      "caption": "Annual Sales by State",
      "subcaption": "Last year",
      "entityFillHoverColor": "#cccccc",
      "numberScaleValue": "1,1000,1000",
      "numberScaleUnit": "K,M,B",
      "numberPrefix": "\$",
      "showLabels": "1",
      "theme": "carbon",
      "baseFontSize": "30px",
      "captionFontSize": "30px",
    };
    Map<String, dynamic> colorrange = {
      "minvalue": "0",
      "startlabel": "Low",
      "endlabel": "High",
      "code": "#e44a00",
      "gradient": "1",
      "color": [
        {"maxvalue": "56580", "displayvalue": "Average", "code": "#f8bd19"},
        {"maxvalue": "100000", "code": "#6baa01"}
      ]
    };

    List<dynamic> data = [
      {"id": "HI", "value": "3189"},
      {"id": "DC", "value": "2879"},
      {"id": "MD", "value": "920"},
      {"id": "DE", "value": "4607"},
      {"id": "RI", "value": "4890"},
      {"id": "WA", "value": "34927"},
      {"id": "OR", "value": "65798"},
      {"id": "CA", "value": "61861"},
      {"id": "AK", "value": "58911"},
      {"id": "ID", "value": "42662"},
      {"id": "NV", "value": "78041"},
      {"id": "AZ", "value": "41558"},
      {"id": "MT", "value": "62942"},
      {"id": "WY", "value": "78834"},
      {"id": "UT", "value": "50512"},
      {"id": "CO", "value": "73026"},
      {"id": "NM", "value": "78865"},
      {"id": "ND", "value": "50554"},
      {"id": "SD", "value": "35922"},
      {"id": "NE", "value": "43736"},
      {"id": "KS", "value": "32681"},
      {"id": "OK", "value": "79038"},
      {"id": "TX", "value": "75425"},
      {"id": "MN", "value": "43485"},
      {"id": "IA", "value": "46515"},
      {"id": "MO", "value": "63715"},
      {"id": "AR", "value": "34497"},
      {"id": "LA", "value": "70706"},
      {"id": "WI", "value": "42382"},
      {"id": "IL", "value": "73202"},
      {"id": "KY", "value": "79118"},
      {"id": "TN", "value": "44657"},
      {"id": "MS", "value": "66205"},
      {"id": "AL", "value": "75873"},
      {"id": "GA", "value": "76895"},
      {"id": "MI", "value": "67695"},
      {"id": "IN", "value": "33592"},
      {"id": "OH", "value": "32960"},
      {"id": "PA", "value": "54346"},
      {"id": "NY", "value": "42828"},
      {"id": "VT", "value": "77411"},
      {"id": "NH", "value": "51403"},
      {"id": "ME", "value": "64636"},
      {"id": "MA", "value": "51767"},
      {"id": "CT", "value": "57353"},
      {"id": "NJ", "value": "80788"},
      {"id": "WV", "value": "95890"},
      {"id": "VA", "value": "83140"},
      {"id": "NC", "value": "97344"},
      {"id": "SC", "value": "88234"},
      {"id": "FL", "value": "88234"}
    ];

    Map<String, dynamic> dataSource = {
      "chart": chart,
      "data":data,
      "colorrange": colorrange
    };

    _fusionChart = FusionCharts(
        dataSource: dataSource,
        type: "maps/india",
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
          title: const Text('Fusion Charts - USA Map'),
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
                  Text('USA Map'),
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
