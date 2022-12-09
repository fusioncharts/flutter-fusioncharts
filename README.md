# flutter_fusioncharts

[<img src="https://www.fusioncharts.com/dist/fusioncharts-idera-logo.svg" width="234px" alt="FusionCharts - Build beautiful web & mobile dashboards">](https://www.fusioncharts.com/)


FusionCharts is a JavaScript charting library providing 100+ charts and 2,000+ maps for your web and mobile applications. All the visualizations are interactive and animated, which are rendered using webview. This plugin provides Flutter interface which integrates with FC Core JavaScript library using webview.

This package also contains FusionTime (timeseries charts), FusionWidgets (gauges, real-time charts), PowerCharts (statistical and advanced charts), and FusionMaps (choropleth geo maps).

- Official Website: [https://www.fusioncharts.com/](https://www.fusioncharts.com/)
- Documentation: [https://www.fusioncharts.com/dev/](https://www.fusioncharts.com/dev/)
- Licensing: [Legal Terms & Customer Agreements](https://www.ideracorp.com/legal/FusionCharts#tabs-2)
- Support: [https://www.fusioncharts.com/contact-support](https://www.fusioncharts.com/contact-support)


## Getting Started

### Add dependency

```yaml
dependencies:
  flutter_fusioncharts: ^1.0.0
```
Now in your Dart code import the plugin file

```dart
import 'package:flutter_fusioncharts/flutter_fusioncharts.dart';

```

### Download Fusion Charts JavaScript package

This plugin supports FC Core versions 3.17, 3.18 and 3.19 The installation process requires you to download the FC Core package from either of the below locations based on the FC Core version as per your requirement.

- 3.19: https://fusioncharts/tbd/3.19
- 3.18: https://fusioncharts/tbd/3.18
- 3.17: https://fusioncharts/tbd/3.17

Copy the downloaded fusioncharts folder and paste under your project root (parallel to lib). The downloaded folder contains contains following folders:
- core: Fusion Charts core JS library
- integrate: Files used for webview integration

Add the downloaded folder files as assets dependency within your pubspec.yaml file

```yaml
  assets:
    - fusioncharts/integrate/index.html
    - fusioncharts/integrate/index.js
    - fusioncharts/core/maps/fusioncharts.usa.js
    - fusioncharts/core/maps/fusioncharts.india.js
    - fusioncharts/core/maps/readme.txt
    - fusioncharts/core/maps/fusioncharts.world.js
    - fusioncharts/core/fusioncharts.charts.js
    - fusioncharts/core/fusioncharts.overlappedbar2d.js
    - fusioncharts/core/fusioncharts.timeseries.js
    - fusioncharts/core/fusioncharts.treemap.js
    - fusioncharts/core/fusioncharts.powercharts.js
    - fusioncharts/core/fusioncharts.maps.js
    - fusioncharts/core/fusioncharts.zoomscatter.js
    - fusioncharts/core/fusioncharts.js
    - fusioncharts/core/fusioncharts.excelexport.js
    - fusioncharts/core/fusioncharts.widgets.js
    - fusioncharts/core/fusioncharts.zoomline.js
    - fusioncharts/core/fusioncharts.gantt.js
    - fusioncharts/core/fusioncharts.overlappedcolumn2d.js
    - fusioncharts/core/fusioncharts.vml.js
    - fusioncharts/core/themes/fusioncharts.theme.fusion.js
    - fusioncharts/core/themes/fusioncharts.theme.umber.js
    - fusioncharts/core/themes/fusioncharts.theme.candy.js
    - fusioncharts/core/themes/fusioncharts.theme.zune.js
    - fusioncharts/core/themes/fusioncharts.theme.ocean.js
    - fusioncharts/core/themes/fusioncharts.theme.gammel.js
    - fusioncharts/core/themes/fusioncharts.theme.fint.js
    - fusioncharts/core/themes/fusioncharts.theme.carbon.js
```


### Android Configurations
Following changes required to support chart rendering and export feature.

> Change in android/src/build.gradle

```
...
compileSdkVersion 33
...
minSdkVersion 17
...

```

> Change in android/src/main/AndroidManifest.xml

```
...
    <uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE"/>
    <uses-permission android:name="android.permission.ACCESS_MEDIA_LOCATION"/>
    <uses-permission android:name="android.permission.MANAGE_EXTERNAL_STORAGE"/>
    <uses-permission android:name="android.permission.INTERNET"/>
...

android:usesCleartextTraffic="true" // Under application/activity tag
android:requestLegacyExternalStorage="true"

```

### iOS Configurations

> info.plist: Add below entry
``` 
<key>NSPhotoLibraryUsageDescription</key>
    <string>Fusion Charts requires media storage permission to enable charts export feature.</string>

```
   
> podfile: Add GCC_PREPROCESSOR_DEFINITIONS configuration as below

```
post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['GCC_PREPROCESSOR_DEFINITIONS'] ||= [
      '$(inherited)',
      'PERMISSION_PHOTOS=1',
      ]
    end
    flutter_additional_ios_build_settings(target)
  end
end
```
