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
import 'package:flutter_fusioncharts_example/chart_widgets/other/sparkline.dart';
import 'package:flutter_fusioncharts_example/chart_widgets/other/waterfall_or_cascade.dart';
import 'package:flutter_fusioncharts_example/chart_widgets/singleseries/area.dart';
import 'package:flutter_fusioncharts_example/chart_widgets/singleseries/bar.dart';
import 'package:flutter_fusioncharts_example/chart_widgets/singleseries/column.dart';
import 'package:flutter_fusioncharts_example/chart_widgets/singleseries/doughnut.dart';
import 'package:flutter_fusioncharts_example/chart_widgets/singleseries/line2d.dart';
import 'package:flutter_fusioncharts_example/chart_widgets/singleseries/pareto.dart';
import 'package:flutter_fusioncharts_example/chart_widgets/singleseries/pie.dart';

import '../drilldown/drill_down.dart';

class OtherChartMenu extends StatefulWidget {
  const OtherChartMenu({Key? key}) : super(key: key);

  @override
  State<OtherChartMenu> createState() => _OtherChartMenuState();
}

class _OtherChartMenuState extends State<OtherChartMenu> {
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
                    child: InkWell(child: const Text("Gant Chart", style: TextStyle(fontSize: 16)),
                        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) =>  const GantChart()))),
                  )),
              InkWell(
                child: SizedBox(
                  height: 40,
                  child: InkWell(
                      child: const Text("Waterfall/Cascade",
                          style: TextStyle(fontSize: 16)),
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const WaterfallOrCascade()));
                      }),
                ),
              ),
              InkWell(
                child: SizedBox(
                  height: 40,
                  child: InkWell(
                      child: const Text("Pyramid Chart",
                          style: TextStyle(fontSize: 16)),
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const PyramidChart()));
                      }),
                ),
              ),
              InkWell(
                child: SizedBox(
                  height: 40,
                  child: InkWell(
                      child: const Text("Sparkiline",
                          style: TextStyle(fontSize: 16)),
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const Sparkline()));
                      }),
                ),
              ),
            ],
          ),
        ));
  }
}
