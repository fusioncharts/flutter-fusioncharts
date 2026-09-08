## 2.0.0-rc.0

### Added

* Add structured source, error, data-update, readiness, and byte-based export
  APIs.

### Changed

* Move to `webview_flutter` and bundle FusionCharts 4.2.2 with the World and USA
  maps.
* Return export bytes to the application. Android supports all formats; iOS
  supports SVG, CSV, and XLSX.

### Breaking changes

* Require Flutter 3.3.8+ and Dart 2.18.4+.
* Remove `setWebViewController`; `isLocal: false` no longer loads from the CDN.
* Remove `flutter_inappwebview`, `permission_handler`, `path_provider`, and
  `pdf`.
* See the [migration guide](doc/migration/1.x-to-2.0.md) for upgrade steps.

### Security

* Add a validated, versioned JSON bridge and remove wrapper-owned file writes
  and storage-permission requirements.
* Restrict WebView navigation to the asset actually loaded, rather than to any
  `file:` URL.
* Strip network-capable export keys from the chart configuration, including the
  `html5exporthandler` and `exportmode` aliases that select the export endpoint.
* Sanitise the page-supplied export file name so it cannot escape a directory it
  is joined to.
* Address the known OSV advisories in the dependency graph.

## 1.0.2

* Updated the Version 1 example.

## 1.0.1

* Updated the Version 1 example.

## 1.0.0

* Released Version 1 with an updated example.

## 0.0.2

* Updated documentation.

## 0.0.1

* Initial release with FusionCharts, FusionTime, FusionWidgets, PowerCharts,
  and FusionMaps support.
