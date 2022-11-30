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

function addChartEvents(events) {
    var arrayEvents = events.split(",");
    globalFusionCharts.addEventListener(arrayEvents, chartAddEventsListener);
    console.log("Events added successfully!!", arrayEvents);
}

function removeChartEvents(removeEvents) {
    var arrayRemoveEvents = removeEvents.split(",");
    globalFusionCharts.removeEventListener(
        arrayRemoveEvents,
        chartAddEventsListener
    );
    console.log("Events removed successfully!!", removeEvents);
}

