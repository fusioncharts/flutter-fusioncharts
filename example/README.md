# Flutter FusionCharts example

This app demonstrates the chart gallery included with `flutter_fusioncharts`.
FusionCharts JavaScript, maps, themes, and fonts are bundled with the package and
run offline; no separate download or CDN setup is required.

## Run the example

Requirements:

- Flutter 3.3.8 or later
- An Android or iOS development environment

From this directory, run:

```sh
flutter pub get
flutter run
```

This gallery uses the current Flutter Android project structure. Independent
minimal harnesses under [`compatibility`](compatibility) retain the native
projects for the Flutter 3.3.8 floor and Flutter 3.41.9 PRD target.

The committed `license.env.example` contains an empty `LICENSE_KEY`, so the
gallery runs with a trial watermark. For licensed local testing, add your key
through your own uncommitted secret-management workflow. Never commit a real
license key.

For package setup and API usage, see the
[main README](https://github.com/fusioncharts/flutter-fusioncharts#readme).
Report problems through the
[issue tracker](https://github.com/fusioncharts/flutter-fusioncharts/issues).
