import 'package:flutter/material.dart';
import 'package:flutter_fusioncharts_example/chart_widgets/spline/multiseries_spline.dart';
import 'package:flutter_fusioncharts_example/chart_widgets/spline/single_series_area.dart';
import 'package:flutter_fusioncharts_example/chart_widgets/spline/single_series_spline.dart';


class SplineMenu extends StatefulWidget {
  const SplineMenu({Key? key}) : super(key: key);

  @override
  State<SplineMenu> createState() => _SplineMenuState();
}

class _SplineMenuState extends State<SplineMenu> {
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
                    child: InkWell(child: const Text("Single Series Area", style: TextStyle(fontSize: 16)),
                        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) =>  const SingleSeriesArea()))),
                  )),
              InkWell(
                child: SizedBox(
                  height: 40,
                  child: InkWell(
                      child: const Text("Single Series Spline",
                          style: TextStyle(fontSize: 16)),
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const SingleSeriesSpline()));
                      }),
                ),
              ),
              InkWell(
                child: SizedBox(
                  height: 40,
                  child: InkWell(
                      child: const Text("Multi Series Spline",
                          style: TextStyle(fontSize: 16)),
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const MultiSeriesSpline()));
                      }),
                ),
              ),
            ],
          ),
        ));
  }
}
