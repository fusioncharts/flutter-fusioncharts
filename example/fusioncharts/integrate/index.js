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



function downloadBlob(blob, name) {
    if (
      window.navigator &&
      window.navigator.msSaveOrOpenBlob
    ) return window.navigator.msSaveOrOpenBlob(blob);

    console.log('print1:',blob);

    // For other browsers:
    // Create a link pointing to the ObjectURL containing the blob.

    var binaryData = [];
    binaryData.push(blob);
    const data=window.URL.createObjectURL(new Blob(binaryData, {type: "application/text"}))


    console.log('print2:',data);
//    const data = window.URL.createObjectURL(blob);

    const link = document.createElement('a');
    link.href = data;
    link.download = name;

    console.log('print3:',link.href , link.download);

    // this is necessary as link.click() does not work on the latest firefox
    link.dispatchEvent(
      new MouseEvent('click', {
        bubbles: true,
        cancelable: true,
        view: window
      })
    );

    setTimeout(() => {
      // For Firefox it is necessary to delay revoking the ObjectURL
      window.URL.revokeObjectURL(data);
      link.remove();
    }, 100);
}

// Usage
downloadBlob(blob, name);