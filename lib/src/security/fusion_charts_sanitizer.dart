// Input sanitisation applied at the package's trust boundaries.
//
// Two untrusted inputs cross into this package:
//
//  * the chart `dataSource`, which an application may populate from an API
//    response, a CMS, a tenant-authored template or a deep link, and
//  * the export payload posted back by the hosted page, whose file name
//    originates in chart configuration rather than in application code.
//
// Both are sanitised here rather than at each call site, so a future entry
// point cannot bypass the checks by forgetting to call them.
//
// No `library` directive: an unnamed one requires Dart 2.19, and this package
// declares a 2.18.4 floor.

/// Chart keys FusionCharts honours to route an export through a network
/// endpoint, lower-cased for case-insensitive matching.
///
/// This package delivers exports offline, capturing the bytes inside the page
/// and handing them to the application. Any of these keys arriving from an
/// untrusted `dataSource` would redirect that delivery to a host of the
/// attacker's choosing, so they are removed rather than trusted.
/// Enumerated 07-Sep-2026 by reading every `c.export*` read in the bundled
/// FusionCharts 4.2.2 core, rather than from the subset named in the security
/// review. Two of these were missed by that review:
///
///  * `html5exporthandler` is a **second alias for the export endpoint** and it
///    takes precedence: the bundle resolves the handler as
///    `pluck(c.html5exporthandler, c.exporthandler, default)`. Blocking only
///    `exporthandler` left the more powerful alias open.
///  * `exportmode` is the key that **actually selects** client, auto or server.
///    `exportatclientside` is a dead alias: the bundle maps both `1` and `0` to
///    `EXPORTMODE.AUTO`, which is also the default when it is absent, so it
///    cannot change the mode at all.
///
/// `exportparameters` is included because it is appended to the server request.
/// `exportcallback`, `exportfilename`, `exportformat`, `exportenabled`,
/// `exportshowmenuitem` and `exportwithimages` are deliberately left alone:
/// none of them selects a destination. `exportfilename` is handled instead by
/// sanitising the delivered name, see [sanitizeExportFileName].
const Set<String> kBlockedExportKeys = <String>{
  'exportaction',
  'exporthandler',
  'html5exporthandler',
  'exportmode',
  'exportparameters',
  'exporttargetwindow',
  'exportatclientside',
};

/// Removes every key in [kBlockedExportKeys] from [source], at any depth.
///
/// The keys are legal inside `chart`, `dataset`, `data`, `annotations` and
/// `trendlines`, so a top-level pass is not sufficient. Matching is
/// case-insensitive because FusionCharts accepts either casing.
///
/// Returns a deep copy. The caller's map is never mutated, so an application
/// that renders the same configuration into two charts sees no side effect.
///
/// [onStripped] receives the dotted **key path only**, never the value. A
/// credential planted in a hostile configuration must not be able to reach the
/// application's logs through this diagnostic.
///
/// Nothing is substituted for a removed key. Stripping alone restores
/// FusionCharts' own default behaviour, which the bridge already handles;
/// injecting a replacement value here risked changing chart semantics for
/// `timeseries`, whose `dataSource` shape differs.
Map<String, dynamic> sanitizeDataSource(
  Map<String, dynamic> source, {
  void Function(String keyPath)? onStripped,
}) {
  final Object? scrubbed = _scrub(source, '', onStripped);
  if (scrubbed is Map<String, dynamic>) {
    return scrubbed;
  }
  return <String, dynamic>{};
}

/// Whether [source] still carries any network-capable export key.
///
/// Intended for application-side assertions and for tests.
bool containsBlockedExportKeys(Object? source) {
  if (source is Map) {
    for (final Object? key in source.keys) {
      if (kBlockedExportKeys.contains(key.toString().toLowerCase())) {
        return true;
      }
      if (containsBlockedExportKeys(source[key])) {
        return true;
      }
    }
    return false;
  }
  if (source is List) {
    for (final Object? item in source) {
      if (containsBlockedExportKeys(item)) {
        return true;
      }
    }
  }
  return false;
}

Object? _scrub(
  Object? node,
  String path,
  void Function(String keyPath)? onStripped,
) {
  if (node is Map) {
    final Map<String, dynamic> out = <String, dynamic>{};
    for (final Object? rawKey in node.keys) {
      final String key = rawKey.toString();
      final String childPath = path.isEmpty ? key : '$path.$key';
      if (kBlockedExportKeys.contains(key.toLowerCase())) {
        onStripped?.call(childPath);
        continue;
      }
      out[key] = _scrub(node[rawKey], childPath, onStripped);
    }
    return out;
  }
  if (node is List) {
    final List<dynamic> out = <dynamic>[];
    for (int i = 0; i < node.length; i += 1) {
      out.add(_scrub(node[i], '$path[$i]', onStripped));
    }
    return out;
  }
  // Strings, numbers, booleans and null are copied by value.
  return node;
}
