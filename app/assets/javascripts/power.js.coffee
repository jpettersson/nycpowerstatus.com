# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

#= require vendor/d3.v2
#= require vendor/rickshaw

$ ->

  # Graph

  graph = new Rickshaw.Graph(
    element: $("#chart")[0]
    width: $("#chart").width()
    height: 200
    renderer: 'line'
    series: [
      {
        color: 'steelblue',
        data: [ { x: 1321809347, y: 12343}, { x: 1331809347, y: 12100 }, { x: 1351909347, y: 10002 } ]
      }
      {
        color: 'red',
        data: [ { x: 1251809347, y: 11343}, { x: 1211809347, y: 1343 }, { x: 1351909347, y: 1143 } ]
      }
    ]
  )
  
  graph.render()

  yAxis = new Rickshaw.Graph.Axis.Y
   graph: graph
  yAxis.render()

  time = new Rickshaw.Fixtures.Time
  days = time.unit 'days'
  xAxis = new Rickshaw.Graph.Axis.Time
    timeUnit: days
    graph: graph

  xAxis.render();


  # Map

  if map_areas.length > 0
    
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

  else
    $('#map_canvas').hide()
