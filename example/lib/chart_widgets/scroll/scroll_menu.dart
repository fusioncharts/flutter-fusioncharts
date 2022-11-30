import 'package:flutter/material.dart';
import 'package:flutter_fusioncharts_example/chart_widgets/scroll/scroll_area.dart';
import 'package:flutter_fusioncharts_example/chart_widgets/scroll/scroll_bar.dart';
import 'package:flutter_fusioncharts_example/chart_widgets/scroll/scroll_column.dart';
import 'package:flutter_fusioncharts_example/chart_widgets/scroll/scroll_combination.dart';
import 'package:flutter_fusioncharts_example/chart_widgets/scroll/scroll_line.dart';
import 'package:flutter_fusioncharts_example/chart_widgets/scroll/scroll_multiseries.dart';
import 'package:flutter_fusioncharts_example/chart_widgets/scroll/scroll_stackedcolumn.dart';


class ScrollMenu extends StatefulWidget {
  const ScrollMenu({Key? key}) : super(key: key);

  @override
  State<ScrollMenu> createState() => _ScrollMenuState();
}

class _ScrollMenuState extends State<ScrollMenu> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: const Text('Choose Example')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children:[
              InkWell(
                  child: SizedBox(height: 40,
                    child: InkWell(child: const Text("Scroll Column ", style: TextStyle(fontSize: 16)),
                        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) =>  const ScrollColumn2D()))),
                  )),
              InkWell(
                child: SizedBox(
                  height: 40,
                  child: InkWell(
                      child: const Text("Scroll Bar ",
                          style: TextStyle(fontSize: 16)),
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const ScrollBar2D()));
                      }),
                ),
              ),
              InkWell(
                child: SizedBox(
                  height: 40,
                  child: InkWell(
                      child: const Text("Scroll Line ",
                          style: TextStyle(fontSize: 16)),
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const ScrollLine2D()));
                      }),
                ),
              ),
              InkWell(
                child: SizedBox(
                  height: 40,
                  child: InkWell(
                      child: const Text("Scroll Area ",
                          style: TextStyle(fontSize: 16)),
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const ScrollArea2D()));
                      }),
                ),
              ),
              InkWell(
                child: SizedBox(
                  height: 40,
                  child: InkWell(
                      child: const Text("Scroll Stacked Column",
                          style: TextStyle(fontSize: 16)),
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const ScrollStackedColumn2D()));
                      }),
                ),
              ),
              InkWell(
                child: SizedBox(
                  height: 40,
                  child: InkWell(
                      child: const Text("Scroll Combination",
                          style: TextStyle(fontSize: 16)),
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const ScrollCombination()));
                      }),
                ),
              ),
              InkWell(
                child: SizedBox(
                  height: 40,
                  child: InkWell(
                      child: const Text("Scroll Multiseries",
                          style: TextStyle(fontSize: 16)),
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const ScrollMultiseries()));
                      }),
                ),
              ),
            ],
          ),
        ));
  }
}
