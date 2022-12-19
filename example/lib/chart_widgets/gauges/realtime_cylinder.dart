import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_fusioncharts/flutter_fusioncharts.dart';
import '../../constants.dart';

class RealTimeCylinder extends StatefulWidget {
  const RealTimeCylinder({super.key});

  @override
  State<RealTimeCylinder> createState() => _RealTimeCylinderState();
}

class _RealTimeCylinderState extends State<RealTimeCylinder> {
  late FusionCharts _fusionChart2D;
  FusionChartsController fc = FusionChartsController();

  @override
  void initState() {
    super.initState();
    WidgetsFlutterBinding.ensureInitialized();

    Map<String, dynamic> chart = {
      "caption": "Fuel Meter",
      "subcaption": "Diesel level in generator Bakersfield Central",
      "subcaptionFontBold": "0",
      "lowerLimit": "0",
      "upperLimit": "120",
      "lowerLimitDisplay": "Empty",
      "upperLimitDisplay": "Full",
      "numberSuffix": " ltrs",
      "showhovereffect": "1",
      "theme": "fusion",
      
    };


    Map<String, dynamic> dataSource = {
      "chart": chart,
      "value":"110"
    };

    _fusionChart2D = FusionCharts(
        dataSource: dataSource,
        type: "cylinder",
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
          title: const Text('Fusion Charts - Cylinder'),
        ),
        body: Column(
          children: [
            Expanded(child: _fusionChart2D),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Text('Cylinder'),
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
