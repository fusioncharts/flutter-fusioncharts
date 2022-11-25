import 'package:flutter/material.dart';
import 'package:flutter_fusioncharts_example/chart_widgets/stacked/multiseries_stackedbar.dart';
import 'package:flutter_fusioncharts_example/chart_widgets/stacked/multiseries_stackedcolumn.dart';
import 'package:flutter_fusioncharts_example/chart_widgets/stacked/stacked_area2d.dart';
import 'package:flutter_fusioncharts_example/chart_widgets/stacked/stacked_bar.dart';
import 'package:flutter_fusioncharts_example/chart_widgets/stacked/stacked_column.dart';


class StackedMenu extends StatefulWidget {
  const StackedMenu({Key? key}) : super(key: key);

  @override
  State<StackedMenu> createState() => _StackedMenuState();
}

class _StackedMenuState extends State<StackedMenu> {
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
                    child: InkWell(child: const Text("Column", style: TextStyle(fontSize: 16)),
                        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) =>  const StackedColumn()))),
                  )),
              InkWell(
                  child: SizedBox(height: 40,
                    child: InkWell(child: const Text("Bar", style: TextStyle(fontSize: 16)),
                        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) =>const  StackedBar()))),
                  )),
              InkWell(
                  child: SizedBox(height: 40,
                    child: InkWell(child: const Text("Area", style: TextStyle(fontSize: 16)),
                        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) =>const  StackedArea2D()))),
                  )),
              InkWell(
                  child: SizedBox(height: 40,
                    child: InkWell(child: const Text("Multi Series Stacked Bar", style: TextStyle(fontSize: 16)),
                        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) =>const  StackedBarMultiSeries()))),
                  )),
              InkWell(
                  child: SizedBox(height: 40,
                    child: InkWell(child: const Text("Multi Series Stacked Column", style: TextStyle(fontSize: 16)),
                        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) =>const  StackedColumnMultiSeries()))),
                  )),
            ],
          ),
        ));
  }
}
