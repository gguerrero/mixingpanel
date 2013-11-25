class @MixingpanelTracker
  constructor: ->
    @mpp = new MixingpanelProperties()
    @_bindActions()

  _bindActions: ->
    @_linkTracker()
    @_formTracker()
    @_eventTracker()

  _linkTracker: ->
    $('a.trackme').each (index, element)=>
      selector = @_selectorIdFor(element)
      extra_properties = 
        "Page name": @mpp.pageName()
        "Destination": element.href

      @track_links(selector, @_setTrackData(element, extra_properties)...)

  _formTracker: ->
    $('form.trackme').each (index, element)=>
      selector = @_selectorIdFor(element)
      extra_properties = 
        "Page name": @mpp.pageName()
        "Action": element.action

      @track_links(selector, @_setTrackData(element, extra_properties)...)

  _eventTracker: ->
    $('div.mpevent.trackme').each (index, element)=>
      extra_properties = 
        "Page name": @mpp.pageName()

      @track(@_setTrackData(element, extra_properties)...)

  _selectorIdFor: (element) ->
    if element.id is null or element.id == ""
      randomized = Math.floor((Math.random()*1000)+1)
      timestamp  = new Date().getTime()
      $(element).attr('id', "tracked_item_#{randomized+timestamp}")

    "##{element.id}"

  _setTrackData: (element, extra_properties) ->
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

