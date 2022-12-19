import 'package:flutter/material.dart';
import 'package:flutter_fusioncharts/flutter_fusioncharts.dart';
import '../../constants.dart';

class KagiChart extends StatefulWidget {
  const KagiChart({super.key});

  @override
  State<KagiChart> createState() => _KagiChartState();
}

class _KagiChartState extends State<KagiChart> {
  late FusionCharts _fusionChart2D;

  @override
  void initState() {
    super.initState();
    WidgetsFlutterBinding.ensureInitialized();

    Map<String, dynamic> chart = {
      "caption": "Stock Price HRYS",
      "subCaption": "Last 2 months",
      "numberPrefix": "\$",
      "xAxisName": "Day",
      "yAxisName": "Amount (In USD)",
      "reversalPercentage": "5",
      "rallythickness": "3",
      "declinethickness": "3",
      "theme": "ocean",
      
    };

    List<dynamic> data = [
      {"label": "Day 36", "value": "19.77"},
      {"label": "Day 35", "value": "19.88"},
      {"label": "Day 34", "value": "19.63"},
      {"label": "Day 33", "value": "20.65"},
      {"label": "Day 32", "value": "21.33"},
      {"label": "Day 31", "value": "20.56"},
      {"label": "Day 30", "value": "20.36"},
      {"label": "Day 29", "value": "20.03"},
      {"label": "Day 28", "value": "19.88"},
      {"label": "Day 27", "value": "19.9"},
      {"label": "Day 26", "value": "19.5"},
      {"label": "Day 25", "value": "19.43"},
      {"label": "Day 24", "value": "19.41"},
      {"label": "Day 23", "value": "19.83"},
      {"label": "Day 22", "value": "21"},
      {"label": "Day 21", "value": "20.44"},
      {"label": "Day 20", "value": "20.3"},
      {"label": "Day 19", "value": "21.63"},
      {"label": "Day 18", "value": "23.28"},
      {"label": "Day 17", "value": "23.94"},
      {"label": "Day 16", "value": "23.48"},
      {"label": "Day 15", "value": "22.74"},
      {"label": "Day 14", "value": "22.24"},
      {"label": "Day 13", "value": "22.42"},
      {"label": "Day 12", "value": "22.68"},
      {"label": "Day 11", "value": "23.46"},
      {"label": "Day 10", "value": "23.6"},
      {"label": "Day 9", "value": "24.15"},
      {"label": "Day 8", "value": "24.1"},
      {"label": "Day 7", "value": "23.47"},
      {"label": "Day 6", "value": "23.76"},
      {"label": "Day 55", "value": "23.66"},
      {"label": "Day 5", "value": "23.79"},
      {"label": "Day 4", "value": "23.39"},
      {"label": "Day 3", "value": "23.88"},
      {"label": "Day 2", "value": "23.01"},
      {"label": "Yesterday", "value": "23.32"}
    ];

    Map<String, dynamic> dataSource = {"chart": chart, "data": data};

    _fusionChart2D = FusionCharts(
        dataSource: dataSource,
        type: "kagi",
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
          title: const Text('Fusion Charts - Kagi'),
        ),
        body: Column(
          children: [
            Expanded(child: _fusionChart2D),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Text('Kagi Chart'),
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
