import 'package:flutter/material.dart';
import 'package:flutter_fusioncharts/flutter_fusioncharts.dart';

/// Demonstrates the 2.0 export API.
///
/// The wrapper does not write files, request storage permissions or choose a
/// destination. It hands the application the bytes, a sanitised file name and
/// the format, and the application decides what to do with them. That is why
/// this example needs no `path_provider`, no `permission_handler` and no
/// storage permission in the manifest.
///
/// To save what arrives, add `path_provider` to your own application and:
///
/// ```dart
/// onExport: (FusionChartsExport result) async {
///   final Directory dir = await getApplicationDocumentsDirectory();
///   final File file = File('${dir.path}/${result.suggestedFileName}');
///   await file.writeAsBytes(result.bytes, flush: true);
/// }
/// ```
///
/// `suggestedFileName` is sanitised by the package before it reaches you: it is
/// always a bare name carrying the requested extension, with no path
/// separator, so joining it to a directory cannot escape that directory.
///
/// **Format availability is platform-dependent.** As of 2.0, Android returns
/// all six formats. On iOS, `svg`, `csv` and `xlsx` are available; `png`,
/// `jpg` and `pdf` are produced by FusionCharts only through its network
/// export server, which this package refuses because it delivers offline, so
/// those three report `export-server-blocked` through `onError`. See the
/// support matrix in the README.
class ExportExample extends StatefulWidget {
  const ExportExample({super.key});

  @override
  State<ExportExample> createState() => _ExportExampleState();
}

class _ExportExampleState extends State<ExportExample> {
  final FusionChartsController _controller = FusionChartsController();

  /// Most recent successful export, or null if none has arrived.
  FusionChartsExport? _result;

  /// Most recent error, cleared when an export succeeds.
  String? _error;

  /// The format currently being awaited, so the UI can show progress.
  String? _pending;

  late FusionCharts _chart;

  @override
  void initState() {
    super.initState();

    final Map<String, dynamic> dataSource = <String, dynamic>{
      'chart': <String, String>{
        'caption': 'Quarterly Revenue',
        'subCaption': 'FY 2025-26',
        'xAxisName': 'Quarter',
        'yAxisName': 'Revenue',
        'numberPrefix': r'$',
        'theme': 'candy',
        // Shows the chart's own export menu, top right. Choosing a format
        // there reaches `onExport` by the same route as the buttons below.
        'exportEnabled': '1',
      },
      'data': <dynamic>[
        <String, String>{'label': 'Q1', 'value': '420000'},
        <String, String>{'label': 'Q2', 'value': '510000'},
        <String, String>{'label': 'Q3', 'value': '475000'},
        <String, String>{'label': 'Q4', 'value': '620000'},
      ],
    };

    _chart = FusionCharts(
      dataSource: dataSource,
      type: 'column2d',
      width: '100%',
      height: '100%',
      fusionChartsController: _controller,
      onExport: (FusionChartsExport result) {
        setState(() {
          _pending = null;
          _error = null;
          _result = result;
        });
      },
      onError: (FusionChartsError error) {
        setState(() {
          _pending = null;
          _result = null;
          _error = '${error.code}: ${error.message}';
        });
      },
    );
  }

  void _request(String format) {
    setState(() {
      _pending = format;
      _result = null;
      _error = null;
    });
    _controller.exportChart(format);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Fusion Charts - Export')),
      body: Column(
        children: <Widget>[
          SizedBox(
            height: MediaQuery.of(context).size.height / 3,
            child: _chart,
          ),
          const SizedBox(height: 8),
          Wrap(
            alignment: WrapAlignment.center,
            spacing: 8,
            runSpacing: 4,
            children: FusionChartsExportFormat.all
                .map((String format) => ElevatedButton(
                      onPressed:
                          _pending == null ? () => _request(format) : null,
                      child: Text(format.toUpperCase()),
                    ))
                .toList(),
          ),
          const Divider(height: 24),
          Expanded(child: _buildResult()),
        ],
      ),
    );
  }

  Widget _buildResult() {
    if (_pending != null) {
      return Center(child: Text('Exporting ${_pending!.toUpperCase()}...'));
    }
    if (_error != null) {
      return _panel(
        title: 'onError',
        color: Theme.of(context).colorScheme.error,
        body: _error!,
      );
    }
    final FusionChartsExport? result = _result;
    if (result == null) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Text(
            'Choose a format above, or use the chart\'s own export menu.\n\n'
            'The bytes arrive on onExport. This screen shows what your '
            'application receives; it deliberately does not save anything.',
            textAlign: TextAlign.center,
          ),
        ),
      );
    }
    return _panel(
      title: 'onExport',
      color: Theme.of(context).colorScheme.primary,
      body: 'format            ${result.format}\n'
          'mimeType          ${result.mimeType}\n'
          'suggestedFileName ${result.suggestedFileName}\n'
          'lengthInBytes     ${result.lengthInBytes}\n'
          'text              ${result.text == null ? 'null (binary format)' : '${result.text!.length} characters'}\n'
          '\n${_preview(result)}',
    );
  }

  /// Text formats are readable directly; binary formats are shown as the
  /// leading bytes, which is enough to confirm the payload is real.
  String _preview(FusionChartsExport result) {
    final String? text = result.text;
    if (text != null) {
      return text.length <= 400 ? text : '${text.substring(0, 400)}\n...';
    }
    final int count = result.bytes.length < 16 ? result.bytes.length : 16;
    final String hex = result.bytes
        .sublist(0, count)
        .map((int b) => b.toRadixString(16).padLeft(2, '0'))
        .join(' ');
    return 'first $count bytes  $hex';
  }

  Widget _panel({
    required String title,
    required Color color,
    required String body,
  }) {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      children: <Widget>[
        Text(
          title,
          style: TextStyle(color: color, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 6),
        Text(body, style: const TextStyle(fontSize: 11, fontFamily: 'Menlo')),
        const SizedBox(height: 16),
      ],
    );
  }
}
