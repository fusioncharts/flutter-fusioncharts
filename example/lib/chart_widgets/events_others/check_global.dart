import 'package:flutter/material.dart';
import 'package:flutter_fusioncharts/flutter_fusioncharts.dart';
import 'package:flutter_fusioncharts_example/button.dart';
import 'package:flutter_fusioncharts_example/chartdata.dart';
import '../../constants.dart';

class CheckGlobal extends StatefulWidget {
  const CheckGlobal({super.key});

  @override
  State<CheckGlobal> createState() => _CheckGlobalState();
}

class _CheckGlobalState extends State<CheckGlobal> {
  late FusionCharts _fusionChart2D;
  late FusionCharts _fusionChart2D1;
  bool threeD = true;
  String js =
      'globalFusionCharts.chartType() == "doughnut3d" ? globalFusionCharts.chartType("doughnut2d") : globalFusionCharts.chartType("doughnut3d")';
  FusionChartsController fc = FusionChartsController();
  FusionChartsController fc2 = FusionChartsController();

  @override
  void initState() {
    super.initState();
    WidgetsFlutterBinding.ensureInitialized();

    Map<String, dynamic> chart = {
      "caption": "Android Distribution",
      "subCaption": "subCaption",
      "showlegend": "1",
      "showpercentvalues": "1",
      "legendPosition": "right",
      "plothovereffect": "1",
      "defaultcenterlabel": "Android Deristibution",
      "aligncaptionwithcanvas": "0",
      "captionpadding": "0",
      "decimals": "1",
      "plottooltext":
          "<b>\$percentValue</b> of our Android users are on <b>\$label</b>",
      "theme": "fusion",
      "centerLabel": "# Users: \$value",
      
    };

    Map<String, dynamic> dataSource = {
      "chart": chart,
      "data": ChartData.chartData2
    };

    _fusionChart2D = FusionCharts(
        dataSource: dataSource,
        type: "doughnut3d",
        width: "100%",
        height: "100%",
        fusionChartsController: fc,
        fusionChartEvent: (eventType, eventDetail) =>
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content:
                    Text("Event Raised: $eventType + Details: $eventDetail"))),
        licenseKey: licenseKey);

    _fusionChart2D1 = FusionCharts(
        dataSource: dataSource,
        type: "doughnut2d",
        width: "100%",
        height: "100%",
        fusionChartsController: fc2,
        fusionChartEvent: (eventType, eventDetail) =>
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content:
                    Text("Event Raised: $eventType + Details: $eventDetail"))),
        licenseKey: licenseKey);
  }

  void callBackFromPlugin(arg1, arg2) {
    print('Back to consumer: $arg1 , $arg2');
  }

  addEvents() {
    fc.addEvents(result);
  }

  removeEvents() {
    fc.removeEvents(result);
  }

  executeScript(String js) {
    print(js);
    fc.executeScript(js.toString());
  }

  final TextEditingController _controller = TextEditingController();
  List<String> result = [];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          leading: IconButton(
              onPressed: () => Navigator.of(context).pop(),
              icon: const Icon(Icons.arrow_back)),
          title: const Text('Fusion Charts - Doughnut'),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                    width: MediaQuery.of(context).size.width / 2,
                    height: MediaQuery.of(context).size.height / 2,
                    child: _fusionChart2D),
                Container(
                    width: MediaQuery.of(context).size.width / 2,
                    height: MediaQuery.of(context).size.height / 2,
                    child: _fusionChart2D1),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(
                onPressed: () {
                  fc.executeScript(js);
                  fc2.executeScript(js);
                },
                child: const Text('Change Type'))
          ],
        ),
      ),
    );
  }
}
