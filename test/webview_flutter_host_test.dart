import 'package:flutter_fusioncharts/src/host/webview_flutter_host.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('allows package asset navigation required by WKWebView', () {
    expect(isAllowedLocalNavigation('file:///assets/fc_page.html'), isTrue);
    expect(isAllowedLocalNavigation('about:blank'), isTrue);
  });

  test('blocks network and lookalike schemes', () {
    for (final String url in <String>[
      'https://cdn.fusioncharts.com/fusioncharts.js',
      'http://example.com',
      'file-remote://example.com',
      'javascript:alert(1)',
    ]) {
      expect(isAllowedLocalNavigation(url), isFalse, reason: url);
    }
  });
}
