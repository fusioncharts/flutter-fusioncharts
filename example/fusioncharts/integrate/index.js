function chartAddEventsListener(eventObj, eventArgs) {
  console.log(
    eventObj.eventType +
      " was raised by the chart whose ID is " +
      eventObj.sender.id
  );
  const args = [eventObj.sender.id, eventObj.eventType];
  console.log(args);
  window.flutter_inappwebview.callHandler("fusionChartEventHandler", ...args);
  console.log("handle this events");
}
//This function listens for FC events for charts in string or comma separated string form
//from existing chart dart file and adds them to the existing chart
//and return event object type and chart id when we click to trigger the action(add event button).
function addChartEvents(events) {
  var arrayEvents = events.split(",");
  globalFusionCharts.addEventListener(arrayEvents, chartAddEventsListener);
  console.log("Events added successfully!!", arrayEvents);
}
//It is used to remove existing FC events for a chart in string or comma separated string form
//and after that which those FC events will not work
//when we click to trigger the action(remove event button).
function removeChartEvents(removeEvents) {
  var arrayRemoveEvents = removeEvents.split(",");
  globalFusionCharts.removeEventListener(
    arrayRemoveEvents,
    chartAddEventsListener
  );
  console.log("Events removed successfully!!", removeEvents);
}

function executeAPI(js) {
  console.log("Executing API: " + js + globalFusionCharts.chartType());
  eval(js);
  console.log("Executing API: " + js + globalFusionCharts.chartType());
}
