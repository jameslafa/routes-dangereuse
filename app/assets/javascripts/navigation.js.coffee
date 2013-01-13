class Map
  constructor: () ->
    @map = null
    @radarsData = []
    @accidentData = []
    @heatmap = null
    @heatmapData = new google.maps.MVCArray()
    @accidentMarkersData = []
    @currentView = null

    @infoWindow = new InfoBox(
      maxWidth: 0
      closeBoxURL: "/assets/bt-close.png"
      closeBoxMargin: "5px"
    )

    @settings =
      defaultZoomLevel: 14
      defaultCenter:
        latitude: 48.856388 # Paris
        longitude: 2.350855 # Paris
      zoomHeatmapToMarkers: 13
      debug: true

    @labels =
      vehicules:
        1 : "V&#233;lo"
        2 : "Deux roues motoris&#233;"
        3 : "V&#233;hicule l&#233;ger"
        4 : "Autre"
        5 : "Poids-lourd"
        6 : "Transports en commun"
      lumiere:
        1 : "Plein jour"
        2 : "Cr&#233;puscule ou aube"
        3 : "Nuit sans &#233;clairage public"
        4 : "Nuit avec &#233;clairage public non allum&#233;"
        5 : "Nuit avec &#233;clairage public allum&#233;"
      atmospherique:
        1 : "Normale"
        2 : "Pluie l&#233;g&#232;re"
        3 : "Pluie forte"
        4 : "Neige - gr&#234;le"
        5 : "Brouillard - fum&#233;é"
        6 : "Vent fort - temp&#234;te"
        7 : "Temps &#233;blouissant"
        8 : "Temps couvert"
        9 : "Autre"
      route :
        1 : "Autoroute"
        2 : "Route nationale"
        3 : "Route d&#233;partementale"
        4 : "Voie communale"
        5 : "Hors r&#233;seau public"
        6 : "Parc de stationnement"
        9 : "Autre"
      intersection :
        1 : "Hors intersection"
        2 : "Intersection en X"
        3 : "Intersection en T"
        4 : "Intersection en T"
        5 : "Intersection &#224; plus de 4 branches"
        6 : "Giratoire"
        7 : "Place"
        8 : "Passage &#224; niveau"
        9 : "Autre intersection"


  # Initilize and display the map
  initialize: () ->
    # Redefine my styles
    styles = [
      elementType: "geometry.fill"
      stylers: [
        weight: 0.1
      ,
        saturation: -59
      ,
        lightness: 48
      ,
        gamma: 0.54
      ]
    ]

    # Create a new styledMap
    styledMap = new google.maps.StyledMapType(styles,
      name: "Styled Map"
    )

    # Define the default map options
    mapOptions =
      center: new google.maps.LatLng(@settings.defaultCenter.latitude, @settings.defaultCenter.longitude) # Paris
      zoom: @settings.defaultZoomLevel
      mapTypeControlOptions:
        mapTypeIds: [google.maps.MapTypeId.ROADMAP, "map_style"]
      panControl: false
      mapTypeControl: false
      streetViewControl: false
      overviewMapControl: false
      scaleControl: false
      zoomControlOptions:
        position: google.maps.ControlPosition.RIGHT_CENTER

    @map = new google.maps.Map(document.getElementById("map"), mapOptions)
    @map.mapTypes.set "map_style", styledMap
    @map.setMapTypeId "map_style"

    # Add a listener on zoom_changed event
    google.maps.event.addListener @map, "zoom_changed", () =>
      this.updateDisplay()

    this.debug("Map initialized")

  # Update data depending accident criterias
  updateAccidents: (criterias) ->
    $.ajax(
      url: "/accidents/list.json"
      data: criterias
      success: (data) =>
        this.debug("Accident data updated with success")

        @accidentData = data.data
        this.clearAccidentMarkers()
        this.clearAccidentHeatmap()
        this.updateDisplay(true)
    )

  # Update display depending zoom value
  updateDisplay: (forceRefresh = false) ->
    if @map.getZoom() > @settings.zoomHeatmapToMarkers # need to display markers
      if forceRefresh or @currentView != "markers"
        this.clearAccidentHeatmap()
        this.displayAccidentMarkers()
    else
      if forceRefresh or @currentView != "heatmap"
        this.clearAccidentMarkers()
        this.displayAccidentHeatmap()

  # Update data depending radars criterias
  updateRadars: (criterias) ->
    $.ajax(
      url: "/radars/list.json"
      data: criterias
      success: (data) =>
        this.debug("Radars data updated with success")
        this.displayRadarsMarkers(data)
    )

  ####################
  # ACCIDENT HEATMAP #
  ####################

  #
  # Display the accident Heatmap
  #
  displayAccidentHeatmap: () ->
    this.debug("Display accident heatmap")

    @currentView = "heatmap"

    # Add heatmap data
    _.each(@accidentData, (accident) =>
      @heatmapData.push(
        location: new google.maps.LatLng(accident.latitude, accident.longitude)
        weight: accident.tues
      )
    )

    if not @heatmap?
      # Initiliaze the heatmap
      @heatmap = new google.maps.visualization.HeatmapLayer(
        data: @heatmapData
        radius: 40
      )
      @heatmap.setMap(@map)

  #
  # Erase the Heatmap
  #
  clearAccidentHeatmap: () ->
    this.debug("Clear accident heatmap")
    @heatmapData.clear()


  ####################
  # ACCIDENT MARKERS #
  ####################

  #
  # Display every accident as a marker
  #
  displayAccidentMarkers: () ->
    this.debug("Display accident markers")
    @currentView = "markers"

    that = this
    # Add accidentMarkers
    _.each(@accidentData, (accident) =>
      marker = new google.maps.Marker(
                position: new google.maps.LatLng(accident.latitude,accident.longitude),
                map: @map,
                icon: this.getAccidentMarkerImage(accident.tues)
                numac: accident.numac
              )


      google.maps.event.addListener(marker, 'click', (event) ->
        that.displayAccidentDetails(this, that)
      )

      @accidentMarkersData.push marker
    )

  #
  # Remove every accidentMarkers from the map
  #
  clearAccidentMarkers: () ->
    this.debug("Clear accident markers")
    # If the accidentMarkersData already exist, we must remove all the marker first
    _.each(@accidentMarkersData, (accident) =>
      accident.setMap(null)
    )
    # Then empty the accidentMarkersData array
    @accidentMarkersData.length = 0

  #
  # Return the correct image depending how many people were killed in the accident
  #
  getAccidentMarkerImage: (tues) ->
    switch tues
      when 0
        return '/assets/mark-acc-01.png'
      when 1
        return '/assets/mark-acc-02.png'
      else
        return '/assets/mark-acc-03.png'

  #
  # Display the accident detail in an infoWindow
  #
  displayAccidentDetails: (marker, that) ->
    numac = marker.numac
    infoWindow = that.infoWindow


