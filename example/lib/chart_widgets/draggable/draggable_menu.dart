import 'package:flutter/material.dart';
import 'package:flutter_fusioncharts_example/chart_widgets/draggable/draggable_area.dart';
import 'package:flutter_fusioncharts_example/chart_widgets/draggable/draggable_column.dart';
import 'package:flutter_fusioncharts_example/chart_widgets/draggable/draggable_line.dart';



class DraggableMenu extends StatefulWidget {
  const DraggableMenu({Key? key}) : super(key: key);

  @override
  State<DraggableMenu> createState() => _DraggableMenuState();
}

class _DraggableMenuState extends State<DraggableMenu> {
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
                child: SizedBox(
                  height: 40,
                  child: InkWell(
                      child: const Text("Draggable Column",
                          style: TextStyle(fontSize: 16)),
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const DraggableColumn()));
                      }),
                ),
              ),
              InkWell(
                  child: SizedBox(height: 40,
                    child: InkWell(child: const Text("Draggable Area", style: TextStyle(fontSize: 16)),
                        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) =>  const DraggableArea()))),
                  )),
              InkWell(
                child: SizedBox(
                  height: 40,
                  child: InkWell(
                      child: const Text("Draggable Line",
                          style: TextStyle(fontSize: 16)),
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const DraggableLine()));
                      }),
                ),
              ),
            ],
          ),
        ));
  }
}
