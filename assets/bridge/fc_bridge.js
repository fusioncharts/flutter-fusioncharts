/*
 * Package-owned FusionCharts bridge, protocol version 1.
 *
 * Injected by the Dart side after the hosting page finishes loading, so a
 * consumer's existing integration HTML keeps working without edits.
 *
 * Deliberately ES5: the declared Android floor is minSdkVersion 19, whose
 * system WebView predates arrow functions, let/const and template literals.
 *
 * Every value that originates with the app arrives here already parsed from
 * JSON. Nothing in this file builds JavaScript source by string concatenation.
 */
(function () {
  'use strict';

  var PROTOCOL_VERSION = 1;
  var CHANNEL = 'FusionChartsBridge';

  if (window.__fcBridgeInstalled) {
    return;
  }
  window.__fcBridgeInstalled = true;

  /* chartId -> FusionCharts instance. Replaces the globalFusionCharts
     singleton, which made two charts on one screen overwrite each other. */
  var charts = {};
  /* chartId -> { eventName: handler } so removeEvents can detach precisely. */
  var handlers = {};

  function post(type, chartId, payload, requestId) {
    var envelope = {
      protocolVersion: PROTOCOL_VERSION,
      chartId: chartId,
      type: type,
      payload: payload || {}
    };
    if (requestId) {
      envelope.requestId = requestId;
    }
    try {
      window[CHANNEL].postMessage(JSON.stringify(envelope));
    } catch (e) {
      /* The channel is the only route back to Dart. If it is missing there is
         nowhere to report the failure, so drop it rather than throw into the
         page and break chart rendering. */
    }
  }

  function postError(chartId, code, message, requestId) {
    post('error', chartId, { code: code, message: String(message) }, requestId);
  }

  function fusionChartsVersion() {
    try {
      if (typeof FusionCharts !== 'undefined' &&
          typeof FusionCharts.getVersion === 'function') {
        return String(FusionCharts.getVersion('fcs'));
      }
    } catch (e) {
      /* Report an empty version below; Dart turns that into a structured
         runtime-version-missing error instead of trusting the asset label. */
    }
    return '';
  }

  function containerIdFor(chartId) {
    return 'fc-container-' + chartId;
  }

  /* The hosting page owns a single #chart-container in the legacy layout. Give
     each chart its own child element so instances stay isolated. */
  function ensureContainer(chartId) {
    var id = containerIdFor(chartId);
    var existing = document.getElementById(id);
    if (existing) {
      return id;
    }
    var host = document.getElementById('chart-container') || document.body;
    if (host && host.id === 'chart-container') {
      host.innerHTML = '';
    }
    var el = document.createElement('div');
    el.id = id;
    el.style.width = '100%';
    el.style.height = '100%';
    host.appendChild(el);
    return id;
  }

  function makeEventHandler(chartId) {
    return function (eventObj, eventArgs) {
      var name = eventObj && eventObj.eventType ? eventObj.eventType : 'unknown';
      var senderId = eventObj && eventObj.sender ? eventObj.sender.id : null;
      /* eventArgs can carry arbitrary chart state. Pass it through JSON so the
         Dart side receives data, never executable text. */
      var safeArgs = {};
      try {
        safeArgs = JSON.parse(JSON.stringify(eventArgs || {}));
      } catch (e) {
        safeArgs = {};
      }
      post('event', chartId, {
        eventName: name,
        senderId: senderId,
        args: safeArgs
      });
    };
  }

  function render(chartId, payload, requestId) {
    if (typeof FusionCharts === 'undefined') {
      postError(chartId, 'fusioncharts-missing',
        'FusionCharts is not loaded in this page', requestId);
      return;
    }

    if (payload.licenseKey) {
      try {
        FusionCharts.options.license({
          key: payload.licenseKey,
          creditLabel: false
        });
      } catch (e) {
        postError(chartId, 'license-failed', e, requestId);
      }
    }

    var containerId = ensureContainer(chartId);
    var config = {
      type: payload.type,
      width: payload.width || '100%',
      height: payload.height || '100%',
      renderAt: containerId,
      dataFormat: 'json',
      dataSource: payload.dataSource || {}
    };

    try {
      if (payload.type === 'timeseries' && payload.timeSeriesData &&
          payload.timeSeriesSchema) {
        var store = new FusionCharts.DataStore();
        config.dataSource.data =
          store.createDataTable(payload.timeSeriesData, payload.timeSeriesSchema);
      }

      var chart = new FusionCharts(config);
      charts[chartId] = chart;
      handlers[chartId] = handlers[chartId] || {};

      chart.render();

      if (payload.events && payload.events.length) {
        addEvents(chartId, { events: payload.events });
      }
      post('ready', chartId, {
        containerId: containerId,
        fusionChartsVersion: fusionChartsVersion()
      }, requestId);
    } catch (e) {
      postError(chartId, 'render-failed', e, requestId);
    }
  }

  function update(chartId, payload, requestId) {
    var chart = charts[chartId];
    if (!chart) {
      postError(chartId, 'unknown-chart', 'no chart for this id', requestId);
      return;
    }
    try {
      if (payload.dataSource) {
        chart.setJSONData(payload.dataSource);
      }
      if (payload.type) {
        chart.chartType(payload.type);
      }
      if (payload.width || payload.height) {
        chart.resizeTo(payload.width, payload.height);
      }
      post('ready', chartId, { updated: true }, requestId);
    } catch (e) {
      postError(chartId, 'update-failed', e, requestId);
    }
  }

  function addEvents(chartId, payload) {
    var chart = charts[chartId];
    if (!chart) {
      postError(chartId, 'unknown-chart', 'no chart for this id');
      return;
    }
    var names = payload.events || [];
    handlers[chartId] = handlers[chartId] || {};
    for (var i = 0; i < names.length; i++) {
      var name = names[i];
      if (handlers[chartId][name]) {
        continue;
      }
      var handler = makeEventHandler(chartId);
      handlers[chartId][name] = handler;
      try {
        chart.addEventListener(name, handler);
      } catch (e) {
        postError(chartId, 'add-event-failed', e);
      }
    }
  }

  function removeEvents(chartId, payload) {
    var chart = charts[chartId];
    var registered = handlers[chartId];
    if (!chart || !registered) {
      return;
    }
    var names = payload.events || [];
    for (var i = 0; i < names.length; i++) {
      var name = names[i];
      var handler = registered[name];
      if (!handler) {
        continue;
      }
      try {
        chart.removeEventListener(name, handler);
      } catch (e) {
        postError(chartId, 'remove-event-failed', e);
      }
      delete registered[name];
    }
  }

  function feedData(chartId, payload) {
    var chart = charts[chartId];
    if (!chart) {
      return;
    }
    try {
      chart.feedData(payload.data);
    } catch (e) {
      postError(chartId, 'feed-failed', e);
    }
  }

  function disposeChart(chartId) {
    var chart = charts[chartId];
    if (chart) {
      try {
        if (typeof chart.dispose === 'function') {
          chart.dispose();
        }
      } catch (e) {
        /* disposal is best effort; the element removal below is what matters */
      }
    }
    delete charts[chartId];
    delete handlers[chartId];
    var el = document.getElementById(containerIdFor(chartId));
    if (el && el.parentNode) {
      el.parentNode.removeChild(el);
    }
  }


  /* ------------------------------------------------- export byte capture ----
     FusionCharts' client-side export ends in a browser download: an <a> with a
     data: URL for image/PDF formats, or a Blob for csv/xlsx. Neither ever
     reaches Dart on its own. These hooks take the payload one layer earlier, in
     the page, and suppress the download so nothing is written by the browser.

     This is the same payload route 1.x used. 1.x read the data: URL out of
     flutter_inappwebview's onDownloadStartRequest event; that event only ever
     carried a URL, never bytes, so capturing the URL here is equivalent and
     needs no WebView-specific API. */

  var pendingExport = null;

  function deliverExport(mime, fileName, base64, via) {
    if (!pendingExport) { return false; }
    var pe = pendingExport;
    pendingExport = null;
    post('export', pe.chartId, {
      format: pe.format,
      mime: mime || 'application/octet-stream',
      fileName: fileName || ('chart.' + pe.format),
      base64: base64,
      via: via
    }, pe.requestId);
    return true;
  }

  function captureDataUrl(href, fileName, via) {
    var comma = href.indexOf(',');
    if (comma < 0) { return false; }
    var meta = href.slice(5, comma);
    var mime = meta.split(';')[0];
    var body = href.slice(comma + 1);
    if (meta.indexOf('base64') < 0) {
      try { body = btoa(unescape(body)); } catch (e) { return false; }
    }
    return deliverExport(mime, fileName, body, via);
  }

  var _click = HTMLAnchorElement.prototype.click;
  HTMLAnchorElement.prototype.click = function () {
    var href = this.href || '';
    if (pendingExport && href.indexOf('data:') === 0) {
      if (captureDataUrl(href, this.getAttribute('download'), 'anchor')) {
        return; /* suppress the browser download */
      }
    }
    return _click.apply(this, arguments);
  };

  /* Hook the Blob constructor too, not just createObjectURL.
     FusionCharts builds the csv/xlsx payload as a Blob and, on iOS, hands it
     straight to a form POST without ever calling createObjectURL - so a
     createObjectURL-only hook never sees it. Phase 0 captured this payload by
     hooking the constructor; this does the same, and only while an export is
     actually in flight. */
  var _Blob = window.Blob;
  if (typeof _Blob === 'function') {
    window.Blob = function (parts, options) {
      var b = new _Blob(parts || [], options || {});
      if (pendingExport && !pendingExport.captured &&
          typeof FileReader !== 'undefined' && b.size) {
        pendingExport.captured = true;
        try {
          var fr = new FileReader();
          var mime = (options && options.type) || b.type || '';
          fr.onloadend = function () {
            var str = String(fr.result);
            var c = str.indexOf(',');
            if (c >= 0) {
              deliverExport(mime, null, str.slice(c + 1), 'blob-ctor');
            }
          };
          fr.readAsDataURL(b);
        } catch (e) { /* watchdog reports */ }
      }
      return b;
    };
    window.Blob.prototype = _Blob.prototype;
  }

  var _createObjectURL = URL.createObjectURL;
  URL.createObjectURL = function (obj) {
    var url = _createObjectURL.apply(URL, arguments);
    if (pendingExport && obj && obj.size !== undefined &&
        typeof FileReader !== 'undefined') {
      try {
        var fr = new FileReader();
        var mime = obj.type || '';
        fr.onloadend = function () {
          var s = String(fr.result);
          var c = s.indexOf(',');
          if (c >= 0) { deliverExport(mime, null, s.slice(c + 1), 'blob'); }
        };
        fr.readAsDataURL(obj);
      } catch (e) { /* fall through; the timeout below reports it */ }
    }
    return url;
  };

  /* Offline-only delivery (D12): FusionCharts posts csv/xlsx to its export
     server over cleartext HTTP. Refuse it and say so, rather than leaking data
     to the network or failing silently. */
  var _submit = HTMLFormElement.prototype.submit;
  HTMLFormElement.prototype.submit = function () {
    var action = String(this.getAttribute('action') || '');
    if (action.indexOf('export.api3.fusioncharts.com') >= 0 ||
        action.indexOf('//export.') >= 0) {
      /* Suppress the network round trip, but do NOT abandon the export.
         FusionCharts builds the csv/xlsx bytes as a Blob immediately before
         submitting, and the createObjectURL hook above reads that Blob through
         FileReader, which is asynchronous. Clearing pendingExport here would
         discard a payload we already hold by the time the read completes. The
         watchdog still reports if nothing arrives. */
      if (pendingExport) { pendingExport.serverBlocked = true; }
      return;
    }
    return _submit.apply(this, arguments);
  };

  function exportChart(chartId, payload, requestId) {
    var chart = charts[chartId];
    if (!chart) {
      postError(chartId, 'unknown-chart', 'no chart for this id', requestId);
      return;
    }
    var fmt = String(payload.format || 'png').toLowerCase();

    /* SVG and CSV are readable straight off the chart object. This is the only
       route that works in WKWebView, where exportChart() yields nothing. */
    try {
      if (fmt === 'svg' && typeof chart.getSVGString === 'function') {
        post('export', chartId, {
          format: 'svg', mime: 'image/svg+xml', fileName: 'chart.svg',
          text: chart.getSVGString(), via: 'getSVGString'
        }, requestId);
        return;
      }
      if (fmt === 'csv' && typeof chart.getChartData === 'function') {
        post('export', chartId, {
          format: 'csv', mime: 'text/csv', fileName: 'chart.csv',
          text: String(chart.getChartData('csv')), via: 'getChartData'
        }, requestId);
        return;
      }
    } catch (e) {
      postError(chartId, 'export-failed', e, requestId);
      return;
    }

    pendingExport = { chartId: chartId, requestId: requestId, format: fmt };
    try {
      chart.exportChart({ exportFormat: fmt });
    } catch (e) {
      pendingExport = null;
      postError(chartId, 'export-failed', e, requestId);
      return;
    }

    /* Report rather than hang. On iOS, PNG/JPG/PDF produce nothing at all. */
    setTimeout(function () {
      if (pendingExport && pendingExport.requestId === requestId) {
        var blocked = pendingExport.serverBlocked;
        pendingExport = null;
        postError(chartId,
          blocked ? 'export-server-blocked' : 'export-unsupported',
          blocked
            ? 'FusionCharts produced "' + fmt + '" only via its network export ' +
              'server, which is blocked: this package is offline-only.'
            : 'FusionCharts produced no output for "' + fmt + '" on this platform.',
          requestId);
      }
    }, 5000);
  }

  /* Single entry point called from Dart via runJavaScript. */
  window.__fcBridgeReceive = function (raw) {
    var envelope;
    try {
      envelope = JSON.parse(raw);
    } catch (e) {
      return;
    }
    if (!envelope || envelope.protocolVersion !== PROTOCOL_VERSION) {
      return;
    }
    var chartId = envelope.chartId;
    var payload = envelope.payload || {};
    var requestId = envelope.requestId;

    switch (envelope.type) {
      case 'render':      render(chartId, payload, requestId); break;
      case 'update':      update(chartId, payload, requestId); break;
      case 'addEvents':   addEvents(chartId, payload); break;
      case 'removeEvents':removeEvents(chartId, payload); break;
      case 'feedData':    feedData(chartId, payload); break;
      case 'export':      exportChart(chartId, payload, requestId); break;
      case 'dispose':     disposeChart(chartId); break;
      default: break;
    }
  };

  window.onerror = function (message, source, line) {
    post('error', 'fc-page', {
      code: 'page-error',
      message: String(message),
      line: line
    });
    return false;
  };
})();
