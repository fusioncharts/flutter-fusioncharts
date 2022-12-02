import 'package:flutter/material.dart';
import 'package:flutter_fusioncharts_example/chart_widgets/error/error_bar.dart';
import 'package:flutter_fusioncharts_example/chart_widgets/error/error_line.dart';
import 'package:flutter_fusioncharts_example/chart_widgets/error/error_scatter.dart';
import 'package:flutter_fusioncharts_example/chart_widgets/spline/multiseries_spline.dart';
import 'package:flutter_fusioncharts_example/chart_widgets/spline/single_series_area.dart';
import 'package:flutter_fusioncharts_example/chart_widgets/spline/single_series_spline.dart';


class ErrorMenu extends StatefulWidget {
  const ErrorMenu({Key? key}) : super(key: key);

  @override
  State<ErrorMenu> createState() => _ErrorMenuState();
}

class _ErrorMenuState extends State<ErrorMenu> {
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
                    child: InkWell(child: const Text("Error Bar", style: TextStyle(fontSize: 16)),
                        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) =>  const ErrorBar()))),
                  )),
              InkWell(
                child: SizedBox(
                  height: 40,
                  child: InkWell(
                      child: const Text("Error Line",
                          style: TextStyle(fontSize: 16)),
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const ErrorLine()));
                      }),
                ),
              ),
              InkWell(
                child: SizedBox(
                  height: 40,
                  child: InkWell(
                      child: const Text("Error Scatter",
                          style: TextStyle(fontSize: 16)),
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const ErrorScatter()));
                      }),
                ),
              ),
            ],
          ),
        ));
  }
}
