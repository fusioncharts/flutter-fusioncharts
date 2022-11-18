import 'package:flutter/material.dart';
import 'package:flutter_fusioncharts/flutter_fusioncharts.dart';
import '../constants.dart';

class Doughnut2d extends StatefulWidget {
  const Doughnut2d({super.key});

  @override
  State<Doughnut2d> createState() => _Doughnut2dState();
}

class _Doughnut2dState extends State<Doughnut2d> {
  late FusionCharts _fusionChart;
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
      "centerLabel": "# Users: \$value"
    };

    List<dynamic> data = [
      {"label": "Ice Cream Sandwich", "value": "5300"},
      {"label": "Jelly Bean", "value": "5000"},
      {"label": "Kitkat", "value": "10500"},
      {"label": "Lollipop", "value": "18900"},
      {"label": "Marshmallow", "value": "17904"}
    ];

    Map<String, dynamic> dataSource = {"chart": chart, "data": data};

    _fusionChart = FusionCharts(
        dataSource: dataSource,
        type: "doughnut2d",
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
          title: const Text('Fusion Charts - doughnut2d'),
        ),
        body: Center(child: _fusionChart),
      ),
    );
  }
}
