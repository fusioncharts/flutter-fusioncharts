import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  test('package page loads scripts only from relative Flutter assets', () {
    final String html = File('assets/bridge/fc_page.html').readAsStringSync();
    final Iterable<RegExpMatch> scripts =
        RegExp(r'<script\s+src="([^"]+)"').allMatches(html);

    expect(scripts, isNotEmpty);
    for (final RegExpMatch match in scripts) {
      final String source = match.group(1)!;
      expect(Uri.tryParse(source)?.hasScheme ?? false, isFalse, reason: source);
      expect(source.startsWith('//'), isFalse, reason: source);
    }
    expect(html, contains("connect-src 'self' data: blob:"));
    expect(html, contains("form-action 'none'"));
  });

  test('vendored manifest pins 4.2.2 and records local theme fonts', () {
    final Map<String, dynamic> manifest = jsonDecode(File(
      'doc/provenance/fusioncharts-4.2.2-manifest.json',
    ).readAsStringSync()) as Map<String, dynamic>;

    expect(manifest['fusioncharts_version'], '4.2.2');
    expect(manifest['asset_root'], 'assets/bridge/fusioncharts');
    expect(manifest['font_urls_rewritten_to_local_assets'], 7);
    expect(manifest['remote_font_urls_remaining'], 0);
    expect(manifest['file_count'], 32);
    expect((manifest['files'] as List<dynamic>), hasLength(32));
  });

  test('theme font URLs resolve to bundled WOFF2 files', () {
    const List<String> themes = <String>['candy', 'fusion', 'umber'];
    int fontUrlCount = 0;

    for (final String theme in themes) {
      final String javascript = File(
        'assets/bridge/fusioncharts/themes/fusioncharts.theme.$theme.js',
      ).readAsStringSync();

      expect(javascript, isNot(contains('fonts.gstatic.com')));
      expect(javascript, isNot(contains('about:blank')));

      final Iterable<RegExpMatch> fontUrls = RegExp(
        r'url\((["\x27]?)(fusioncharts/fonts/[^)"\x27]+\.woff2)\1\)',
      ).allMatches(javascript);
      for (final RegExpMatch match in fontUrls) {
        final String relativeToPage = match.group(2)!;
        expect(
          File('assets/bridge/$relativeToPage').existsSync(),
          isTrue,
          reason: relativeToPage,
        );
        fontUrlCount++;
      }
    }

    expect(fontUrlCount, 7);
  });
}
