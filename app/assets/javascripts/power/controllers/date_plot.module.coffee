Power = require 'power/models/power'
Server = require 'power/config/server'

class DatePlot extends Exo.Spine.Controller

  prepare: ->
    @render()

    @delay @initGraph, .2

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