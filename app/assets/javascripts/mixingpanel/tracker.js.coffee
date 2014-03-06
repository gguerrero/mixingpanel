class @MixingpanelTracker
  constructor: (options = {internal_domain: undefined, source: {}})->
    throw "'$' is not defined!! Ensure to call this constructor after $(document).ready" unless $?
    @properties = new MixingpanelProperties(options.internal_domain)
    @source = new MixingpanelSource(@properties, options.source)

  bind: ->
    @_bindActions()

  _bindActions: ->
    @_linkTracker()
    @_formTracker()
    @_eventTracker()

  _linkTracker: ->
    $('a.trackme').each (index, element)=>
      selector = @_selectorIdFor(element)
      properties =
        "Page name": @properties.pageName()
        "origin": @properties.referer,
        "link": document.URL
      
      @track_links(selector, @_setTrackData(element, properties)...)

  _formTracker: ->
    $('form.trackme').each (index, element)=>
      selector = @_selectorIdFor(element)
      @track_forms(selector, @_setTrackData(element)...)

  _eventTracker: ->
    $('div.mpevent.trackme').each (index, element)=>
      @track(@_setTrackData(element)...)

  _selectorIdFor: (element) ->
    if element.id is null or element.id == ""
      randomized = Math.floor((Math.random()*1000)+1)
      timestamp  = new Date().getTime()
      $(element).attr('id', "tracked_item_#{randomized+timestamp}")

    "##{element.id}"

  _setTrackData: (element, extra_properties = {}) ->
    data = @extractEventData(element)
    properties = $.extend(extra_properties, data.properties)
    [data.event, properties]

  extractEventData: (element) ->
    event: $(element).data('event')
    properties: $(element).data('extraProps')

  track: (event, properties) ->
    mixpanel.track event, properties

  track_links: (selector, event, properties) ->
    mixpanel.track_links(selector, event, properties)

  track_forms: (selector, event, properties) ->
    mixpanel.track_forms(selector, event, properties)

  register: (properties) ->
    mixpanel.register(properties)

  identify: (email, id = mixpanel.get_distinct_id()) ->
    mixpanel.name_tag email
    mixpanel.people.set
      '$email': email
    mixpanel.identify id
