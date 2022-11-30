import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_fusioncharts/flutter_fusioncharts.dart';
import '../../constants.dart';

class HorizontalLED extends StatefulWidget {
  const HorizontalLED({super.key});

  @override
  State<HorizontalLED> createState() => _HorizontalLEDState();
}

class _HorizontalLEDState extends State<HorizontalLED> {
  late FusionCharts _fusionChart2D;
  FusionChartsController fc = FusionChartsController();

  @override
  void initState() {
    super.initState();
    WidgetsFlutterBinding.ensureInitialized();

    Map<String, dynamic> chart = {
      "caption": "Customer satisfaction score",
      "subcaption": "Current week - Bakersfield Central",
      "lowerLimit": "0",
      "upperLimit": "100",
      "lowerLimitDisplay": "Bad",
      "upperLimitDisplay": "Good",
      "numberSuffix": "%",
      "tickMarkDistance": "5",
      "theme": "candy",
      "baseFontSize": "30px",
      "captionFontSize": "30px",
    };
    Map<String, dynamic> colorrange = {
      "color": [
        {"minValue": "0", "maxValue": "45", "code": "#8e0000"},
        {"minValue": "45", "maxValue": "75", "code": "#f2c500"},
        {"minValue": "75", "maxValue": "100", "code": "#1aaf5d"}
      ]
    };

    Map<String, dynamic> dataSource = {
      "chart": chart,
      "colorRange":colorrange,
      "value": "92"
    };

    _fusionChart2D = FusionCharts(
        dataSource: dataSource,
        type: "hled",
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
          title: const Text('Fusion Charts - LED'),
        ),
        body: Column(
          children: [
            Expanded(child: _fusionChart2D),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Text('LED'),
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
