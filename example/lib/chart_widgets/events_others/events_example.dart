import 'package:flutter/material.dart';
import 'package:flutter_fusioncharts/flutter_fusioncharts.dart';
import 'package:flutter_fusioncharts_example/chartdata.dart';
import '../../constants.dart';

class AreaEvents extends StatefulWidget {
  const AreaEvents({super.key});

  @override
  State<AreaEvents> createState() => _AreaEventsState();
}

class _AreaEventsState extends State<AreaEvents> {
  late FusionCharts _fusionChart2D;
  FusionChartsController fc = FusionChartsController();
  // late FusionCharts _fusionChart3D;

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
        type: "area2d",
        width: "100%",
        height: "100%",
        licenseKey: licenseKey,
        fusionChartEvent: (eventType, eventDetail) =>
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content:
                    Text("Event Raised: $eventType + Details: $eventDetail"))),
        fusionChartsController: fc);
  }

  addEvents() {
    fc.addEvents(['dataLabelRollOver']);
  }

  removeEvents() {
    fc.removeEvents(['dataLabelRollOver']);
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
          title: const Text('Fusion Charts - AreaEvents 2D'),
        ),
        body: Column(
          children: [
            Container(
              child: _fusionChart2D,
              height: 400,
              width: 400,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('AreaEvents 2D'),
                SizedBox(width: 30),
                InkWell(child: Text('Add Events'), onTap: addEvents),
                SizedBox(width: 30),
                InkWell(child: Text('Remove Events'), onTap: removeEvents),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