# Taux de gravité : (gravité)

    $.ajax(
      url: "/accidents/" + numac + ".json"
      success: (data) =>
        content = "<h2>Accident &#224; " + data.accident.ville + "</h2><div class='content'>"
        if data.accident.tues < 2
          content += "<strong>Victimes: </strong>" + data.accident.tues + " tué<br/>"
        else
          content += "<strong>Victimes: </strong>" + data.accident.tues + " tués<br/>"

        if data.vehicules.length < 2
          content += "<strong>Impliquant " + data.vehicules.length + " v&#233;hicule: </strong>"
        else
          content += "<strong>Impliquant " +data.vehicules.length + " v&#233;hicules: </strong>"

        _.each(data.vehicules, (element, index, list) ->
          content += that.labels.vehicules[element.vehicule]
          if index < list.length - 1
            content += ", "
          else
            content += "<br/>"
        )

        content += "<strong>Conditions: </strong>" + that.labels.atmospherique[data.accident.atmospherique] + ", " + that.labels.lumiere[data.accident.lumiere] + "<br/>"

        content += "<strong>Type de route: </strong>" + that.labels.route[data.accident.route] + ", " + that.labels.intersection[data.accident.intersection] + "<br/>"
        content += "<strong>Taux de gravit&#233;: </strong>" + data.accident.gravite + "</div>"

        infoWindow.setContent(content)
        infoWindow.open(@map, marker)

    )




  ##########
  # RADARS #
  ##########

  #
  # Add the radar on the list depending the categorie
  #
  displayRadarsMarkers: (data) ->
    if @radarsData?
      this.clearRadarsMarkers()
    else
      # If radarsData doesn't exist, initilize it
      @radarsData = []

    # Loop on the data we receive of json, and add it to the radarsData and the map
    _.each(data.data, (radar) =>
      marker = new google.maps.Marker(
        position: new google.maps.LatLng(radar.latitude,radar.longitude),
        map: @map,
        icon: this.getRadarMarkerImage(radar.categorie)
      )
      @radarsData.push(marker)
    )


  #
  # Remove every radars Markers from the map
  #
  clearRadarsMarkers: () ->
    # If the radarsData already exist, we must remove all the marker first
    _.each(@radarsData, (radar) =>
      radar.setMap(null)
    )
    # Then empty the radarsData array
    @radarsData.length = 0

  #
  # Return the correct image depending how many people were killed in the accident
  #
  getRadarMarkerImage: (category) ->
    switch category
      when 1
        return '/assets/mark-rad-fx.png'
      when 2
        return '/assets/mark-rad-fr.png'
      when 3
        return '/assets/mark-rad-pl.png'
      when 4
        return '/assets/mark-rad-tc.png'

  #########
  # UTILS #
  # #######

  debug: (object) ->
    console.log("DEBUG: ", object) if @settings.debug


