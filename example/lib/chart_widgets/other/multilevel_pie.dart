import 'package:flutter/material.dart';
import 'package:flutter_fusioncharts/flutter_fusioncharts.dart';
import '../../constants.dart';

class MultilevelPie extends StatefulWidget {
  const MultilevelPie({super.key});

  @override
  State<MultilevelPie> createState() => _MultilevelPieState();
}

class _MultilevelPieState extends State<MultilevelPie> {
  late FusionCharts _fusionChart2D;

  @override
  void initState() {
    super.initState();
    WidgetsFlutterBinding.ensureInitialized();

    Map<String, dynamic> chart = {
      "caption": "Split of Top Products Sold",
      "subCaption": "Last Quarter",
      "basefontsize": "9",
      "pieFillAlpha": "60",
      "pieBorderThickness": "2",
      "hoverFillColor": "#cccccc",
      "pieBorderColor": "#ffffff",
      "showPercentInTooltip": "0",
      "numberPrefix": "\$",
      "plotTooltext": "\$label, \$\$valueK, \$percentValue",
      "theme": "umber",
      
    };

    List<dynamic> category = [
      {
        "label": "Sales by category",
        "color": "#ffffff",
        "value": "150",
        "category": [
          {
            "label": "Food & {br}Beverages",
            "color": "#f8bd19",
            "value": "55.5",
            "category": [
              {"label": "Breads", "color": "#f8bd19", "value": "11.1"},
              {"label": "Juice", "color": "#f8bd19", "value": "27.75"},
              {"label": "Noodles", "color": "#f8bd19", "value": "9.99"},
              {"label": "Seafood", "color": "#f8bd19", "value": "6.66"}
            ]
          },
          {
            "label": "Apparel &{br}Accessories",
            "color": "#e44a00",
            "value": "42",
            "category": [
              {"label": "Sun Glasses", "color": "#e44a00", "value": "10.08"},
              {"label": "Clothing", "color": "#e44a00", "value": "18.9"},
              {"label": "Handbags", "color": "#e44a00", "value": "6.3"},
              {"label": "Shoes", "color": "#e44a00", "value": "6.72"}
            ]
          },
          {
            "label": "Baby {br}Products",
            "color": "#008ee4",
            "value": "22.5",
            "category": [
              {
                "label": "Bath &{br}Grooming",
                "color": "#008ee4",
                "value": "9.45"
              },
              {"label": "Feeding", "color": "#008ee4", "value": "6.3"},
              {"label": "Diapers", "color": "#008ee4", "value": "6.75"}
            ]
          },
          {
            "label": "Electronics",
            "color": "#33bdda",
            "value": "30",
            "category": [
              {"label": "Laptops", "color": "#33bdda", "value": "8.1"},
              {"label": "Televisions", "color": "#33bdda", "value": "10.5"},
              {"label": "SmartPhones", "color": "#33bdda", "value": "11.4"}
            ]
          }
        ]
      }
    ];

    Map<String, dynamic> dataSource = {"chart": chart, "category": category};

    _fusionChart2D = FusionCharts(
        dataSource: dataSource,
        type: "multilevelpie",
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
          title: const Text('Fusion Charts - Multilevel Pie'),
        ),
        body: Column(
          children: [
            Expanded(child: _fusionChart2D),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Text('Multilevel Pie Chart'),
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
