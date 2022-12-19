import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_fusioncharts/flutter_fusioncharts.dart';
import '../../constants.dart';

class HorizontalBulletGraph extends StatefulWidget {
  const HorizontalBulletGraph({super.key});

  @override
  State<HorizontalBulletGraph> createState() => _HorizontalBulletGraphState();
}

class _HorizontalBulletGraphState extends State<HorizontalBulletGraph> {
  late FusionCharts _fusionChart2D;
  FusionChartsController fc = FusionChartsController();

  @override
  void initState() {
    super.initState();
    WidgetsFlutterBinding.ensureInitialized();

    Map<String, dynamic> chart = {
      "lowerLimit": "0",
      "upperLimit": "100",
      "caption": "Monthly Revenue",
      "subcaption": "Actual vs Target<br>Bakersfield Central",
      "numberPrefix": "\$",
      "numberSuffix": "K",
      "targetColor": "#8e0000",
      "showHoverEffect": "1",
      "colorRangeFillMix": "{light+0}",
      "valuePadding": "7",
      "theme": "fusion",
      
    };
    Map<String, dynamic> colorrange = {
      "color": [
        {"minValue": "0", "maxValue": "50", "code": "#e44a00", "alpha": "70"},
        {"minValue": "50", "maxValue": "75", "code": "#f2c500", "alpha": "70"},
        {"minValue": "75", "maxValue": "120", "code": "#1aaf5d", "alpha": "70"}
      ]
    };

    List<dynamic> dataset = [
      {
        "data": [
          {"value": "783000"},
          {"value": "601000"},
          {"value": "515000"},
          {"value": "315900"},
          {"value": "388000"},
          {"value": "433000"},
          {"value": "910000"},
          {"value": "798000"},
          {"value": "483300"},
          {"value": "562000"},
          {"value": "359400"},
          {"value": "485000"}
        ]
      }
    ];
    Map<String, dynamic> dataSource = {
      "chart": chart,
      "colorRange": colorrange,
      "value":"82",
      "target":"90"
    };

    _fusionChart2D = FusionCharts(
        dataSource: dataSource,
        type: "hbullet",
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
          title: const Text('Fusion Charts - Horizontal Bullet'),
        ),
        body: Column(
          children: [
            Expanded(child: _fusionChart2D),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Text('Horizontal Bullet'),
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
