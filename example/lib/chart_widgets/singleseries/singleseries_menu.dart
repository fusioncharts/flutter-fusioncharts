import 'package:flutter/material.dart';
import 'package:flutter_fusioncharts_example/chart_widgets/singleseries/area.dart';
import 'package:flutter_fusioncharts_example/chart_widgets/singleseries/bar.dart';
import 'package:flutter_fusioncharts_example/chart_widgets/singleseries/column.dart';
import 'package:flutter_fusioncharts_example/chart_widgets/singleseries/doughnut.dart';
import 'package:flutter_fusioncharts_example/chart_widgets/singleseries/line2d.dart';
import 'package:flutter_fusioncharts_example/chart_widgets/multiseries/multiseries.dart';
import 'package:flutter_fusioncharts_example/chart_widgets/singleseries/pareto.dart';
import 'package:flutter_fusioncharts_example/chart_widgets/singleseries/pie.dart';

class SingleSeriesMenu extends StatefulWidget {
  const SingleSeriesMenu({Key? key}) : super(key: key);

  @override
  State<SingleSeriesMenu> createState() => _SingleSeriesMenuState();
}

class _SingleSeriesMenuState extends State<SingleSeriesMenu> {
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
                    child: InkWell(child: const Text("Column", style: TextStyle(fontSize: 16)),
                        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) =>  const ColumnChart()))),
                  )),
              InkWell(
                  child: SizedBox(height: 40,
                    child: InkWell(child: const Text("Line", style: TextStyle(fontSize: 16)),
                        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) =>const  Line2D()))),
                  )),
              InkWell(
                  child: SizedBox(height: 40,
                    child: InkWell(child: const Text("Bar", style: TextStyle(fontSize: 16)),
                        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) =>const  Bar()))),
                  )),
              InkWell(
                  child: SizedBox(
                    height: 40,
                    child: InkWell(
                        child:
                        const Text("Doughnut", style: TextStyle(fontSize: 16)),
                        onTap: () => Navigator.push(context,
                            MaterialPageRoute(builder: (context) => const Doughnut()))),
                  )),
              InkWell(
                  child: SizedBox(
                    height: 40,
                    child: InkWell(
                        child:
                        const Text("Area", style: TextStyle(fontSize: 16)),
                        onTap: () => Navigator.push(context,
                            MaterialPageRoute(builder: (context) => const Area()))),
                  )),
              InkWell(
                  child: SizedBox(
                    height: 40,
                    child: InkWell(
                        child:
                        const Text("Pie", style: TextStyle(fontSize: 16)),
                        onTap: () => Navigator.push(context,
                            MaterialPageRoute(builder: (context) => const Pie()))),
                  )),
              InkWell(
                  child: SizedBox(
                    height: 40,
                    child: InkWell(
                        child:
                        const Text("Pareto", style: TextStyle(fontSize: 16)),
                        onTap: () => Navigator.push(context,
                            MaterialPageRoute(builder: (context) => const Pareto()))),
                  )),
            ],
          ),
        ));
  }
}
