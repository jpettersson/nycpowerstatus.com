# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

$ ->
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
    
    # circle_path = document.createElementNS("http://www.w3.org/Graphics/SVG/1.1/DTD/svg11.dtd", "circle");
    # circle_path.setAttribute("cx", 25);
    # circle_path.setAttribute("cy", 25);
    # circle_path.setAttribute("r",  20);
    # circle_path.setAttribute("fill", "green");

    console.log google.maps.SymbolPath

    for point in map_areas 
      point.latLong = new google.maps.LatLng point.latitude, point.longitude 

      # low #41934f
      # med #934144
      # high #CD0810
      color = "#41934f"

      marker = new google.maps.Marker
        position: point.latLong,
        map: map,
        title:"Hello World!"
        icon:
          path: google.maps.SymbolPath.CIRCLE,
          scale: 10
          strokeWeight: 0
          fillOpacity: 1
          fillColor: color
  

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
