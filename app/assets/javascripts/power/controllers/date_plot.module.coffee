Power = require 'power/models/power'
Server = require 'power/config/server'

class DatePlot extends Exo.Spine.Controller

  prepare: ->
    @render()

    @delay ->
      @initGraph()
      @initSlider()
    , .2

  initSlider: =>
    @slider = new Razorfish.Slider
      width: window.getComputedStyle(document.querySelector('#chart'),null).getPropertyValue("width").split('px').join('')
      handleWidth: 12
      useRange: true
      tabs: @pastYear()

    @slider.appendTo @el
    @slider.setRange 10, 12
    @slider.bind 'range', @onRangeChanged

  onRangeChanged: (ev, min, max)->
    isInt = (num)->
      num % 1 == 0

    if isInt.call(@, min) and isInt.call(@, max)
      console.log 'Range', min, max

  pastYear: ->
    date = moment()
    arr = [{text: "Today", date: date}]
    
    date = date.subtract 'days', date.format('d')

    for i in [0..11]
      console.log "Adding: ", date.format('MMM YYYY')
      arr.push {text: date.format('MMM'), date: date}
      date = date.subtract 'months', 1
      
    return arr.reverse()

  initGraph: =>
    @graph = new Rickshaw.Graph.Ajax
      element: document.querySelector('#chart')
      dataURL: Server.areaSampleURL
        area: 'nyc'
        startDate: ''
        endDate: ''

      width: $("#chart").width()
      height: $("#chart").height()
      renderer: 'area'
      stroke: true
      padding:
        top: 0.3
      strokeWidth: 1.1
      onData: @onData
      onComplete: @onGraphRendered

  onData: (timeseries)=>
    @copyFill timeseries

    for ts in timeseries
      ts.color = 'rgba(66,50,51,0.3)'
      ts.stroke = 'rgba(0,0,0,0.15)'
    return timeseries

  onGraphRendered: (transport) =>
    graph = transport.graph
    graph.renderer.unstack = true
    graph.render()

    yAxis = new Rickshaw.Graph.Axis.Y
     graph: graph
    yAxis.render()

    try
      hoverDetail = new Rickshaw.Graph.HoverDetail
        graph: graph
        xFormatter: (x)-> moment.unix(x).format('LLL')
        yFormatter: (y)-> "#{y} offline"
    catch error
      console.log "error: #{error}"

  copyFill: (series) ->
    x = undefined
    i = 0
    data = series.map((s) ->
      s.data
    )
    while i < Math.max.apply(null, data.map((d) ->
      d.length
    ))
      x = Math.min.apply(null, data.filter((d) ->
        d[i]
      ).map((d) ->
        d[i].x
      ))
      data.forEach (d) ->
        if not d[i] or d[i].x isnt x
          d.splice i, 0,
            x: x
            y: if d[i-1] then d[i-1].y else 0

      i++

  render: ->
    @html JST['power/views/dateplot/index']()

module.exports = DatePlot