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
import 'package:flutter_fusioncharts_example/chart_widgets/singleseries/area.dart';
import 'package:flutter_fusioncharts_example/chart_widgets/singleseries/bar.dart';
import 'package:flutter_fusioncharts_example/chart_widgets/singleseries/column.dart';
import 'package:flutter_fusioncharts_example/chart_widgets/singleseries/doughnut.dart';
import 'package:flutter_fusioncharts_example/chart_widgets/singleseries/line2d.dart';
import 'package:flutter_fusioncharts_example/chart_widgets/singleseries/pareto.dart';
import 'package:flutter_fusioncharts_example/chart_widgets/singleseries/pie.dart';

class MultiSeriesMenu extends StatefulWidget {
  const MultiSeriesMenu({Key? key}) : super(key: key);

  @override
  State<MultiSeriesMenu> createState() => _MultiSeriesMenuState();
}

class _MultiSeriesMenuState extends State<MultiSeriesMenu> {
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
                        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) =>  const ColumnMultiSeries()))),
                  )),
              InkWell(
                  child: SizedBox(height: 40,
                    child: InkWell(child: const Text("Line", style: TextStyle(fontSize: 16)),
                        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) =>const  LineMultiSeries()))),
                  )),
              InkWell(
                  child: SizedBox(height: 40,
                    child: InkWell(child: const Text("Bar", style: TextStyle(fontSize: 16)),
                        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) =>const  BarMultiSeries()))),
                  )),
              InkWell(
                  child: SizedBox(
                    height: 40,
                    child: InkWell(
                        child:
                        const Text("Overlapped Column", style: TextStyle(fontSize: 16)),
                        onTap: () => Navigator.push(context,
                            MaterialPageRoute(builder: (context) => const OverlappedColumn()))),
                  )),
              InkWell(
                  child: SizedBox(
                    height: 40,
                    child: InkWell(
                        child:
                        const Text("Area", style: TextStyle(fontSize: 16)),
                        onTap: () => Navigator.push(context,
                            MaterialPageRoute(builder: (context) => const AreaMultiSeries()))),
                  )),
              InkWell(
                  child: SizedBox(
                    height: 40,
                    child: InkWell(
                        child:
                        const Text("Overlapped Bar", style: TextStyle(fontSize: 16)),
                        onTap: () => Navigator.push(context,
                            MaterialPageRoute(builder: (context) => const OverlappedBar()))),
                  )),
              InkWell(
                  child: SizedBox(
                    height: 40,
                    child: InkWell(
                        child:
                        const Text("Marimekko", style: TextStyle(fontSize: 16)),
                        onTap: () => Navigator.push(context,
                            MaterialPageRoute(builder: (context) => const Marimekko()))),
                  )),
              InkWell(
                  child: SizedBox(
                    height: 40,
                    child: InkWell(
                        child:
                        const Text("Zoomline", style: TextStyle(fontSize: 16)),
                        onTap: () => Navigator.push(context,
                            MaterialPageRoute(builder: (context) => const Zoomline()))),
                  )),
              InkWell(
                  child: SizedBox(
                    height: 40,
                    child: InkWell(
                        child:
                        const Text("Zoomline DY", style: TextStyle(fontSize: 16)),
                        onTap: () => Navigator.push(context,
                            MaterialPageRoute(builder: (context) => const ZoomlineDY()))),
                  )),
            ],
          ),
        ));
  }
}
