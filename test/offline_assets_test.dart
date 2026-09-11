import 'dart:convert';
import 'dart:io';

import 'package:crypto/crypto.dart';
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
    expect(
      html,
      contains('fusioncharts/maps/fusioncharts.world.js'),
    );
    expect(
      html,
      contains('fusioncharts/maps/fusioncharts.usa.js'),
    );
  });

  test('vendored manifest pins and verifies every 4.2.2 asset', () {
    final Map<String, dynamic> manifest = jsonDecode(File(
      'doc/provenance/fusioncharts-4.2.2-manifest.json',
    ).readAsStringSync()) as Map<String, dynamic>;
    final List<dynamic> files = manifest['files'] as List<dynamic>;

    expect(manifest['fusioncharts_version'], '4.2.2');
    expect(manifest['asset_root'], 'assets/bridge/fusioncharts');
    expect(manifest['font_urls_rewritten_to_local_assets'], 7);
    expect(manifest['remote_font_urls_remaining'], 0);
    expect(manifest['file_count'], 33);
    expect(files, hasLength(33));

    final Set<String> paths = files.map((dynamic value) {
      return (value as Map<String, dynamic>)['path'] as String;
    }).toSet();
    expect(
      paths,
      containsAll(<String>{
        'maps/fusioncharts.world.js',
        'maps/fusioncharts.usa.js',
      }),
    );

    final String assetRoot = manifest['asset_root'] as String;
    int totalBytes = 0;
    for (final dynamic value in files) {
      final Map<String, dynamic> record = value as Map<String, dynamic>;
      final File asset = File('$assetRoot/${record['path']}');
      expect(asset.existsSync(), isTrue, reason: asset.path);
      expect(asset.lengthSync(), record['bytes'], reason: asset.path);
      expect(
        sha256.convert(asset.readAsBytesSync()).toString(),
        record['sha256'],
        reason: asset.path,
      );
      totalBytes += asset.lengthSync();
    }
    expect(totalBytes, manifest['total_bytes']);
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
