import 'package:flutter/material.dart';
import 'package:flutter_fusioncharts_example/chart_widgets/xyplot/bubble_chart.dart';
import 'package:flutter_fusioncharts_example/chart_widgets/xyplot/scattered.dart';
import 'package:flutter_fusioncharts_example/chart_widgets/xyplot/zoom_scattered.dart';

class XYPlotMenu extends StatefulWidget {
  const XYPlotMenu({Key? key}) : super(key: key);

  @override
  State<XYPlotMenu> createState() => _XYPlotMenuState();
}

class _XYPlotMenuState extends State<XYPlotMenu> {
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
                    child:
                        const Text("Scattered", style: TextStyle(fontSize: 16)),
                    onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const Scattered()))),
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
                      child:
                          const Text("Bubble", style: TextStyle(fontSize: 16)),
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
