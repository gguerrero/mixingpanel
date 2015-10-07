class @MixingpanelTracker
  constructor: (options = {})->
    throw "'$' is not defined!! Ensure to call this constructor after $(document).ready" unless $?

    # General pupose options for all classes
    window.mixingpanel_options = $.extend({}, @defaultOptions, options)

    @appendGlobals = if mixingpanel_options.appendGlobals?
      mixingpanel_options.appendGlobals
    else
      true
    @properties = new MixingpanelProperties()
    @source = new MixingpanelSource(@properties)
    @parameterizer = new MixingpanelParameterizer(@properties)
    @session = new MixingpanelSession(@properties)

  defaultOptions:
    internal_domain: undefined,
    external_domains: [],
    tracking_params: [],
    source: {}

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
      true

  _formTracker: ->
    $('form.trackme').each (index, element)=>
      selector = @_selectorIdFor(element)
      @track_forms(selector, @_setTrackData(element)...)
      true

  _eventTracker: ->
    $('div.mpevent.trackme').each (index, element)=>
      @track(@_setTrackData(element)...)
      true

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

  trackingProperties: (properties) ->
    # This extension shows the properties override priority, from bottom to top
    $.extend {},
             @parameterizer.read(),
             properties,
             (@properties.globals() if @appendGlobals)

  track: (event, properties, callback) ->
    mixpanel.track event, @trackingProperties(properties), callback

  track_links: (selector, event, properties) ->
    mixpanel.track_links(selector, event, @trackingProperties(properties))

  track_forms: (selector, event, properties) ->
    mixpanel.track_forms(selector, event, @trackingProperties(properties))

  register: (properties) ->
    mixpanel.register(properties)

  identify: (email, id = mixpanel.get_distinct_id()) ->
    mixpanel.name_tag email
    mixpanel.people.set
      '$email': email
    mixpanel.identify id
