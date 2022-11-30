import 'package:flutter/material.dart';
import 'package:flutter_fusioncharts_example/chart_widgets/gauges/horizontal_led.dart';
import 'package:flutter_fusioncharts_example/chart_widgets/gauges/realtime_angular.dart';
import 'package:flutter_fusioncharts_example/chart_widgets/gauges/realtime_cylinder.dart';
import 'package:flutter_fusioncharts_example/chart_widgets/gauges/thermometer.dart';
import 'package:flutter_fusioncharts_example/chart_widgets/scroll/scroll_area.dart';
import 'package:flutter_fusioncharts_example/chart_widgets/scroll/scroll_bar.dart';
import 'package:flutter_fusioncharts_example/chart_widgets/scroll/scroll_column.dart';
import 'package:flutter_fusioncharts_example/chart_widgets/scroll/scroll_combination.dart';
import 'package:flutter_fusioncharts_example/chart_widgets/scroll/scroll_line.dart';
import 'package:flutter_fusioncharts_example/chart_widgets/scroll/scroll_multiseries.dart';
import 'package:flutter_fusioncharts_example/chart_widgets/scroll/scroll_stackedcolumn.dart';


class GaugesMenu extends StatefulWidget {
  const GaugesMenu({Key? key}) : super(key: key);

  @override
  State<GaugesMenu> createState() => _GaugesMenuState();
}

class _GaugesMenuState extends State<GaugesMenu> {
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
                    child: InkWell(child: const Text("Real Time Angular", style: TextStyle(fontSize: 16)),
                        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) =>  const RealTimeAngular()))),
                  )),
              InkWell(
                child: SizedBox(
                  height: 40,
                  child: InkWell(
                      child: const Text("Real Time Cylinder",
                          style: TextStyle(fontSize: 16)),
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const RealTimeCylinder()));
                      }),
                ),
              ),
              InkWell(
                child: SizedBox(
                  height: 40,
                  child: InkWell(
                      child: const Text("Horizontal LED",
                          style: TextStyle(fontSize: 16)),
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const HorizontalLED()));
                      },
                  ),
                ),
              ),
              InkWell(
                child: SizedBox(
                  height: 40,
                  child: InkWell(
                      child: const Text("Thermometer",
                          style: TextStyle(fontSize: 16)),
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const Thermometer()));
                      }),
                ),
              ),
            ],
          ),
        ));
  }
}
