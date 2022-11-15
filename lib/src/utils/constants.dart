String jsIntegrationFolder = "packages/flutter_fusioncharts/js_integration/index.html";
String jsRootLatest = 'packages/flutter_fusioncharts/assets/latest';
String jsRoot317 = 'packages/flutter_fusioncharts/assets/js_3.17';
String jsRoot318 = 'packages/flutter_fusioncharts/assets/js_3.18';

String registerEvents = """
    var myEventListener = function(eventObj, eventArgs) {
    console.log(
    eventObj.eventType +
    " was raised by the chart whose ID is " +
    eventObj.sender.id);

    const args = [ eventObj.sender.id, eventObj.eventType];
    console.log(args);
    window.flutter_inappwebview.callHandler('eventHandler', ...args);
    console.log('handle');
    
    };

    fusionChart.addEventListener("initialized", myEventListener);
    fusionChart.addEventListener("dataUpdated", myEventListener);
    fusionChart.addEventListener("renderComplete", myEventListener);
    fusionChart.addEventListener("disposed", myEventListener);
    fusionChart.addEventListener("labelRollOver", myEventListener);
    fusionChart.addEventListener("centerLabelClick", myEventListener);
""";
