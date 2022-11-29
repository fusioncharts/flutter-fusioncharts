import 'package:flutter/material.dart';
import 'package:flutter_fusioncharts/flutter_fusioncharts.dart';
import 'package:flutter_fusioncharts_example/button.dart';
import 'package:flutter_fusioncharts_example/chartdata.dart';
import '../../constants.dart';

class DoughnutEvent extends StatefulWidget {
  const DoughnutEvent({super.key});

  @override
  State<DoughnutEvent> createState() => _DoughnutEventState();
}

class _DoughnutEventState extends State<DoughnutEvent> {
  late FusionCharts _fusionChart2D;
  FusionChartsController fc = FusionChartsController();

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
      "baseFontSize": "30px",
      "captionFontSize": "30px",
    };

    Map<String, dynamic> dataSource = {
      "chart": chart,
      "data": ChartData.chartData2
    };



    _fusionChart2D = FusionCharts(
        dataSource: dataSource,
        type: "doughnut2d",
        width: "100%",
        height: "100%",
        fusionChartsController: fc,
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
  executeScript(String js){
    fc.executeScript(js);
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
          children: [
            Expanded(child: _fusionChart2D),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Text('Doughnut2D'),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: ListView(
                  children: [
                    TextFormField(
                      controller: _controller,
                      maxLines: 3,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Enter comma separated string for add/remove events and simple string for script',
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    PrimaryButton(onPressed: (){
                      result = _controller.text.split(',');
                      addEvents();
                      _controller.clear();
                    }, title: 'add event'),
                    const SizedBox(
                      height: 10,
                    ),
                    PrimaryButton(onPressed: (){
                      result = _controller.text.split(',');
                      removeEvents();
                      _controller.clear();
                    }, title: 'remove event'),
                    const SizedBox(
                      height: 10,
                    ),
                    PrimaryButton(onPressed: (){
                      executeScript(_controller.text);
                      _controller.clear();
                    }, title: 'Execute Script')
                  ],
                ),
              ),
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
