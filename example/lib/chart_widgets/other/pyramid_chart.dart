import 'package:flutter/material.dart';
import 'package:flutter_fusioncharts/flutter_fusioncharts.dart';
import 'package:flutter_fusioncharts_example/chartdata.dart';
import '../../constants.dart';

class PyramidChart extends StatefulWidget {
  const PyramidChart({super.key});

  @override
  State<PyramidChart> createState() => _PyramidChartState();
}

class _PyramidChartState extends State<PyramidChart> {
  late FusionCharts _fusionChart2D;

  @override
  void initState() {
    super.initState();
    WidgetsFlutterBinding.ensureInitialized();

    Map<String, dynamic> chart = {
      "caption": "The Global Wealth Pyramid",
      "captionOnTop": "0",
      "captionPadding": "25",
      "alignCaptionWithCanvas": "1",
      "subcaption": "Credit Suisse 2013",
      "subCaptionFontSize": "12",
      "borderAlpha": "20",
      "is2D": "1",
      "showValues": "1",
      "numberPrefix": "\$",
      "numberSuffix": "M",
      "plotTooltext": "\$label of world population is worth USD \$value tn ",
      "showPercentValues": "1",
      "chartLeftMargin": "40",
      "theme": "fusion",
      "baseFontSize": "30px",
      "captionFontSize": "30px",
    };

    List<dynamic> data = [{"label": "Top 32 mn (0.7%)","value": "98.7"},{"label": "Next 361 mn (7.7%)","value": "101.8"},{"label": "Next 1.1 bn (22.9%)","value": "33"},{"label": "Last 3.2 bn (68.7%)","value": "7.3"}];


    Map<String, dynamic> dataSource = {
      "chart": chart,
      "data": data
    };

    _fusionChart2D = FusionCharts(
        dataSource: dataSource,
        type: "pyramid",
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
            'Fusion Charts - Pyramid'),
        ),
        body: Column(
          children: [
            Expanded(child: _fusionChart2D),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Text('Pyramid Chart'),
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
