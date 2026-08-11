import 'package:flutter/material.dart';
import 'package:flutter_fusioncharts_example/chart_widgets/maps/worldmap.dart';

class WorldMapMenu extends StatelessWidget {
  const WorldMapMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Choose Example')),
      body: Center(
        child: ListTile(
          title: const Text('World Map'),
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute<void>(
              builder: (BuildContext context) => const WorldMap(),
            ),
          ),
        ),
      ),
    );
  }
}
