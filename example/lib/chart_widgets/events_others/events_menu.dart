import 'package:flutter/material.dart';
import 'package:flutter_fusioncharts_example/chart_widgets/events_others/annotated_bar.dart';
import 'package:flutter_fusioncharts_example/chart_widgets/events_others/events_example.dart';
import 'package:flutter_fusioncharts_example/chart_widgets/events_others/events_example2.dart';
import 'package:flutter_fusioncharts_example/chart_widgets/maps/trial_map.dart';
import 'package:flutter_fusioncharts_example/chart_widgets/maps/usa.dart';
import 'package:flutter_fusioncharts_example/chart_widgets/maps/worldmap.dart';


class EventsMenu extends StatefulWidget {
  const EventsMenu({Key? key}) : super(key: key);

  @override
  State<EventsMenu> createState() => _EventsMenuState();
}

class _EventsMenuState extends State<EventsMenu> {
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
                    child: InkWell(child: const Text("Annotated Bar", style: TextStyle(fontSize: 16)),
                        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) =>  const AnnotatedBar()))),
                  )),
              InkWell(
                child: SizedBox(
                  height: 40,
                  child: InkWell(
                      child: const Text("Area Event",
                          style: TextStyle(fontSize: 16)),
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const AreaEvents()));
                      }),
                ),
              ),
              InkWell(
                child: SizedBox(
                  height: 40,
                  child: InkWell(
                      child: const Text("Doughnut Event",
                          style: TextStyle(fontSize: 16)),
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const DoughnutEvent()));
                      }),
                ),
              ),
            ],
          ),
        ));
  }
}
