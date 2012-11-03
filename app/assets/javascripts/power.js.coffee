# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

#= require vendor/d3.v2
#= require vendor/rickshaw
#= require vendor/moment.min

$ ->

  # Graph
  unless time_series
    $('.trend').hide()
  else
    # Instead of using Rickshaw's built in zeroFill I'm copying 
    # the previous value instead, effectively pathing up the data.
    copyFill = (series) ->
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

    copyFill.call @, time_series

    # brighten = (hex, percent) ->
      
    #   # strip the leading # if it's there
    #   hex = hex.replace(/^\s*#|\s*$/g, "")
      
    #   # convert 3 char codes --> 6, e.g. `E0F` --> `EE00FF`
    #   hex = hex.replace(/(.)/g, "$1$1")  if hex.length is 3
    #   r = parseInt(hex.substr(0, 2), 16)
    #   g = parseInt(hex.substr(2, 2), 16)
    #   b = parseInt(hex.substr(4, 2), 16)
    #   "#" + ((0 | (1 << 8) + r + (256 - r) * percent).toString(16)).substr(1) + ((0 | (1 << 8) + g + (256 - g) * percent).toString(16)).substr(1) + ((0 | (1 << 8) + b + (256 - b) * percent).toString(16)).substr(1)

    # baseColor = "#0000FF"

    for ts, index in time_series
      #ts.color = brighten(baseColor, index/(time_series.length-1))
      ts.color = '#402829'
      #ts.stroke = 'rgba(0,0,0,0.15)'

    graph = new Rickshaw.Graph(
      element: $("#chart")[0]
      width: $("#chart").width()
      height: $("#chart").height()
      renderer: 'line'
      #renderer: 'area'
      #stroke: true
      padding:
        top: 0.3
      series: time_series
      strokeWidth: 1.1
    )
    
    graph.renderer.unstack = true
    graph.render()

    yAxis = new Rickshaw.Graph.Axis.Y
     graph: graph
    yAxis.render()

    # time = new Rickshaw.Fixtures.Time
    # days = time.unit 'days'
    # xAxis = new Rickshaw.Graph.Axis.Time
    #   timeUnit: days
    #   graph: graph

    # xAxis.render();

    hoverDetail = new Rickshaw.Graph.HoverDetail
      graph: graph
      xFormatter: (x)-> moment.unix(x).format('LLL')
      yFormatter: (y)-> "#{y} offline"

  # Map

  if map_areas.length == 0
    $('#map_canvas').hide()
  else
    mapOptions =
      center: new google.maps.LatLng(40.751991,-73.888893)
      zoom: 11
      mapTypeId: google.maps.MapTypeId.ROADMAP
      disableDefaultUI: true
      scrollwheel: false
      styles: [
        {
          stylers: [
            { hue: "#00ff00" },
            { saturation: -100 }
          ]
        },{
          featureType: "road",
          elementType: "geometry",
          stylers: [
            { lightness: 100 },
            { visibility: "simplified" }
          ]
        },{
          featureType: "road",
          elementType: "labels",
          stylers: [
            { visibility: "off" }
          ]
        }
      ]

    map = new google.maps.Map(document.getElementById("map_canvas"), mapOptions)

    for point in map_areas 
      do (point) ->
        point.latLong = new google.maps.LatLng point.latitude, point.longitude 

        percetange = point.last_sample.custs_out / point.last_sample.total_custs

        if percetange < 0.02
          color = "#41934f"
        else if percetange < 0.08
          color = '#934144'
        else
          color = '#CD0810'

        marker = new google.maps.Marker
          position: point.latLong,
          map: map,
          title:point.area_name
          icon:
            path: google.maps.SymbolPath.CIRCLE,
            scale: 10
            strokeWeight: 0
            fillOpacity: .7
            fillColor: color
        
        google.maps.event.addListener marker, 'click', =>
          window.location = "/#{point.slug}"

    #  Make an array of the LatLng's of the markers you want to show
    LatLngList = map_areas.map (a) -> a.latLong

    if map_areas.length > 1
      #  Create a new viewpoint bound
      bounds = new google.maps.LatLngBounds()

      #  Go through each...
      i = 0
      LtLgLen = LatLngList.length

      while i < LtLgLen
        #  And increase the bounds to take this point
        bounds.extend LatLngList[i]
        i++

      #Fit these bounds to the map
      map.fitBounds bounds
    else
      map.panTo LatLngList[0]
      map.setZoom(14)

