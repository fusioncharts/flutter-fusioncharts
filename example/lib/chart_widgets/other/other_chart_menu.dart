import 'package:flutter/material.dart';
import 'package:flutter_fusioncharts_example/chart_widgets/other/dragnode.dart';
import 'package:flutter_fusioncharts_example/chart_widgets/other/gantt_chart.dart';
import 'package:flutter_fusioncharts_example/chart_widgets/other/heatmap.dart';
import 'package:flutter_fusioncharts_example/chart_widgets/other/kagi.dart';
import 'package:flutter_fusioncharts_example/chart_widgets/other/multilevel_pie.dart';
import 'package:flutter_fusioncharts_example/chart_widgets/other/pyramid_chart.dart';
import 'package:flutter_fusioncharts_example/chart_widgets/other/radar.dart';
import 'package:flutter_fusioncharts_example/chart_widgets/other/radial.dart';
import 'package:flutter_fusioncharts_example/chart_widgets/other/sparkline.dart';
import 'package:flutter_fusioncharts_example/chart_widgets/other/stepline.dart';
import 'package:flutter_fusioncharts_example/chart_widgets/other/timeseries.dart';
import 'package:flutter_fusioncharts_example/chart_widgets/other/treemap.dart';
import 'package:flutter_fusioncharts_example/chart_widgets/other/waterfall_or_cascade.dart';

class OtherChartMenu extends StatefulWidget {
  const OtherChartMenu({Key? key}) : super(key: key);

  @override
  State<OtherChartMenu> createState() => _OtherChartMenuState();
}

class _OtherChartMenuState extends State<OtherChartMenu> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text('Choose Example')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              InkWell(
                  child: SizedBox(
                height: 40,
                child: InkWell(
                    child: const Text("Gant Chart",
                        style: TextStyle(fontSize: 16)),
                    onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const GanttChart()))),
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
                                builder: (context) =>
                                    const WaterfallOrCascade()));
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
                      child: const Text("Sparkline",
                          style: TextStyle(fontSize: 16)),
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const Sparkline()));
                      }),
                ),
              ),
              InkWell(
                child: SizedBox(
                  height: 40,
                  child: InkWell(
                      child: const Text("Kagi", style: TextStyle(fontSize: 16)),
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const KagiChart()));
                      }),
                ),
              ),
              InkWell(
                child: SizedBox(
                  height: 40,
                  child: InkWell(
                      child: const Text("Multilevel Pie",
                          style: TextStyle(fontSize: 16)),
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const MultilevelPie()));
                      }),
                ),
              ),
              InkWell(
                child: SizedBox(
                  height: 40,
                  child: InkWell(
                      child: const Text("Step Line",
                          style: TextStyle(fontSize: 16)),
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const StepLine()));
                      }),
                ),
              ),
              InkWell(
                child: SizedBox(
                  height: 40,
                  child: InkWell(
                      child: const Text("Drag Node",
                          style: TextStyle(fontSize: 16)),
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const DragNode()));
                      }),
                ),
              ),
              InkWell(
                child: SizedBox(
                  height: 40,
                  child: InkWell(
                      child: const Text("Heat Map",
                          style: TextStyle(fontSize: 16)),
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const HeatMap()));
                      }),
                ),
              ),
              InkWell(
                child: SizedBox(
                  height: 40,
                  child: InkWell(
                      child:
                          const Text("Radar", style: TextStyle(fontSize: 16)),
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const Radar()));
                      }),
                ),
              ),
              InkWell(
                child: SizedBox(
                  height: 40,
                  child: InkWell(
                      child:
                          const Text("TreeMap", style: TextStyle(fontSize: 16)),
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const TreeMap()));
                      }),
                ),
              ),
              InkWell(
                child: SizedBox(
                  height: 40,
                  child: InkWell(
                      child:
                          const Text("Radial Bar", style: TextStyle(fontSize: 16)),
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const RadialBar()));
                      }),
                ),
              ),
              InkWell(
                child: SizedBox(
                  height: 40,
                  child: InkWell(
                      child:
                          const Text("TimeSeries", style: TextStyle(fontSize: 16)),
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const TimeSeries()));
                      }),
                ),
              ),
            ],
          ),
        ));
  }
}
