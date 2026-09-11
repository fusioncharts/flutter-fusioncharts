import 'package:flutter_fusioncharts/src/host/webview_flutter_host.dart';
import 'package:flutter_fusioncharts/src/source/fusion_charts_source.dart';
import 'package:flutter_test/flutter_test.dart';

/// The asset key the package loads by default.
const String kKey = FusionChartsSource.packageAsset;

/// How each platform resolves that key. Android serves Flutter assets from
/// `android_asset`, iOS from a path inside the application bundle.
const String kAndroidUrl = 'file:///android_asset/flutter_assets/$kKey';
const String kIosUrl =
    'file:///private/var/containers/Bundle/Application/1234/Runner.app/'
    'Frameworks/App.framework/flutter_assets/$kKey';

void main() {
  test('allows package asset navigation required by WKWebView', () {
    expect(isAllowedLocalNavigation(kAndroidUrl, assetKey: kKey), isTrue);
    expect(isAllowedLocalNavigation(kIosUrl, assetKey: kKey), isTrue);
    expect(isAllowedLocalNavigation('about:blank', assetKey: kKey), isTrue);
  });

  test('allows an in-page fragment or query on the loaded page', () {
    expect(isAllowedLocalNavigation('$kAndroidUrl#section', assetKey: kKey),
        isTrue);
    expect(
        isAllowedLocalNavigation('$kAndroidUrl?v=2', assetKey: kKey), isTrue);
  });

  test('blocks network and lookalike schemes', () {
    for (final String url in <String>[
      'https://cdn.fusioncharts.com/fusioncharts.js',
      'http://example.com',
      'file-remote://example.com',
      'javascript:alert(1)',
      'data:text/html,<h1>x</h1>',
      'blob:file:///abc',
    ]) {
      expect(isAllowedLocalNavigation(url, assetKey: kKey), isFalse,
          reason: url);
    }
  });

  // M-3. A scheme check alone allowed every one of these, in a WebView that
  // runs JavaScript without restriction and carries this package's channel.
  test('blocks a legitimate scheme pointed at an illegitimate local target',
      () {
    for (final String url in <String>[
      'file:///data/data/other.app/databases/x.db',
      'file:///etc/passwd',
      'file:///android_asset/flutter_assets/packages/other_pkg/evil.html',
      'file:///data/local/tmp/planted.html',
      // The bundled page's own directory, but not the page itself.
      'file:///android_asset/flutter_assets/packages/flutter_fusioncharts/'
          'assets/bridge/fc_bridge.js',
      // A path that merely ends with a similar name.
      'file:///tmp/evilfc_page.html',
    ]) {
      expect(isAllowedLocalNavigation(url, assetKey: kKey), isFalse,
          reason: url);
    }
  });

  test('blocks percent-encoded traversal out of the asset path', () {
    expect(
      isAllowedLocalNavigation(
        'file:///android_asset/flutter_assets/$kKey/..%2f..%2fevil.html',
        assetKey: kKey,
      ),
      isFalse,
    );
  });

  test('refuses every file URL before an asset has been loaded', () {
    expect(isAllowedLocalNavigation(kAndroidUrl), isFalse);
    expect(isAllowedLocalNavigation(kAndroidUrl, assetKey: ''), isFalse);
    expect(isAllowedLocalNavigation('about:blank'), isTrue);
  });

  test('honours an application-supplied asset key', () {
    const String legacy = FusionChartsSource.legacyLocalAsset;
    expect(
      isAllowedLocalNavigation(
        'file:///android_asset/flutter_assets/$legacy',
        assetKey: legacy,
      ),
      isTrue,
    );
    // The default page is not allowed when a different asset was loaded.
    expect(isAllowedLocalNavigation(kAndroidUrl, assetKey: legacy), isFalse);
  });
}
