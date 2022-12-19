import 'package:flutter/material.dart';
import 'package:flutter_fusioncharts/flutter_fusioncharts.dart';
import 'package:flutter_fusioncharts_example/chartdata.dart';
import '../../constants.dart';

class WaterfallOrCascade extends StatefulWidget {
  const WaterfallOrCascade({super.key});

  @override
  State<WaterfallOrCascade> createState() => _WaterfallOrCascadeState();
}

class _WaterfallOrCascadeState extends State<WaterfallOrCascade> {
  late FusionCharts _fusionChart2D;

  @override
  void initState() {
    super.initState();
    WidgetsFlutterBinding.ensureInitialized();

    Map<String, dynamic> chart = {
      "caption": "Total Profit Calculation",
      "subcaption": "Last month",
      "yAxisname": "Amount (In USD)",
      "numberprefix": "\$",
      "connectordashed": "1",
      "sumlabel": "Total {br} Profit",
      "positiveColor": "#6baa01",
      "negativeColor": "#e44a00",
      "theme": "candy",
      
    };


    Map<String, dynamic> dataSource = {
      "chart": chart,
      "data": ChartData.chartData2
    };

    _fusionChart2D = FusionCharts(
        dataSource: dataSource,
        type: "waterfall2d",
        width: "100%",
        height: "100%",
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
          title: const Text('Fusion Charts - Waterfall/Cascade',style: TextStyle(
            fontSize: 12
          ),),
        ),
        body: Column(
          children: [
            Expanded(child: _fusionChart2D),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Text('Waterfall/Cascade chart'),
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
