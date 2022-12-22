// chartAddEventsListener function implements a callback method to event listener for events emitting from Fusion Charts
// The user needs to subscribe to event types and on occurance of such event this listener fuction callback is triggered.
// The callback receive event object which contains the caller chart id & eventy type and
// finally this fuction invokes the callback function on the Flutter side using fusionChartEventHandler callback

function chartAddEventsListener(eventObj, eventArgs) {

  const args = [eventObj.sender.id, eventObj.eventType];
  window.flutter_inappwebview.callHandler("fusionChartEventHandler", ...args);
}

// addChartEvents function is called from Flutter side to register event(s).
// The flutter program should send a events string as parameter which may have a 
// single or multiple comma seperated events

function addChartEvents(events) {
  var arrayEvents = events.split(",");
  globalFusionCharts.addEventListener(arrayEvents, chartAddEventsListener);
}

// removeChartEvents function is called from Flutter side to un-register event(s).
// The flutter program should send a events string as parameter which may have a 
// single or multiple comma seperated events

function removeChartEvents(removeEvents) {
  var arrayRemoveEvents = removeEvents.split(",");
  globalFusionCharts.removeEventListener(
    arrayRemoveEvents,
    chartAddEventsListener
  );
  console.log("Events removed successfully!!", removeEvents);
}
