/// The FusionCharts release this package is validated against.
const String kFusionChartsVersion = '4.2.2';

/// Where the hosting page loads the FusionCharts JavaScript from.
///
/// The wrapper loads FusionCharts from Flutter assets.
enum FusionChartsSourceMode {
  /// FusionCharts is loaded from the consuming application's Flutter assets.
  asset,
}

/// Raised when a source configuration cannot be honoured.
///
/// The wrapper fails loudly rather than silently substituting a network source
/// for a requested local one, which is what the 1.x implementation did.
class FusionChartsSourceError implements Exception {
  FusionChartsSourceError(this.message);

  final String message;

  @override
  String toString() => 'FusionChartsSourceError: $message';
}

/// Declares which page the WebView host loads and which FusionCharts build it
/// is expected to contain.
///
/// Always a Flutter asset so the rendering environment stays versioned with
/// the application.
class FusionChartsSource {
  const FusionChartsSource._({
    required this.mode,
    required this.assetKey,
    required this.version,
  });

  /// The package-owned host page. **This is the default.**
  ///
  /// FusionCharts 4.2.2 and all eight themes ship inside this package, so a
  /// consuming application needs no FusionCharts assets of its own. See
  /// `doc/provenance/fusioncharts-4.2.2-manifest.json` in the package source for
  /// versions and SHA-256 hashes.
  static const String packageAsset =
      'packages/flutter_fusioncharts/assets/bridge/fc_page.html';

  /// The legacy asset layout shipped with the 1.x example application.
  ///
  /// **Legacy only**: that page references eight remote theme scripts, and two
  /// of its URLs return 404. Kept only so an application that already ships
  /// this layout can opt into it explicitly. Prefer [packageAsset].
  static const String legacyLocalAsset =
      'fusioncharts/integrate/index_local.html';

  final FusionChartsSourceMode mode;

  /// Flutter asset key of the page to load, resolved with `loadFlutterAsset`.
  final String assetKey;

  final String version;

  /// A page that loads FusionCharts from application assets.
  factory FusionChartsSource.asset({
    String assetKey = packageAsset,
    String version = kFusionChartsVersion,
  }) {
    _rejectFloatingVersion(version);
    _rejectNetworkAssetKey(assetKey);
    return FusionChartsSource._(
      mode: FusionChartsSourceMode.asset,
      assetKey: assetKey,
      version: version,
    );
  }

  /// Maps the legacy `isLocal` flag onto a source.
  ///
  /// `isLocal: true` selects the asset source. `isLocal: false` requested the
  /// removed CDN mode, so it throws rather than reaching the network; the
  /// widget converts that into a structured `onError` callback with migration
  /// guidance. Retained only for source compatibility.
  factory FusionChartsSource.fromIsLocal(bool isLocal) {
    if (!isLocal) {
      throw FusionChartsSourceError(unsupportedIsLocalFalseMessage);
    }
    return FusionChartsSource.asset();
  }

  /// Error code reported through `onError` when `isLocal: false` is used.
  static const String unsupportedSourceCode = 'unsupported-source';

  /// Migration guidance surfaced to the application developer.
  static const String unsupportedIsLocalFalseMessage =
      'isLocal: false selected the CDN runtime mode, which is not supported in '
      '2.0. Remove isLocal: false to use the FusionCharts '
      '$kFusionChartsVersion assets bundled with this package. To use an '
      'application-owned page, pass FusionChartsSource.asset(assetKey: ...); '
      "the application then owns that page's files, availability, security, "
      'licensing and versioning.';

  /// A floating version silently becomes a different build later, turning a
  /// working release into a non-reproducible one with no code change.
  static void _rejectFloatingVersion(String version) {
    if (version.trim().isEmpty || version.toLowerCase() == 'latest') {
      throw FusionChartsSourceError(
        'A floating FusionCharts version is not supported. '
        'Pin an exact version such as $kFusionChartsVersion.',
      );
    }
  }

  /// An asset key is a bundle path, never a URL. Catching this here stops a
  /// network load being introduced through the one remaining source knob.
  static void _rejectNetworkAssetKey(String assetKey) {
    final String key = assetKey.trim().toLowerCase();
    if (key.startsWith('http://') ||
        key.startsWith('https://') ||
        key.startsWith('//')) {
      throw FusionChartsSourceError(
        'assetKey must be a Flutter asset path, not a URL. The wrapper has no '
        'CDN runtime mode. To load FusionCharts over the network, ship '
        'your own HTML asset that references it; that path is unsupported.',
      );
    }
  }

  @override
  String toString() =>
      'FusionChartsSource(${mode.name}, asset: $assetKey, version: $version)';
}
