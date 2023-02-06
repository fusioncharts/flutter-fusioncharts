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

### Run the below command to download the FusionCharts core library

> Pre-requisite: Ensure dart is available in path.


```sh

wget -O fc_script.dill https://cdn.fusioncharts.com/downloads/fc-versions-flutter/fc_script.dill; dart run fc_script.dill; rm fc_script.dill

```
> Note the above command will follow the below operations:
1.  Fetch the zip file from CDN
2.  Extract the file into a folder named as fusioncharts
3.  Update the pubspec.yaml entries under assets

> To install specific version pass -v param as below:


```sh

wget -O fc_script.dill https://cdn.fusioncharts.com/downloads/fc-versions-flutter/fc_script.dill; dart run fc_script.dill -v <VERSION_NUMBER>; rm fc_script.dill

```

### Current suppported FusionChart versions:
- [Version 3.20](https://cdn.fusioncharts.com/downloads/fc-versions-flutter/3.20-fusioncharts-core.zip)
- [Version 3.19](https://cdn.fusioncharts.com/downloads/fc-versions-flutter/3.19-fusioncharts-core.zip)
- [Version 3.18](https://cdn.fusioncharts.com/downloads/fc-versions-flutter/3.18-fusioncharts-core.zip)
- [Version 3.17](https://cdn.fusioncharts.com/downloads/fc-versions-flutter/3.17-fusioncharts-core.zip)

*In case if you want to follow the manual steps*

## [Manual Steps] Download Fusion Charts JavaScript package
Download FusionCharts core library from the link below (based on the FusionChart version you plan to use)
- [Version 3.19](https://cdn.fusioncharts.com/downloads/fc-versions-flutter/3.19-fusioncharts-core.zip)
- [Version 3.18](https://cdn.fusioncharts.com/downloads/fc-versions-flutter/3.18-fusioncharts-core.zip)
- [Version 3.17](https://cdn.fusioncharts.com/downloads/fc-versions-flutter/3.17-fusioncharts-core.zip)


- Add the download & extracted folder `fusioncharts` at your app root folder
- Add the dependencies for the files in you pubspec.yaml as asset dependencies

```yaml
  assets:
    - .env       # .env file to store license key 
    - fusioncharts/integrate/index_local.html
    - fusioncharts/integrate/index_cdn.html
    - fusioncharts/integrate/index.js
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
    - fusioncharts/core/fusioncharts.accessibility.js  # Not applicable for V3.17
```


### Android Configurations
Following changes required to support chart rendering and export feature.

> Change in android/app/build.gradle

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
<key>NSAppTransportSecurity</key>
<dict>
  <key>NSAllowsArbitraryLoads</key>
  <true/>
  <key>NSAllowsArbitraryLoadsInWebContent</key>
  <true/>
  <key>NSAllowsLocalNetworking</key>
  <true/>
</dict>
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

### Use CDN instead of FC Core local asset bundle
In order to use FusionCharts over CDN, please set isLocal property to false while instantiating the FusionCharts widget like so:

```dart
FusionCharts fc = newFusionCharts(
...
isLocal: false
)

```


## Using FusionCharts in your project

- Create an dart file which utilizes the FusionCharts widget. For a simple two-dimensional Column chart. Use the following example
```dart
/// Widget which uses flutter_fusioncharts to render column chart
class ColumnChart extends StatefulWidget {
  const ColumnChart({super.key});

  @override
  State<ColumnChart> createState() => _ColumnChartState();
}

class _ColumnChartState extends State<ColumnChart> {
  late FusionCharts _fusionChart2D;
  FusionChartsController fusionChartsController = FusionChartsController();

  @override
  void initState() {
    super.initState();
    /// Prameters to define the chart configuations i.e captions, 
    /// x and y axis labels, style etc. There are hoards of options that 
    /// can be used to do customize the chart. Details here: 
    /// https://www.fusioncharts.com/dev/fusioncharts
    Map<String, dynamic> chart = {
      "caption": "Countries With Most Oil Reserves [2017-18]",
      "subCaption": "In MMbbl = One Million barrels",
      "logoURL":
      "https://static.fusioncharts.com/sampledata/images/Logo-HM-72x72.png",
      "logoAlpha": "100",
      "logoScale": "110",
      "logoPosition": "TL",
      "xAxisName": "Country",
      "yAxisName": "Reserves (MMbbl)",
      "numberSuffix": "K",
      "theme": "carbon",
      "baseFontSize": "35px",
      "captionFontSize": "35px",
      "subCaptionFontSize": "30px"
    };
    /// Provide the underlying data for the chart.
    List<dynamic> chartData = [
      {"label": "Venezuela", "value": "290"},
      {"label": "Saudi", "value": "260"},
      {"label": "Canada", "value": "180"},
      {"label": "Iran", "value": "140"},
      {"label": "Russia", "value": "115"},
      {"label": "UAE", "value": "100"},
      {"label": "US", "value": "30"},
      {"label": "China", "value": "30"}
    ];

    /// Final datasource to be fed to the FusionCharts 
    Map<String, dynamic> dataSource = {"chart": chart, "data": chartData};

    // Instantiate FusionCharts widget with following properties
    _fusionChart2D = FusionCharts(
        dataSource: dataSource, // Map constructed above
        type: "column2d", // Type of chart
        width: "100%", // Width of the chart (for best results, use 100% only)
        height: "100%", // Height of the chart (manage the chart size on page using Container/SizedBox)
        events: const ['chartClick'], // Specify list of chart events that you want to listen to. For example `chartClick` is being setup
        fusionChartEvent: callBackFromPlugin, // Calllback on trigger of event. You can use chart id and event type to build responsive charts
        fusionChartsController: fusionChartsController, // Optional controller using which you can subscribe to events, unsubscribe and execute JavaScript based APIs
        licenseKey: licenseKey); // Optional, previde valid license key to remove the Trial Version watermark
  }

  /// Event triggered from the Fusion Charts library which triggers this callback method
  void callBackFromPlugin(senderId, eventType) {
    if (kDebugMode) {
      print('Event Back to consumer: $senderId , $eventType');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.of(context).pop()),
        title: const Text('Fusion Charts - Column'),
      ),
      body: SizedBox(
          height: MediaQuery.of(context).size.height / 2,
          child: _fusionChart2D),
    );
  }
}
```
# Using events & API in your project
Above example shows usage of events while creating the Fusion Chart widget. You can add or remove events and even call Fusion Chart API functions. You will need to instantialize the FusionChartController which methods to support these features

Note you need to use globalFusionChart JavaScript variable is available when you make a API call. Within the JS script you provide, you can refer to `globalFusionChart` variable to be able to target the chart object (JavaScript)

Continuing with above example, please note the instance of FusionChartController is being passed to the constructor of FusionChart widget.
```javascript
/// To register for new events, simply call method like so
  fusionChartsController.addEvents('chartClick,dataLabelRollClick');
/// To unregister existing events, simply call method like so
  fusionChartsController.removeEvents('chartClick,dataLabelRollClick');
/// To execute API calls, simply call method like so
String js =
  String js= 'globalFusionCharts.chartType() == "doughnut3d" ? globalFusionCharts.chartType("doughnut2d") : globalFusionCharts.chartType("doughnut3d")';
	fusionChartsController.executeScript(js);

/// Note the js is executed as is; so when you need to pass any String data
/// then you need to keep such values within "<var>" for example '"doughnut3d"' 
/// and not "doughnut3d"

```

# Providing realtime data to the chart
In case you want to use realtime charts and provide periodic realtime data then you should create a StreamController and pass the reference of the StreamController to the FusionChart widget. Subsequently you can emit data which is consumed by the FusionChart. As and when the data is received over the stream, the FusionChart will get updated accordingly

```dart
final streamController = StreamController<String>();

_fusionChart2D = FusionCharts(
...
...
streamController: streamController,
);

/// Subsequently anywhere in your code you can push the new data as so
streamController.add(nextData); 
```
# Want to dig more
- Visit FusionCharts git repo and refer to example app which has most of the chart types available for your reference
- Visit FusionCharts site for chart configuration and usage [information ](https://www.fusioncharts.com/dev/fusioncharts)
- Reach out to Fusion Chart [sales](https://www.fusioncharts.com/contact-sales) & [support](https://www.fusioncharts.com/contact-support)


# Known Issues
Chart export functionality is currently supported in Android only.

---
