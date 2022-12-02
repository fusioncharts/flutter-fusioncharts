import 'package:flutter/material.dart';
import 'package:flutter_fusioncharts_example/chart_widgets/error/error_bar.dart';
import 'package:flutter_fusioncharts_example/chart_widgets/error/error_line.dart';
import 'package:flutter_fusioncharts_example/chart_widgets/error/error_scatter.dart';
import 'package:flutter_fusioncharts_example/chart_widgets/inverse_yaxis/inverse_area.dart';
import 'package:flutter_fusioncharts_example/chart_widgets/inverse_yaxis/inverse_column.dart';
import 'package:flutter_fusioncharts_example/chart_widgets/inverse_yaxis/inverse_line.dart';



class InverseMenu extends StatefulWidget {
  const InverseMenu({Key? key}) : super(key: key);

  @override
  State<InverseMenu> createState() => _InverseMenuState();
}

class _InverseMenuState extends State<InverseMenu> {
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
                    child: InkWell(child: const Text("Inverse Area", style: TextStyle(fontSize: 16)),
                        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) =>  const InverseArea()))),
                  )),
              InkWell(
                child: SizedBox(
                  height: 40,
                  child: InkWell(
                      child: const Text("Inverse Column",
                          style: TextStyle(fontSize: 16)),
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const InverseColumn()));
                      }),
                ),
              ),
              InkWell(
                child: SizedBox(
                  height: 40,
                  child: InkWell(
                      child: const Text("Inverse Line",
                          style: TextStyle(fontSize: 16)),
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const InverseLine()));
                      }),
                ),
              ),
            ],
          ),
        ));
  }
}
