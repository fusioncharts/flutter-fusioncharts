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

function executeAPI(js) {
    console.log("Executing API: " + js + globalFusionCharts.chartType());
    eval(js);
    // globalFusionCharts.chartType('doughnut2d')
    console.log("Executing API: " + js + globalFusionCharts.chartType());
}



// async function loadFusionCharts(cdn) {
//     const existingScript = document.getElementById('fc-plugin');
//     if (cdn == 'CDN') {
//         if (!existingScript) {
//             const script = document.createElement('script');
//             script.src = 'https://cdn.fusioncharts.com/fusioncharts/latest/fusioncharts.js';
//             script.id = 'fc-plugin';
//             document.body.appendChild(script);

//             const style = document.createElement('script');
//             style.src = 'https://cdn.fusioncharts.com/fusioncharts/latest/fusioncharts.js';
//             style.id = 'fc-style';
//             document.body.appendChild(style);


//         }
//     } else {
//         if (!existingScript) {
//             const script = document.createElement('script');
//             script.src = '../core/fusioncharts.js';
//             script.id = 'fc-plugin';
//             document.body.appendChild(script);

//             const style = document.createElement('script');
//             style.src = '../core/themes/fusioncharts.theme.fusion.js';
//             style.id = 'fc-style';
//             document.body.appendChild(style);

//         }

//     }

//     script.onload = async () => {
//         console.log('FC Loaded CDN');
//         return await Promise.resolve(true);
//     }
//     return await Promise.resolve(false);
// };