import 'package:flutter_fusioncharts/src/bridge/fusion_charts_protocol.dart';
import 'package:flutter_fusioncharts/src/security/fusion_charts_sanitizer.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('sanitizeDataSource strips network-capable export keys', () {
    test('at the top level and inside chart', () {
      final Map<String, dynamic> out = sanitizeDataSource(<String, dynamic>{
        'exportHandler': 'https://attacker.example/collect',
        'chart': <String, dynamic>{
          'caption': 'Revenue',
          'exportAction': 'save',
          'exportAtClientSide': '0',
          'exportTargetWindow': '_blank',
        },
      });

      expect(out.containsKey('exportHandler'), isFalse);
      expect((out['chart'] as Map<String, dynamic>).keys, <String>['caption']);
      expect(containsBlockedExportKeys(out), isFalse);
    });

    test('at every nesting depth, including inside lists', () {
      final Map<String, dynamic> out = sanitizeDataSource(<String, dynamic>{
        'dataset': <dynamic>[
          <String, dynamic>{
            'data': <dynamic>[
              <String, dynamic>{
                'value': '10',
                'exportHandler': 'https://attacker.example',
              },
            ],
          },
        ],
        'annotations': <String, dynamic>{
          'groups': <dynamic>[
            <String, dynamic>{'exportAction': 'save'},
          ],
        },
      });

      expect(containsBlockedExportKeys(out), isFalse);
      final List<dynamic> dataset = out['dataset'] as List<dynamic>;
      final Map<String, dynamic> first = (dataset[0]
          as Map<String, dynamic>)['data'][0] as Map<String, dynamic>;
      expect(first['value'], '10');
    });

    test('strips the aliases the security review missed', () {
      // html5exporthandler wins over exporthandler in the bundle's own
      // resolution order, and exportmode is the real route selector.
      final Map<String, dynamic> out = sanitizeDataSource(<String, dynamic>{
        'chart': <String, dynamic>{
          'html5ExportHandler': 'https://attacker.example/collect',
          'exportMode': 'server',
          'exportParameters': 'x=1',
        },
      });
      expect((out['chart'] as Map<String, dynamic>).isEmpty, isTrue);
      expect(containsBlockedExportKeys(out), isFalse);
    });

    test('blocks every route-selecting key the bundle reads', () {
      for (final String key in <String>[
        'exportAction',
        'exportHandler',
        'html5ExportHandler',
        'exportMode',
        'exportParameters',
        'exportTargetWindow',
        'exportAtClientSide',
      ]) {
        final Map<String, dynamic> out =
            sanitizeDataSource(<String, dynamic>{key: 'x'});
        expect(out.containsKey(key), isFalse, reason: key);
      }
    });

    test('leaves keys that do not select a destination', () {
      final Map<String, dynamic> out = sanitizeDataSource(<String, dynamic>{
        'chart': <String, dynamic>{
          'exportEnabled': '1',
          'exportFormats': 'png|jpg',
          'exportShowMenuItem': '1',
          'exportWithImages': '1',
          'exportFileName': 'report',
        },
      });
      final Map<String, dynamic> chart = out['chart'] as Map<String, dynamic>;
      expect(chart.keys.length, 5, reason: 'none of these route data anywhere');
    });

    test('case-insensitively', () {
      for (final String key in <String>[
        'EXPORTHANDLER',
        'ExportHandler',
        'exporthandler',
        'eXpOrTaCtIoN',
      ]) {
        final Map<String, dynamic> out =
            sanitizeDataSource(<String, dynamic>{key: 'x'});
        expect(out.containsKey(key), isFalse, reason: key);
      }
    });

    test('without mutating the caller and without touching other keys', () {
      final Map<String, dynamic> original = <String, dynamic>{
        'chart': <String, dynamic>{'caption': 'Q1', 'exportAction': 'save'},
        'dataset': <dynamic>[1, 2, 3],
      };
      final Map<String, dynamic> out = sanitizeDataSource(original);

      expect(
        (original['chart'] as Map<String, dynamic>).containsKey('exportAction'),
        isTrue,
        reason: "the caller's map must not be mutated",
      );
      expect(out['dataset'], <dynamic>[1, 2, 3]);
      expect(identical(out['dataset'], original['dataset']), isFalse,
          reason: 'must be a deep copy');
    });

    test('reports key paths and never values', () {
      final List<String> seen = <String>[];
      sanitizeDataSource(
        <String, dynamic>{
          'chart': <String, dynamic>{'exportHandler': 'super-secret-token'},
        },
        onStripped: seen.add,
      );
      expect(seen, <String>['chart.exportHandler']);
      for (final String path in seen) {
        expect(path.contains('super-secret-token'), isFalse);
      }
    });

    test('substitutes nothing for a removed key', () {
      final Map<String, dynamic> out = sanitizeDataSource(<String, dynamic>{
        'chart': <String, dynamic>{'exportAtClientSide': '0'},
      });
      expect((out['chart'] as Map<String, dynamic>).isEmpty, isTrue);
    });
  });

  group('outbound envelopes are sanitised at the protocol chokepoint', () {
    test('render and update both serialise through it', () {
      for (final String type in <String>[
        FusionChartsOutbound.render,
        FusionChartsOutbound.update,
      ]) {
        final String encoded = FusionChartsMessage(
          type: type,
          chartId: 'fc-1',
          payload: <String, dynamic>{
            'dataSource': <String, dynamic>{
              'chart': <String, dynamic>{
                'exportHandler': 'https://attacker.example',
              },
            },
          },
        ).encode();

        expect(encoded.contains('attacker.example'), isFalse, reason: type);
        expect(encoded.toLowerCase().contains('exporthandler'), isFalse,
            reason: type);
      }
    });

    test('leaves a payload without a dataSource untouched', () {
      final String encoded = FusionChartsMessage(
        type: FusionChartsOutbound.export,
        chartId: 'fc-1',
        payload: <String, dynamic>{'format': 'svg'},
      ).encode();
      expect(encoded.contains('"format":"svg"'), isTrue);
    });
  });
}
