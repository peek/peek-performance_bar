# The mission control window.performance.timing display area.
#
# Breaks the window.performance.timing numbers down into these groups:
#
# dns         - Time looking up domain. Usually zero.
# tcp and ssl - Time used establishing tcp and ssl connections.
# redirect    - Time spent redirecting since navigation began.
# app         - Real server time as recorded in the app.
# latency     - Extra backend and network time where browser was waiting.
# frontend    - Time spent loading and rendering the DOM until interactive.
#
# Not all frontend time is counted. The page is considered ready when the
# domInteractive ready state is reached. This is before DOMContentLoaded and
# onload javascript handlers.
class PerformanceBar
  # Additional app info to show with the app timing.
  appInfo: null

  # The pixel width we're rendering the timing graph into.
  width: null

  # Format a time as ms or s based on how big it is.
  @formatTime: (value) ->
    if value >= 1000
      "#{(value / 1000).toFixed(3)}s"
    else
      "#{value.toFixed(0)}ms"

  # Create a new PerformanceBar view bound to a given element. The el and width
  # options should be provided here.
  constructor: (options={}) ->
    @el = $('#peek-view-performance-bar .performance-bar')
    @[k] = v for k, v of options
    @width  ?= @el.width()
    @timing ?= window.performance.timing

  # Render the performance bar in the associated element. This is a little weird
  # because it includes the server-side rendering time reported with the
  # response document which may not line up when using the back/forward button
  # and loading from cache.
  render: (serverTime=0) ->
    @el.empty()
    @addBar 'frontend', '#90d35b', 'domLoading', 'domInteractive'

    # time spent talking with the app according to performance.timing
    perfNetworkTime = (@timing.responseEnd - @timing.requestStart)

    # only include serverTime if it's less than than the browser reported
    # talking-to-the-app time; otherwise, assume we're loading from cache.
    if serverTime and serverTime <= perfNetworkTime
      networkTime = perfNetworkTime - serverTime
      @addBar 'latency / receiving', '#f1faff',
        @timing.requestStart + serverTime,
        @timing.requestStart + serverTime + networkTime
      @addBar 'app', '#90afcf',
        @timing.requestStart,
        @timing.requestStart + serverTime,
        @appInfo
    else
      @addBar 'backend', '#c1d7ee', 'requestStart', 'responseEnd'

    @addBar 'tcp / ssl', '#45688e', 'connectStart', 'connectEnd'
    @addBar 'redirect', '#0c365e', 'redirectStart', 'redirectEnd'
    @addBar 'dns', '#082541', 'domainLookupStart', 'domainLookupEnd'

    @el

  # Determine if the page has reached the interactive state yet.
  isLoaded: ->
    @timing.domInteractive

  # Integer unix timestamp representing the very beginning of the graph.
  start: ->
    @timing.navigationStart

  # Integer unix timestamp representing the very end of the graph.
  end: ->
    @timing.domInteractive

  # Total number of milliseconds between the start and end times.
  total: ->
    @end() - @start()

  # Helper used to add a bar to the graph.
  addBar: (name, color, start, end, info) ->
    start = @timing[start] if typeof start is 'string'
    end   = @timing[end]   if typeof end is 'string'

    # Skip missing stats
    return unless start? and end?

    time   = end - start
    offset = start - @start()
    left = @mapH(offset)
    width = @mapH(time)

    title = "#{name}: #{PerformanceBar.formatTime(time)}"
    bar = $ '<li></li>', title: title, class: 'peek-tooltip'
    bar.css
      width: "#{width}px"
      left:  "#{left}px"
      background: color
    bar.tipsy gravity: $.fn.tipsy.autoNS
    @el.append bar

  # Map a time offset value to a horizontal pixel offset.
  mapH: (offset) ->
    offset * (@width / @total())

renderPerformanceBar = ->
  resp = $('#peek-server_response_time')
  time = Math.round(resp.data('time') * 1000)

  bar = new PerformanceBar
  bar.render time

  span = $('<span>', {'class': 'peek-tooltip', title: 'Total navigation time for this page.'})
    .text(PerformanceBar.formatTime(bar.total()))
  span.tipsy gravity: $.fn.tipsy.autoNS
  updateStatus span


updateStatus = (html) ->
  $('#serverstats').html html

ajaxStart = null
$(document).on 'peek:start pjax:start page:fetch', (event) ->
  ajaxStart = event.timeStamp

$(document).on 'peek:end pjax:end page:change', (event, xhr) ->
  ajaxEnd    = event.timeStamp
  total      = ajaxEnd - ajaxStart
  serverTime = if xhr then parseInt(xhr.getResponseHeader('X-Runtime')) else 0

  # Defer to include the timing of pjax hook evaluation
  setTimeout ->
    now = new Date().getTime()
    bar = new PerformanceBar
      timing:
        requestStart: ajaxStart,
        responseEnd: ajaxEnd,
        domLoading: ajaxEnd,
        domInteractive: now
      isLoaded: -> true
      start: -> ajaxStart
      end: -> now

    bar.render serverTime

    if $.fn.pjax?
      tech = 'PJAX'
    else
      tech = 'Turbolinks'

    span = $('<span>', {'class': 'peek-tooltip', title: "#{tech} navigation time"})
      .text(PerformanceBar.formatTime(total))
    span.tipsy gravity: $.fn.tipsy.autoNS
    updateStatus span

    ajaxStart = null
  , 0

$ ->
  if window.performance
    renderPerformanceBar()
  else
    $('#peek-view-performance-bar').remove()
