import 'package:flutter/material.dart';
import 'package:flutter_fusioncharts/flutter_fusioncharts.dart';

void main() {
  runApp(const TargetSmokeApp());
}

class TargetSmokeApp extends StatelessWidget {
  const TargetSmokeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('Flutter 3.41.9 smoke test')),
        body: const Padding(
          padding: EdgeInsets.all(16),
          child: SizedBox(
            height: 320,
            child: FusionCharts(
              type: 'column2d',
              dataSource: <String, dynamic>{
                'chart': <String, dynamic>{
                  'caption': 'PRD target compatibility',
                  'theme': 'fusion',
                },
                'data': <Map<String, String>>[
                  <String, String>{'label': 'A', 'value': '10'},
                  <String, String>{'label': 'B', 'value': '20'},
                ],
              },
            ),
          ),
        ),
      ),
    );
  }
}
