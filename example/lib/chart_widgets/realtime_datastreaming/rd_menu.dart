import 'package:flutter/material.dart';
import 'package:flutter_fusioncharts_example/chart_widgets/gauges/horizontal_led.dart';
import 'package:flutter_fusioncharts_example/chart_widgets/gauges/realtime_angular.dart';
import 'package:flutter_fusioncharts_example/chart_widgets/gauges/realtime_cylinder.dart';
import 'package:flutter_fusioncharts_example/chart_widgets/gauges/thermometer.dart';
import 'package:flutter_fusioncharts_example/chart_widgets/realtime_datastreaming/realtime_area.dart';
import 'package:flutter_fusioncharts_example/chart_widgets/realtime_datastreaming/realtime_line.dart';


class RDSMenu extends StatefulWidget {
  const RDSMenu({Key? key}) : super(key: key);

  @override
  State<RDSMenu> createState() => _RDSMenuState();
}

class _RDSMenuState extends State<RDSMenu> {
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
                    child: InkWell(child: const Text("Real Time Area", style: TextStyle(fontSize: 16)),
                        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) =>  const RealTimeArea()))),
                  )),
              InkWell(
                child: SizedBox(
                  height: 40,
                  child: InkWell(
                      child: const Text("Real Time Line",
                          style: TextStyle(fontSize: 16)),
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const RealTimeLine()));
                      }),
                ),
              ),
            ],
          ),
        ));
  }
}
