class Map
  constructor: () ->
    @map = null
    @radarsData = []
    @accidentData = []
    @heatmap = null
    @heatmapData = new google.maps.MVCArray()
    @accidentMarkersData = []
    @currentView = null

    @settings =
      defaultZoomLevel: 11
      defaultCenter:
        latitude: 48.856388 # Paris
        longitude: 2.350855 # Paris
      zoomHeatmapToMarkers: 13
      debug: true

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
        position: google.maps.ControlPosition.RIGHT_TOP

    @map = new google.maps.Map(document.getElementById("map"), mapOptions)
    @map.mapTypes.set "map_style", styledMap
    @map.setMapTypeId "map_style"

    # Add a listener on zoom_changed event
    google.maps.event.addListener @map, "zoom_changed", () =>
      this.updateDisplay()

    this.debug("Map initialized")

  # Update data depending criterias
  updateAccidents: (citerias) ->
    $.ajax(
            url: "/accidents/list.json"
            data: citerias
            success: (data) =>
              this.debug("Accident data updated with success")

              @accidentData = data.data
              this.clearAccidentMarkers()
              this.clearAccidentHeatmap()
              this.updateDisplay(true)
    )

  updateDisplay: (forceRefresh = false) ->
    if @map.getZoom() > @settings.zoomHeatmapToMarkers # need to display markers
      if forceRefresh or @currentView != "markers"
        this.clearAccidentHeatmap()
        this.displayAccidentMarkers()
    else
      if forceRefresh or @currentView != "heatmap"
        this.clearAccidentMarkers()
        this.displayAccidentHeatmap()


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
        weight: accident.gravite
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

    # Add accidentMarkers
    _.each(@accidentData, (accident) =>
      @accidentMarkersData.push new google.maps.Marker(
            position: new google.maps.LatLng(accident.latitude,accident.longitude),
            map: @map
          )
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


  ##########
  # RADARS #
  ##########

  #
  # Add the radar on the list depending the categorie
  #
  displayRadarsMarkers: (categorie) ->
    $.ajax "/radars/categorie/" + categorie + ".json",
      success: (data) =>
        if @radarsData?
          this.clearRadarsMarkers()
        else
          # If radarsData doesn't exist, initilize it
          @radarsData = []

        # Loop on the data we receive of json, and add it to the radarsData and the map
        _.each(data.data, (radar) =>
          marker = new google.maps.Marker(
            position: new google.maps.LatLng(radar.latitude,radar.longitude),
            map: @map
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


  #########
  # UTILS #
  # #######

  debug: (object) ->
    console.log("DEBUG: ", object) if @settings.debug


$(document).ready ->
  application_map = new Map
  application_map.initialize()
  application_map.updateAccidents()

  # Activate click on critere menu to display and hide the critere popup
  $(".header .criteres").live("click", (event) ->
    event.preventDefault()

    if $(this).hasClass("active")
      $(".menu-popup.criteres").fadeOut("fast")
      $(this).removeClass("active")
    else
      $(".menu-popup.criteres").fadeIn("fast")
      $(this).addClass("active")

    return false
  )

  # Uncheck every checkbox to reinitilize criteria on refresh
  $(".menu-popup input:checked").attr("checked", false)

  # Initialize accordion insite critere popup
  $(".form-criteres").accordion(
    header: '.section-critere-title'
    active: 10
    autoHeight: false
  )

  # Handle event on input check
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

  # Hanlde event in update button to update the map
  $(".menu-popup.criteres .update").live("click", (event) ->
    event.preventDefault()
    application_map.updateAccidents($(".menu-popup.criteres form").serializeArray())
    return false
  )

  # Hanlde update on the revert button
  $(".menu-popup.criteres .revert").live("click", (event) ->
    # We reinitialize the popup
    $(".menu-popup.criteres .section-critere-title .critere-count:not(.empty)").addClass("empty").text("")
    $(".menu-popup input:checked").attr("checked", false)
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

  )

