String fcHome = 'fusioncharts';

String registerEvents = """
    var fcEventListener = function(eventObj, eventArgs) {
      console.log(
      eventObj.eventType +
        " was raised by the chart whose ID is " +
        eventObj.sender.id);

      const args = [ eventObj.sender.id, eventObj.eventType];
      console.log(args);
      window.flutter_inappwebview.callHandler('fusionChartEventHandler', ...args);
      console.log('handle');
    
    };
    globalFusionCharts.addEventListener("initialized", fcEventListener);
    globalFusionCharts.addEventListener("dataUpdated", fcEventListener);
    globalFusionCharts.addEventListener("renderComplete", fcEventListener);
    globalFusionCharts.addEventListener("disposed", fcEventListener);
    globalFusionCharts.addEventListener("labelRollOver", fcEventListener);
    globalFusionCharts.addEventListener("centerLabelClick", fcEventListener);
""";
