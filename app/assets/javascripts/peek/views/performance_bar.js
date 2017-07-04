// The mission control window.performance.timing display area.
//
// Breaks the window.performance.timing numbers down into these groups:
//
// dns         - Time looking up domain. Usually zero.
// tcp and ssl - Time used establishing tcp and ssl connections.
// redirect    - Time spent redirecting since navigation began.
// app         - Real server time as recorded in the app.
// latency     - Extra backend and network time where browser was waiting.
// frontend    - Time spent loading and rendering the DOM until interactive.
//
// Not all frontend time is counted. The page is considered ready when the
// domInteractive ready state is reached. This is before DOMContentLoaded and
// onload javascript handlers.
class PerformanceBar {
  static initClass() {
    // Additional app info to show with the app timing.
    this.prototype.appInfo = null;
  
    // The pixel width we're rendering the timing graph into.
    this.prototype.width = null;
  }

  // Format a time as ms or s based on how big it is.
  static formatTime(value) {
    if (value >= 1000) {
      return `${(value / 1000).toFixed(3)}s`;
    } else {
      return `${value.toFixed(0)}ms`;
    }
  }

  // Create a new PerformanceBar view bound to a given element. The el and width
  // options should be provided here.
  constructor(options) {
    if (options == null) { options = {}; }
    this.el = $('#peek-view-performance-bar .performance-bar');
    for (let k in options) { let v = options[k]; this[k] = v; }
    if (this.width == null) {  this.width = this.el.width(); }
    if (this.timing == null) { this.timing = window.performance.timing; }
  }

  // Render the performance bar in the associated element. This is a little weird
  // because it includes the server-side rendering time reported with the
  // response document which may not line up when using the back/forward button
  // and loading from cache.
  render(serverTime) {
    if (serverTime == null) { serverTime = 0; }
    this.el.empty();
    this.addBar('frontend', '#90d35b', 'domLoading', 'domInteractive');

    // time spent talking with the app according to performance.timing
    let perfNetworkTime = (this.timing.responseEnd - this.timing.requestStart);

    // only include serverTime if it's less than than the browser reported
    // talking-to-the-app time; otherwise, assume we're loading from cache.
    if (serverTime && (serverTime <= perfNetworkTime)) {
      let networkTime = perfNetworkTime - serverTime;
      this.addBar('latency / receiving', '#f1faff',
        this.timing.requestStart + serverTime,
        this.timing.requestStart + serverTime + networkTime);
      this.addBar('app', '#90afcf',
        this.timing.requestStart,
        this.timing.requestStart + serverTime,
        this.appInfo);
    } else {
      this.addBar('backend', '#c1d7ee', 'requestStart', 'responseEnd');
    }

    this.addBar('tcp / ssl', '#45688e', 'connectStart', 'connectEnd');
    this.addBar('redirect', '#0c365e', 'redirectStart', 'redirectEnd');
    this.addBar('dns', '#082541', 'domainLookupStart', 'domainLookupEnd');

    return this.el;
  }

  // Determine if the page has reached the interactive state yet.
  isLoaded() {
    return this.timing.domInteractive;
  }

  // Integer unix timestamp representing the very beginning of the graph.
  start() {
    return this.timing.navigationStart;
  }

  // Integer unix timestamp representing the very end of the graph.
  end() {
    return this.timing.domInteractive;
  }

  // Total number of milliseconds between the start and end times.
  total() {
    return this.end() - this.start();
  }

  // Helper used to add a bar to the graph.
  addBar(name, color, start, end, info) {
    if (typeof start === 'string') { start = this.timing[start]; }
    if (typeof end === 'string') { end   = this.timing[end]; }

    // Skip missing stats
    if ((start == null) || (end == null)) { return; }

    let time   = end - start;
    let offset = start - this.start();
    let left = this.mapH(offset);
    let width = this.mapH(time);

    let title = `${name}: ${PerformanceBar.formatTime(time)}`;
    let bar = $('<li></li>', {title, class: 'peek-tooltip'});
    bar.css({
      width: `${width}px`,
      left:  `${left}px`,
      background: color
    });
    bar.tipsy({gravity: $.fn.tipsy.autoNS});
    return this.el.append(bar);
  }

  // Map a time offset value to a horizontal pixel offset.
  mapH(offset) {
    return offset * (this.width / this.total());
  }
}
PerformanceBar.initClass();

let renderPerformanceBar = function() {
  let resp = $('#peek-server_response_time');
  let time = Math.round(resp.data('time') * 1000);

  let bar = new PerformanceBar;
  bar.render(time);

  let span = $('<span>', {'class': 'peek-tooltip', title: 'Total navigation time for this page.'})
    .text(PerformanceBar.formatTime(bar.total()));
  span.tipsy({gravity: $.fn.tipsy.autoNS});
  return updateStatus(span);
};

var updateStatus = html => $('#serverstats').html(html);

let ajaxStart = null;
$(document).on('pjax:start page:fetch turbolinks:request-start', event => ajaxStart = event.timeStamp);

$(document).on('pjax:end page:load turbolinks:load', function(event, xhr) {
  if (ajaxStart == null) { return; }
  let ajaxEnd    = event.timeStamp;
  let total      = ajaxEnd - ajaxStart;
  let serverTime = xhr ? parseInt(xhr.getResponseHeader('X-Runtime')) : 0;

  // Defer to include the timing of pjax hook evaluation
  return setTimeout(function() {
    let tech;
    let now = new Date().getTime();
    let bar = new PerformanceBar({
      timing: {
        requestStart: ajaxStart,
        responseEnd: ajaxEnd,
        domLoading: ajaxEnd,
        domInteractive: now
      },
      isLoaded() { return true; },
      start() { return ajaxStart; },
      end() { return now; }
    });

    bar.render(serverTime);

    if ($.fn.pjax != null) {
      tech = 'PJAX';
    } else {
      tech = 'Turbolinks';
    }

    let span = $('<span>', {'class': 'peek-tooltip', title: `${tech} navigation time`})
      .text(PerformanceBar.formatTime(total));
    span.tipsy({gravity: $.fn.tipsy.autoNS});
    updateStatus(span);

    return ajaxStart = null;
  }
  , 0);
});

$(function() {
  if (window.performance) {
    return renderPerformanceBar();
  } else {
    return $('#peek-view-performance-bar').remove();
  }
});
