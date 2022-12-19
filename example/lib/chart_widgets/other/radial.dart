import 'package:flutter/material.dart';
import 'package:flutter_fusioncharts/flutter_fusioncharts.dart';
import 'package:flutter_fusioncharts_example/chartdata.dart';
import '../../constants.dart';

class RadialBar extends StatefulWidget {
  const RadialBar({super.key});

  @override
  State<RadialBar> createState() => _RadialBarState();
}

class _RadialBarState extends State<RadialBar> {
  late FusionCharts _fusionChart2D;

  @override
  void initState() {
    super.initState();
    WidgetsFlutterBinding.ensureInitialized();

    Map<String, dynamic> chart = {
      "theme": "fusion",
      "innerradius": "100px",
      "outerradius": "300px",
      "width": "600",
      "height": "400",
      "showlabels": "1",
      "caption": "Radial Bar",
      "subcaption": "RadialBar",
      "showContextLabel": "1",
      "defaultContextLabel": "VERSIONS",
      "plotHighlightEffect": "fadeout",
      "showlegend": "1",
      "interactivelegend": "1",
      "baseFontSize": "30px",
      "captionFontSize": "60px",
      "subCaptionFontSize": "30px",
      "placeValuesInside": "0",
      "legendItemFontSize": "30px",
    };

    List<dynamic> data = [
      {"label": "Ice cream sandwich", "value": "5", "color": "#29c3bf"},
      {"label": "Jellybean", "value": "10", "color": "#5c62b4"},
      {"label": "Kitkat", "value": "28", "color": "#63b68f"},
      {"label": "Lollipop", "value": "51", "color": "#ffc534"},
      {"label": "Marshmallow", "value": "42", "color": "#f2736f"}
    ];

    Map<String, dynamic> dataSource = {"chart": chart, "data": data};

    _fusionChart2D = FusionCharts(
        dataSource: dataSource,
        type: "radialBar",
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
          title: const Text('Fusion Charts - Radial Bar'),
        ),
        body: Column(
          children: [
            SizedBox(
                height: MediaQuery.of(context).size.height * 3 / 4,
                child: _fusionChart2D),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Text('Radial Bar'),
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
