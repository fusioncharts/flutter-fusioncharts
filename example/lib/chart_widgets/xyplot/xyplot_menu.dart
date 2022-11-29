import 'package:flutter/material.dart';
import 'package:flutter_fusioncharts_example/chart_widgets/multiseries/areamultiseries.dart';
import 'package:flutter_fusioncharts_example/chart_widgets/multiseries/barmultiseries.dart';
import 'package:flutter_fusioncharts_example/chart_widgets/multiseries/column.dart';
import 'package:flutter_fusioncharts_example/chart_widgets/multiseries/line.dart';
import 'package:flutter_fusioncharts_example/chart_widgets/multiseries/marimekko.dart';
import 'package:flutter_fusioncharts_example/chart_widgets/multiseries/overlapped_bar.dart';
import 'package:flutter_fusioncharts_example/chart_widgets/multiseries/overlapped_column.dart';
import 'package:flutter_fusioncharts_example/chart_widgets/multiseries/zoomline.dart';
import 'package:flutter_fusioncharts_example/chart_widgets/multiseries/zoomline_dy.dart';
import 'package:flutter_fusioncharts_example/chart_widgets/other/gant_chart.dart';
import 'package:flutter_fusioncharts_example/chart_widgets/other/pyramid_chart.dart';
import 'package:flutter_fusioncharts_example/chart_widgets/other/waterfall_or_cascade.dart';
import 'package:flutter_fusioncharts_example/chart_widgets/singleseries/area.dart';
import 'package:flutter_fusioncharts_example/chart_widgets/singleseries/bar.dart';
import 'package:flutter_fusioncharts_example/chart_widgets/singleseries/column.dart';
import 'package:flutter_fusioncharts_example/chart_widgets/singleseries/doughnut.dart';
import 'package:flutter_fusioncharts_example/chart_widgets/singleseries/line2d.dart';
import 'package:flutter_fusioncharts_example/chart_widgets/singleseries/pareto.dart';
import 'package:flutter_fusioncharts_example/chart_widgets/singleseries/pie.dart';
import 'package:flutter_fusioncharts_example/chart_widgets/xyplot/bubble_chart.dart';
import 'package:flutter_fusioncharts_example/chart_widgets/xyplot/scattered.dart';
import 'package:flutter_fusioncharts_example/chart_widgets/xyplot/zoom_scattered.dart';

import '../drilldown/drill_down.dart';

class XYPlotMenu extends StatefulWidget {
  const XYPlotMenu({Key? key}) : super(key: key);

  @override
  State<XYPlotMenu> createState() => _XYPlotMenuState();
}

class _XYPlotMenuState extends State<XYPlotMenu> {
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
                  child: SizedBox(height: 40,
                    child: InkWell(child: const Text("Scattered", style: TextStyle(fontSize: 16)),
                        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) =>  const Scattered()))),
                  )),
              InkWell(
                child: SizedBox(
                  height: 40,
                  child: InkWell(
                      child: const Text("Zoom Scattered",
                          style: TextStyle(fontSize: 16)),
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const ZoomScattered()));
                      }),
                ),
              ),
              InkWell(
                child: SizedBox(
                  height: 40,
                  child: InkWell(
                      child: const Text("Bubble",
                          style: TextStyle(fontSize: 16)),
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const Bubble()));
                      }),
                ),
              ),
            ],
          ),
        ));
  }
}
