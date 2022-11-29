import 'package:flutter/material.dart';
import 'package:flutter_fusioncharts_example/chart_widgets/combination/combination_menu.dart';
import 'package:flutter_fusioncharts_example/chart_widgets/events_others/events_menu.dart';
import 'package:flutter_fusioncharts_example/chart_widgets/maps/maps_menu.dart';
import 'package:flutter_fusioncharts_example/chart_widgets/multiseries/multiseries_menu.dart';
import 'package:flutter_fusioncharts_example/chart_widgets/other/other_chart_menu.dart';
import 'package:flutter_fusioncharts_example/chart_widgets/singleseries/singleseries_menu.dart';
import 'package:flutter_fusioncharts_example/chart_widgets/stacked/stacked_menu.dart';
import 'package:flutter_fusioncharts_example/chart_widgets/xyplot/xyplot_menu.dart';
import 'chart_widgets/drilldown/drill_down.dart';
import 'chart_widgets/events_others/annotated_bar.dart';
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
                      child: const Text("Events",
                          style: TextStyle(fontSize: 16)),
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const EventsMenu()));
                      }),
                ),
              ),
              InkWell(
                child: SizedBox(
                  height: 40,
                  child: InkWell(
                      child: const Text("XY Plot",
                          style: TextStyle(fontSize: 16)),
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
                      child: const Text("Maps",
                          style: TextStyle(fontSize: 16)),
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
                      child:
                          const Text("Other", style: TextStyle(fontSize: 16)),
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const OtherChartMenu()));
                      }),
                ),
              ),
            ],
          ),
        ));
  }
}
