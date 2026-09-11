import 'dart:convert';

import 'package:flutter_fusioncharts/flutter_fusioncharts.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('FusionChartsExport.fromPayload', () {
    test('converts text to UTF-8 bytes and preserves metadata', () {
      final FusionChartsExport? export = FusionChartsExport.fromPayload(
        <String, dynamic>{
          'format': 'SVG',
          'mime': 'image/svg+xml',
          'fileName': 'revenue.svg',
          'text': '<svg>£</svg>',
        },
        fallbackFormat: 'bin',
      );

      expect(export, isNotNull);
      expect(export!.format, 'svg');
      expect(export.mimeType, 'image/svg+xml');
      expect(export.suggestedFileName, 'revenue.svg');
      expect(export.bytes, utf8.encode('<svg>£</svg>'));
      expect(export.text, '<svg>£</svg>');
    });

    test('decodes base64 bytes and supplies safe defaults', () {
      final FusionChartsExport? export = FusionChartsExport.fromPayload(
        <String, dynamic>{
          'base64': base64Encode(<int>[0, 127, 255])
        },
        fallbackFormat: 'bin',
      );

      expect(export, isNotNull);
      expect(export!.format, 'bin');
      expect(export.mimeType, 'application/octet-stream');
      expect(export.suggestedFileName, 'chart.bin');
      expect(export.bytes, <int>[0, 127, 255]);
      expect(export.text, isNull);
    });

    test('rejects empty, malformed and non-string payloads', () {
      for (final Map<String, dynamic> payload in <Map<String, dynamic>>[
        <String, dynamic>{},
        <String, dynamic>{'base64': ''},
        <String, dynamic>{'base64': '!not-base64!'},
        <String, dynamic>{'base64': 123},
      ]) {
        expect(
          FusionChartsExport.fromPayload(payload, fallbackFormat: 'bin'),
          isNull,
        );
      }
    });
  });
}
