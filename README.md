# Flutter FusionCharts

The official Flutter integration for
[FusionCharts](https://www.fusioncharts.com/), including FusionTime,
FusionWidgets, PowerCharts, and FusionMaps.

Version 2 renders charts through Flutter's official `webview_flutter` package.
FusionCharts 4.2.2 is bundled with the wrapper, so consuming applications do
not need a JavaScript download step, application-side FusionCharts assets, or a
runtime CDN connection.

## Table of contents

- [Features](#features)
- [Requirements](#requirements)
- [Installation](#installation)
- [Quick start](#quick-start)
- [License key](#license-key)
- [Events](#events)
- [Controller and live updates](#controller-and-live-updates)
- [Export](#export)
- [Offline delivery](#offline-delivery)
- [Custom assets](#custom-assets)
- [Migrating from 1.x](#migrating-from-1x)
- [Troubleshooting](#troubleshooting)
- [Support and licensing](#support-and-licensing)

## Features

- Android and iOS support.
- FusionCharts 4.2.2 core, chart modules, eight themes, and the world map
  bundled as Flutter assets.
- Dynamic data updates, chart events, real-time feeds, and multiple independent
  charts on one screen.
- FusionTime, FusionWidgets, PowerCharts, and FusionMaps integration.
- Client-side export returned to the application as bytes.
- No storage permissions or network export server.

## Requirements

| Requirement | Version or platform |
|---|---|
| Dart | `>=2.18.4 <4.0.0` |
| Flutter | `>=3.3.8` |
| Platforms | Android and iOS |
| Android with Flutter 3.3.8 | API 19 or newer, compile SDK 33 or newer, JDK 17 |

Newer Flutter versions can require newer Android and iOS deployment targets.
Follow the platform requirements reported by your Flutter SDK during the build.

## Installation

Add the release candidate to your application's `pubspec.yaml`:

```yaml
dependencies:
  flutter_fusioncharts: ^2.0.0-rc.0
```

Install it:

```sh
flutter pub get
```

No FusionCharts asset declaration or JavaScript installation is required. Do
not add Android storage permissions, cleartext-traffic access, or iOS ATS
exceptions for this package.

## Quick start

Import the package and place `FusionCharts` inside a widget with a definite
height:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_fusioncharts/flutter_fusioncharts.dart';

class RevenueChart extends StatelessWidget {
  const RevenueChart({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 320,
      child: FusionCharts(
        type: 'column2d',
        dataSource: const <String, dynamic>{
          'chart': <String, dynamic>{
            'caption': 'Quarterly revenue',
            'xAxisName': 'Quarter',
            'yAxisName': 'Revenue',
            'theme': 'fusion',
          },
          'data': <Map<String, String>>[
            <String, String>{'label': 'Q1', 'value': '120'},
            <String, String>{'label': 'Q2', 'value': '150'},
            <String, String>{'label': 'Q3', 'value': '170'},
          ],
        },
        onError: (FusionChartsError error) {
          debugPrint('${error.code}: ${error.message}');
        },
      ),
    );
  }
}
```

> `FusionCharts` fills its parent. An unbounded parent can collapse the chart
> to zero height.

## License key

Pass a valid FusionCharts license key to remove the trial watermark:

```dart
FusionCharts(
  type: 'column2d',
  dataSource: data,
  licenseKey: licenseKey,
);
```

Keep production license keys out of source control. Use your application's
normal secure configuration mechanism.

## Events

Declare the FusionCharts events that the widget should forward:

```dart
FusionCharts(
  type: 'column2d',
  dataSource: data,
  events: const <String>['renderComplete', 'dataPlotClick'],
  fusionChartEvent: (dynamic senderId, dynamic eventName) {
    debugPrint('$eventName from $senderId');
  },
);
```

The callback order is `(senderId, eventName)` for compatibility with 1.x.

## Controller and live updates

Attach a controller to update data, manage event subscriptions, send real-time
data, or request exports without rebuilding the WebView:

```dart
final FusionChartsController controller = FusionChartsController();

FusionCharts(
  type: 'column2d',
  dataSource: data,
  fusionChartsController: controller,
);

controller.setData(updatedData);
controller.addEvents(<String>['chartClick']);
controller.removeEvents(<String>['chartClick']);
controller.feedData('label=Now&value=42');
```

Dispose an application-owned controller with its owning widget.
If a rebuild supplies a different controller, the old controller is detached
and the replacement controls the existing chart.

`executeScript` remains as an advanced, unsafe 1.x compatibility escape hatch.
Prefer the typed controller methods.

## Export

Export returns bytes to the application. The wrapper does not write files,
choose a destination, request storage permissions, or contact the FusionCharts
export server.

```dart
final FusionChartsController controller = FusionChartsController();

FusionCharts(
  type: 'column2d',
  dataSource: data,
  fusionChartsController: controller,
  onExport: (FusionChartsExport result) {
    // result.bytes
    // result.mimeType
    // result.suggestedFileName
    // result.format
  },
  onError: (FusionChartsError error) {
    debugPrint('${error.code}: ${error.message}');
  },
);

controller.exportChart(FusionChartsExportFormat.svg);
```

| Format | Android | iOS |
|---|---|---|
| SVG, CSV, XLSX | Supported | Supported |
| PNG, JPG, PDF | Supported | Work in progress |

PNG, JPG, and PDF export is unavailable on iOS in 2.0.0. Requests report
`export-unsupported`. Support is in progress for the next 2.0.x patch release.

## Offline delivery

The default source loads FusionCharts 4.2.2 from package-owned Flutter assets.
It makes no runtime request for FusionCharts code, themes, fonts, or export
services. Your application may still fetch chart data from its own APIs.

`isLocal: true` remains the default for source compatibility. `isLocal: false`
is deprecated and no longer enables the CDN: it reports `unsupported-source`
and initiates no load.

## Custom assets

The package includes the world map definition. Applications that need other
map definitions or a customized host page can supply an application-owned
Flutter asset:

```dart
FusionCharts(
  type: 'maps/usa',
  dataSource: data,
  source: FusionChartsSource.asset(
    assetKey: 'assets/fusioncharts_page.html',
  ),
);
```

Changing `source` during a rebuild loads the replacement asset page and renders
the chart again after that page is ready.

Declare the page and every file it references in the application's
`pubspec.yaml`:

```yaml
flutter:
  assets:
    - assets/fusioncharts_page.html
    - assets/fusioncharts/
```

The application owns the custom page's files, security, licensing, versioning,
and availability. The wrapper does not validate or maintain custom page
contents.

## Migrating from 1.x

Version 2 replaces `flutter_inappwebview`, removes the supported CDN mode and
storage-permission workflow, and bundles FusionCharts 4.2.2 directly in the
package.

Read the [1.x to 2.0 migration guide](doc/migration/1.x-to-2.0.md) before
upgrading.

## Troubleshooting

| Symptom | What to check |
|---|---|
| Blank or zero-height chart | Give the chart a bounded parent such as `SizedBox(height: 320)` |
| `unsupported-source` | Remove `isLocal: false`; the supported source is the offline package bundle |
| Android or iOS minimum-version build error | Check the `webview_flutter` versions selected by `flutter pub deps` and adopt their platform minimums |
| `export-unsupported` on iOS | Use SVG, CSV, or XLSX until the raster/PDF patch is available |
| Trial watermark | Supply a valid FusionCharts license key |

## Support and licensing

- Browse the runnable [example application](example/).
- Review the package [changelog](CHANGELOG.md).
- Read the [FusionCharts documentation](https://www.fusioncharts.com/dev/).
- Contact [FusionCharts support](https://www.fusioncharts.com/contact-support).
- Report wrapper defects in
  [GitHub Issues](https://github.com/fusioncharts/flutter-fusioncharts/issues).
- Review the [third-party notices](THIRD_PARTY_NOTICES.md) and
  [FusionCharts legal terms](https://www.ideracorp.com/legal/FusionCharts).

The [MIT License](LICENSE) covers the Flutter wrapper code. It does not cover
the bundled commercial FusionCharts JavaScript. Using FusionCharts requires an
appropriate FusionCharts license.
