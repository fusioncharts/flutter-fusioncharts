import 'package:flutter/material.dart';
import 'package:flutter_fusioncharts_example/chart_widgets/scroll/scroll_area.dart';
import 'package:flutter_fusioncharts_example/chart_widgets/scroll/scroll_bar.dart';
import 'package:flutter_fusioncharts_example/chart_widgets/scroll/scroll_column.dart';
import 'package:flutter_fusioncharts_example/chart_widgets/scroll/scroll_combination.dart';
import 'package:flutter_fusioncharts_example/chart_widgets/scroll/scroll_line.dart';
import 'package:flutter_fusioncharts_example/chart_widgets/scroll/scroll_multiseries.dart';
import 'package:flutter_fusioncharts_example/chart_widgets/scroll/scroll_stackedcolumn.dart';
import 'package:flutter_fusioncharts_example/chart_widgets/spark/spark_column.dart';
import 'package:flutter_fusioncharts_example/chart_widgets/spark/spark_line.dart';
import 'package:flutter_fusioncharts_example/chart_widgets/spark/spark_winloss.dart';


class SparkMenu extends StatefulWidget {
  const SparkMenu({Key? key}) : super(key: key);

  @override
  State<SparkMenu> createState() => _SparkMenuState();
}

class _SparkMenuState extends State<SparkMenu> {
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
                    child: InkWell(child: const Text("Spark Line", style: TextStyle(fontSize: 16)),
                        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) =>  const SparkLine()))),
                  )),
              InkWell(
                child: SizedBox(
                  height: 40,
                  child: InkWell(
                      child: const Text("Spark Win/Loss",
                          style: TextStyle(fontSize: 16)),
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const SparkWinLoss()));
                      }),
                ),
              ),
              InkWell(
                child: SizedBox(
                  height: 40,
                  child: InkWell(
                      child: const Text("Spark Column",
                          style: TextStyle(fontSize: 16)),
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const SparkColumn()));
                      }),
                ),
              ),
            ],
          ),
        ));
  }
}
