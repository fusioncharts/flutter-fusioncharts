import 'package:flutter/material.dart';
import 'package:flutter_fusioncharts_example/chart_widgets/bullet_graph/horizontal_bullet_graph.dart';
import 'package:flutter_fusioncharts_example/chart_widgets/bullet_graph/vertical_bullet_graph.dart';
import 'package:flutter_fusioncharts_example/chart_widgets/spark/spark_column.dart';
import 'package:flutter_fusioncharts_example/chart_widgets/spark/spark_line.dart';
import 'package:flutter_fusioncharts_example/chart_widgets/spark/spark_winloss.dart';


class BulletGraphMenu extends StatefulWidget {
  const BulletGraphMenu({Key? key}) : super(key: key);

  @override
  State<BulletGraphMenu> createState() => _BulletGraphMenuState();
}

class _BulletGraphMenuState extends State<BulletGraphMenu> {
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
                    child: InkWell(child: const Text("Horizontal Bullet Graph", style: TextStyle(fontSize: 16)),
                        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) =>  const HorizontalBulletGraph()))),
                  )),
              InkWell(
                child: SizedBox(
                  height: 40,
                  child: InkWell(
                      child: const Text("Vertical Bullet Graph",
                          style: TextStyle(fontSize: 16)),
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const VerticalBulletGraph()));
                      }),
                ),
              ),
            ],
          ),
        ));
  }
}
