import 'package:flutter/material.dart';
import 'package:flutter_fusioncharts_example/chart_widgets/bullet_graph/bullet_graph_menu.dart';
import 'package:flutter_fusioncharts_example/chart_widgets/combination/combination_menu.dart';
import 'package:flutter_fusioncharts_example/chart_widgets/draggable/draggable_menu.dart';
import 'package:flutter_fusioncharts_example/chart_widgets/error/error_menu.dart';
import 'package:flutter_fusioncharts_example/chart_widgets/events_others/events_menu.dart';
import 'package:flutter_fusioncharts_example/chart_widgets/gauges/gauges_menu.dart';
import 'package:flutter_fusioncharts_example/chart_widgets/inverse_yaxis/inverse_menu.dart';
import 'package:flutter_fusioncharts_example/chart_widgets/logarithmic/log_menu.dart';
import 'package:flutter_fusioncharts_example/chart_widgets/maps/maps_menu.dart';
import 'package:flutter_fusioncharts_example/chart_widgets/multiseries/multiseries_menu.dart';
import 'package:flutter_fusioncharts_example/chart_widgets/other/other_chart_menu.dart';
import 'package:flutter_fusioncharts_example/chart_widgets/realtime_datastreaming/rd_menu.dart';
import 'package:flutter_fusioncharts_example/chart_widgets/scroll/scroll_menu.dart';
import 'package:flutter_fusioncharts_example/chart_widgets/singleseries/singleseries_menu.dart';
import 'package:flutter_fusioncharts_example/chart_widgets/spline/spline_menu.dart';
import 'package:flutter_fusioncharts_example/chart_widgets/stacked/stacked_menu.dart';
import 'package:flutter_fusioncharts_example/chart_widgets/xyplot/xyplot_menu.dart';
import 'chart_widgets/drilldown/drill_down.dart';
import 'chart_widgets/spark/spark_menu.dart';

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
        appBar: AppBar(title: const Text('Choose Chart Type')),
        body: Center(
          child: ListView(
            physics: const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
            shrinkWrap: true,
            children: [
              const SizedBox(height: 20,),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    InkWell(
                      child: SizedBox(
                        height: 40,
                        child: InkWell(
                            child: const Text("Single Series",
                                style: TextStyle(fontSize: 16)),
                            onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const SingleSeriesMenu()))),
                      ),
                    ),
                    InkWell(
                      child: SizedBox(
                        height: 40,
                        child: InkWell(
                            child: const Text("Multi Series",
                                style: TextStyle(fontSize: 16)),
                            onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const MultiSeriesMenu()))),
                      ),
                    ),
                    InkWell(
                        child: SizedBox(
                          height: 40,
                          child: InkWell(
                              child:
                              const Text("Stacked", style: TextStyle(fontSize: 16)),
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => const StackedMenu()));
                              }),
                        )),
                    InkWell(
                      child: SizedBox(
                        height: 40,
                        child: InkWell(
                            child: const Text("Combination",
                                style: TextStyle(fontSize: 16)),
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => const CombinationMenu()));
                            }),
                      ),
                    ),
                    InkWell(
                      child: SizedBox(
                        height: 40,
                        child: InkWell(
                            child: const Text("Scroll",
                                style: TextStyle(fontSize: 16)),
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => const ScrollMenu()));
                            }),
                      ),
                    ),
                    InkWell(
                      child: SizedBox(
                        height: 40,
                        child: InkWell(
                            child:
                            const Text("XY Plot", style: TextStyle(fontSize: 16)),
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => const XYPlotMenu()));
                            }),
                      ),
                    ),
                    InkWell(
                      child: SizedBox(
                        height: 40,
                        child: InkWell(
                            child: const Text("Maps", style: TextStyle(fontSize: 16)),
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => const WorldMapMenu()));
                            }),
                      ),
                    ),
                    InkWell(
                      child: SizedBox(
                        height: 40,
                        child: InkWell(
                            child: const Text("Drill Down",
                                style: TextStyle(fontSize: 16)),
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => const DrillDown()));
                            }),
                      ),
                    ),
                    InkWell(
                      child: SizedBox(
                        height: 40,
                        child: InkWell(
                            child: const Text("Gauges",
                                style: TextStyle(fontSize: 16)),
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => const GaugesMenu()));
                            }),
                      ),
                    ),
                    InkWell(
                      child: SizedBox(
                        height: 40,
                        child: InkWell(
                            child: const Text("Realtime",
                                style: TextStyle(fontSize: 16)),
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => const RDSMenu()));
                            }),
                      ),
                    ),
                    InkWell(
                      child: SizedBox(
                        height: 40,
                        child: InkWell(
                            child: const Text("Spark",
                                style: TextStyle(fontSize: 16)),
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => const SparkMenu()));
                            }),
                      ),
                    ),
                    InkWell(
                      child: SizedBox(
                        height: 40,
                        child: InkWell(
                            child: const Text("Bullet Graph",
                                style: TextStyle(fontSize: 16)),
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => const BulletGraphMenu()));
                            }),
                      ),
                    ),
                    InkWell(
                      child: SizedBox(
                        height: 40,
                        child: InkWell(
                            child: const Text("Logarithmic",
                                style: TextStyle(fontSize: 16)),
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => const LogMenu()));
                            }),
                      ),
                    ),
                    InkWell(
                      child: SizedBox(
                        height: 40,
                        child: InkWell(
                            child: const Text("Spline",
                                style: TextStyle(fontSize: 16)),
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => const SplineMenu()));
                            }),
                      ),
                    ),
                    InkWell(
                      child: SizedBox(
                        height: 40,
                        child: InkWell(
                            child: const Text("Error",
                                style: TextStyle(fontSize: 16)),
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => const ErrorMenu()));
                            }),
                      ),
                    ),
                    InkWell(
                      child: SizedBox(
                        height: 40,
                        child: InkWell(
                            child: const Text("Inverse",
                                style: TextStyle(fontSize: 16)),
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => const InverseMenu()));
                            }),
                      ),
                    ),
                    InkWell(
                      child: SizedBox(
                        height: 40,
                        child: InkWell(
                            child: const Text("Draggable",
                                style: TextStyle(fontSize: 16)),
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => const DraggableMenu()));
                            }),
                      ),
                    ),
                    InkWell(
                      child: SizedBox(
                        height: 40,
                        child: InkWell(
                            child:
                            const Text("Other/Miscellaneous", style: TextStyle(fontSize: 16)),
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => const OtherChartMenu()));
                            }),
                      ),
                    ),
                    InkWell(
                      child: SizedBox(
                        height: 40,
                        child: InkWell(
                            child:
                            const Text("Events", style: TextStyle(fontSize: 16)),
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => const EventsMenu()));
                            }),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ));
  }
}
