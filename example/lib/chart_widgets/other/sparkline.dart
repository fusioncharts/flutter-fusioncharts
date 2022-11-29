import 'package:flutter/material.dart';
import 'package:flutter_fusioncharts/flutter_fusioncharts.dart';
import 'package:flutter_fusioncharts_example/chartdata.dart';
import '../../constants.dart';

class Sparkline extends StatefulWidget {
  const Sparkline({super.key});

  @override
  State<Sparkline> createState() => _SparklineState();
}

class _SparklineState extends State<Sparkline> {
  late FusionCharts _fusionChart2D;

  @override
  void initState() {
    super.initState();
    WidgetsFlutterBinding.ensureInitialized();

    Map<String, dynamic> chart = {
      "animation": "0",
      "hideTitle": "1",
      "plotToolText": "<div><b>\$label</b><br/> <b>Sale: </b>\$\$value<br/><b>Growth: </b>\$svalue%</div>",
      "horizontalPadding": "1",
      "verticalPadding": "1",
      "plotborderthickness": ".5",
      "plotbordercolor": "666666",
      "legendpadding": "0",
      "legendItemFontSize": "10",
      "legendItemFontBold": "1",
      "showLegend": "1",
      "legenditemfontcolor": "3d5c5c",
      "algorithm": "squarified",
      "caption": "Harry's SuperMart: Sales Team Performance Analysis",
      "legendScaleLineThickness": "0",
      "legendCaptionFontSize": "10",
      "subcaption": "Year Till Date",
      "legendCaption": "Growth in sales - Compared to previous year",
      "theme": "zune",
      "baseFontSize": "30px",
      "captionFontSize": "30px",
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
          title: const Text(
            'Fusion Charts - Waterfall/Cascade', style: TextStyle(
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
