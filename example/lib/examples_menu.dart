import 'package:flutter/material.dart';
import 'package:flutter_fusioncharts_example/chart_widgets/multiseries/multiseries_menu.dart';
import 'package:flutter_fusioncharts_example/chart_widgets/singleseries/line2d.dart';
import 'package:flutter_fusioncharts_example/chart_widgets/singleseries/singleseries_menu.dart';
import 'package:flutter_fusioncharts_example/chart_widgets/stacked/stacked_menu.dart';

import 'chart_widgets/singleseries/column.dart';
import 'chart_widgets/singleseries/doughnut.dart';
import 'chart_widgets/multiseries/multiseries.dart';

class Menu extends StatefulWidget {
  const Menu({super.key});

  @override
  State<Menu> createState() => _MenuState();
}

class _MenuState extends State<Menu> {
  List<Widget> exampleList = [];
  List<String> examples = [
    'column2d',
    'doughnut2d',
    'mscolumn2d',
    'maps/world',
    'heatmap'
  ];

  @override
  void initState() {
    super.initState();
   
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
         title: Text('Choose Chart Type')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children:[
             InkWell(
            child: Container(height: 40,
            child: InkWell(child: const Text("Single Series", style: TextStyle(fontSize: 16)),
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) =>const  SingleSeriesMenu()))),
        ),),
             InkWell(
            child: Container(height: 40,
            child: InkWell(child: const Text("Multi Series", style: TextStyle(fontSize: 16)),
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) =>const  MultiSeriesMenu()))),
        ),),
           InkWell(
                  child: Container(
                height: 40,
                child: InkWell(
                    child:
                        const Text("Stacked", style: TextStyle(fontSize: 16)),
                    onTap: () {
                      Navigator.push(context,
                        MaterialPageRoute(builder: (context) => const StackedMenu()));
                    }),
              ),)
           ,InkWell(
                  child: SizedBox(
                height: 40,
                child: InkWell(
                    child:
                        const Text("Combination", style: TextStyle(fontSize: 16)),
                    onTap: () {
                      // Navigator.push(context,
                      //     MaterialPageRoute(builder: (context) => const MultiSeries()));
                    }),
              ),),
        ],
      ),
    ));
  }
}
