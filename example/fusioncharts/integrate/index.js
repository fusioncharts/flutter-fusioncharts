console.log("TestJS");

var fcEventListener = function (eventObj, eventArgs) {
    console.log(
        eventObj.eventType +
        " was raised by the chart whose ID is " +
        eventObj.sender.id);

    const args = [eventObj.sender.id, eventObj.eventType];
    console.log(args);
    window.flutter_inappwebview.callHandler('fusionChartEventHandler', ...args);
    console.log('handle');

};

function registerEvents(args) {
    // args.forEach(event => {
    //     globalFusionChart
    // });
}