$(document).ready ->
  application_map = new Map
  application_map.initialize()
  application_map.updateAccidents()

  #
  # Activate click on critere menu to display and hide the critere popup
  #
  $(".header .criteres").live("click", (event) ->
    event.preventDefault()

    if $(this).hasClass("active")
      $(".menu-popup.criteres").fadeOut("fast")
      $(this).removeClass("active")
    else
      $(".menu-popup.radars").fadeOut("fast")
      $(".header .radars").removeClass("active")
      $(".menu-popup.criteres").fadeIn("fast")
      $(this).addClass("active")

    return false
  )

  #
  # Activate click on radars menu to display and hide the critere popup
  #
  $(".header .radars").live("click", (event) ->
    event.preventDefault()

    if $(this).hasClass("active")
      $(".menu-popup.radars").fadeOut("fast")
      $(this).removeClass("active")
    else
      $(".menu-popup.criteres").fadeOut("fast")
      $(".header .criteres").removeClass("active")
      $(".menu-popup.radars").fadeIn("fast")
      $(this).addClass("active")

    return false
  )

  #
  #  Uncheck every checkbox to reinitilize criteria on refresh
  #
  $(".menu-popup input:checked").attr("checked", false)

  #
  # Initialize accordion insite critere popup
  #
  $(".form-criteres").accordion(
    header: '.section-critere-title'
    active: 10
    autoHeight: false
  )

  #
  # Handle event on input check on critere popup
  #
  $(".menu-popup.criteres input").live("click", (event) ->
    # First, update the check criteria number
    nbCheckedInputs = $(this).parents(".section-criteres").find(":checked").length
    count = $(".menu-popup.criteres .section-critere-title.ui-state-active .critere-count")

    if nbCheckedInputs > 0
      count.removeClass("empty")
      count.text(nbCheckedInputs)
    else
      count.addClass("empty")
      count.text("")

    # Now count results
    criterias = $(".menu-popup.criteres form").serializeArray()
    criterias["count"] = true

    $.ajax(
      url: "/accidents/list.json"
      data:criterias
      success: (data) ->
        if data.count == 0
          nb_accidents = "Aucun accident"
        else if data.count == 1
          nb_accidents = "1 accident"
        else
          nb_accidents = data.count + " accident"
        $(".menu-popup.criteres .nb_accidents").text(nb_accidents)
    )
  )

  #
  # Hanlde event in update button on critere popup to update the map
  #
  $(".menu-popup.criteres .update").live("click", (event) ->
    event.preventDefault()
    application_map.updateAccidents($(".menu-popup.criteres form").serializeArray())
    return false
  )

  #
  # Hanlde update on the revert button on critere popup
  #
  $(".menu-popup.criteres .revert").live("click", (event) ->
    event.preventDefault()
    # We reinitialize the popup
    $(".menu-popup.criteres .section-critere-title .critere-count:not(.empty)").addClass("empty").text("")
    $(".menu-popup.criteres input:checked").attr("checked", false)
    $( ".form-criteres" ).accordion( "option", "active", 0)

    # Now count results
    criterias = $(".menu-popup.criteres form").serializeArray()
    criterias["count"] = true

    $.ajax(
      url: "/accidents/list.json"
      data:criterias
      success: (data) ->
        if data.count == 0
          nb_accidents = "Aucun accident"
        else if data.count == 1
          nb_accidents = "1 accident"
        else
          nb_accidents = data.count + " accident"
        $(".menu-popup.criteres .nb_accidents").text(nb_accidents)
    )
    return false
  )

  #
  # Hanlde event in update button on radars popup to update the map
  #
  $(".menu-popup.radars .update").live("click", (event) ->
    event.preventDefault()
    application_map.updateRadars($(".menu-popup.radars form").serializeArray())
    return false
  )

  #
  # Hanlde update on the revert button on radars popup
  #
  $(".menu-popup.radars .revert").live("click", (event) ->
    event.preventDefault()
    $(".menu-popup.radars input:checked").attr("checked", false)
    return false
  )

  $(".credits .close").live("click", (event) ->
    event.preventDefault()
    $(".credits").fadeOut("fast")
    return false
  )

  $(".footer .sources").live("click", (event) ->
    event.preventDefault()
    $(".credits").fadeIn("fast")
    return false
  )

