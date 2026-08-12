import 'package:flutter/material.dart';
import 'package:flutter_fusioncharts/flutter_fusioncharts.dart';

import '../../constants.dart';

class UsaMap extends StatefulWidget {
  const UsaMap({super.key});

  @override
  State<UsaMap> createState() => _UsaMapState();
}

class _UsaMapState extends State<UsaMap> {
  late final FusionCharts _fusionChart;
  final FusionChartsController _controller = FusionChartsController();

  @override
  void initState() {
    super.initState();

    final Map<String, dynamic> dataSource = <String, dynamic>{
      'chart': <String, dynamic>{
        'caption': 'Annual sales by state',
        'subcaption': 'Sample data',
        'entityFillHoverColor': '#cccccc',
        'numberPrefix': r'$',
        'showLabels': '1',
        'theme': 'fusion',
      },
      'colorrange': <String, dynamic>{
        'minvalue': '0',
        'startlabel': 'Low',
        'endlabel': 'High',
        'code': '#e44a00',
        'gradient': '1',
        'color': <Map<String, String>>[
          <String, String>{
            'maxvalue': '50000',
            'displayvalue': 'Average',
            'code': '#f8bd19',
          },
          <String, String>{'maxvalue': '100000', 'code': '#6baa01'},
        ],
      },
      'data': <Map<String, String>>[
        <String, String>{'id': 'CA', 'value': '61861'},
        <String, String>{'id': 'FL', 'value': '88234'},
        <String, String>{'id': 'IL', 'value': '73202'},
        <String, String>{'id': 'NY', 'value': '42828'},
        <String, String>{'id': 'TX', 'value': '75425'},
        <String, String>{'id': 'WA', 'value': '34927'},
      ],
    };

    _fusionChart = FusionCharts(
      dataSource: dataSource,
      type: 'maps/usa',
      width: '100%',
      height: '100%',
      fusionChartsController: _controller,
      licenseKey: licenseKey,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('FusionCharts - USA Map')),
      body: SizedBox.expand(child: _fusionChart),
    );
  }
}
