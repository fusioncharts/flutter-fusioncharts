import 'package:flutter/material.dart';
import 'package:flutter_fusioncharts/flutter_fusioncharts.dart';
import 'package:flutter_fusioncharts_example/chartdata.dart';
import '../../constants.dart';

class ColumnChartExport extends StatefulWidget {
  const ColumnChartExport({super.key});

  @override
  State<ColumnChartExport> createState() => _ColumnChartExportState();
}

class _ColumnChartExportState extends State<ColumnChartExport> {
  final FusionChartsController _controller = FusionChartsController();
  late final FusionCharts _chart;

  @override
  void initState() {
    super.initState();

    _chart = FusionCharts(
      dataSource: <String, dynamic>{
        'chart': const <String, dynamic>{
          'caption': 'Countries With Most Oil Reserves [2017-18]',
          'subCaption': 'In MMbbl = One Million barrels',
          'xAxisName': 'Country',
          'yAxisName': 'Reserves (MMbbl)',
          'numberSuffix': 'K',
          'theme': 'fusion',
        },
        'data': ChartData.chartData,
      },
      type: 'column2d',
      width: '100%',
      height: '100%',
      fusionChartsController: _controller,
      licenseKey: licenseKey,
      onExport: _handleExport,
      onError: _handleError,
    );
  }

  void _handleExport(FusionChartsExport result) {
    if (!mounted) {
      return;
    }
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          '${result.suggestedFileName}: ${result.bytes.length} bytes',
        ),
      ),
    );
  }

  void _handleError(FusionChartsError error) {
    if (!mounted) {
      return;
    }
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('${error.code}: ${error.message}')),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('FusionCharts export')),
      body: Column(
        children: <Widget>[
          Expanded(child: _chart),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Wrap(
              spacing: 8,
              children: <Widget>[
                ElevatedButton(
                  onPressed: () =>
                      _controller.exportChart(FusionChartsExportFormat.svg),
                  child: const Text('Export SVG'),
                ),
                ElevatedButton(
                  onPressed: () =>
                      _controller.exportChart(FusionChartsExportFormat.csv),
                  child: const Text('Export CSV'),
                ),
                ElevatedButton(
                  onPressed: () =>
                      _controller.exportChart(FusionChartsExportFormat.xlsx),
                  child: const Text('Export XLSX'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
