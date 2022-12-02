import 'package:flutter/material.dart';
import 'package:flutter_fusioncharts_example/chart_widgets/bullet_graph/horizontal_bullet_graph.dart';
import 'package:flutter_fusioncharts_example/chart_widgets/bullet_graph/vertical_bullet_graph.dart';
import 'package:flutter_fusioncharts_example/chart_widgets/logarithmic/log_column.dart';
import 'package:flutter_fusioncharts_example/chart_widgets/logarithmic/log_line.dart';


class LogMenu extends StatefulWidget {
  const LogMenu({Key? key}) : super(key: key);

  @override
  State<LogMenu> createState() => _LogMenuState();
}

class _LogMenuState extends State<LogMenu> {
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
                    child: InkWell(child: const Text("Log Column", style: TextStyle(fontSize: 16)),
                        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) =>  const LogColumn()))),
                  )),
              InkWell(
                child: SizedBox(
                  height: 40,
                  child: InkWell(
                      child: const Text("Log Line",
                          style: TextStyle(fontSize: 16)),
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const LogLine()));
                      }),
                ),
              ),
            ],
          ),
        ));
  }
}
