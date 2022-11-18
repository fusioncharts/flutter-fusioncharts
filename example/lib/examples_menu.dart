import 'package:flutter/material.dart';

import '/chart_widgets/column2d.dart';
import '/chart_widgets/doughnut2d.dart';
import '/chart_widgets/multiseries.dart';

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
         title: Text('Choose Example')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children:[
             InkWell(
            child: Container(height: 40,
            child: InkWell(child: const Text("Column2d", style: TextStyle(fontSize: 16)),
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) =>const  Column2D()))),
        )),
           InkWell(
                  child: Container(
                height: 40,
                child: InkWell(
                    child:
                        const Text("Doughnut2d", style: TextStyle(fontSize: 16)),
                    onTap: () => Navigator.push(context,
                        MaterialPageRoute(builder: (context) => const Doughnut2d()))),
              ))
           ,InkWell(
                  child: Container(
                height: 40,
                child: InkWell(
                    child:
                        const Text("Multiseries Chart", style: TextStyle(fontSize: 16)),
                    onTap: () => Navigator.push(context,
                        MaterialPageRoute(builder: (context) => const MultiSeries()))),
              ))
       

        ],
      ),
    ));
  }
}
