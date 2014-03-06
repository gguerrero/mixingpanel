class @MixingpanelSource
  constructor: (@properties, options = {}) ->
    @expirationDays = options.firstTouchExpirationDays or 30
    @firstSourceProperty = "first_touch_source"
    @firstTimestampProperty = "first_touch_timestamp"
    @lastSourceProperty = "last_touch_source"
    @sourceProperty = "source"
    @sources =
      SEO: "SEO"
      SEM: "SEM"
      EMAIL: "Email"
      DIRECT: "Direct"
      SOCIAL: "Social"
      REFERRAL: "Referral"
    @_setUTM()
    @_setOptions(options)
    @append() unless options.append is false

  _setUTM: ->
    qsObj = @properties.location.query_string
    @utm =
      source: qsObj.utm_source
      medium: qsObj.utm_medium
      term: qsObj.utm_term
      content: qsObj.utm_content
      campaign: qsObj.utm_campaign

  _setOptions: (options) ->
    @appendSources(options.values) if options.values?
    @setValueCallback(options.callback) if options.callback?

  appendSources: (sources) ->
    $.extend(@sources, sources)

  setValueCallback: (callback) ->
    @getValue = callback if typeof callback is "function"

  getValue: () ->
    if @utm.medium?
      if @utm.medium is "email"
        @sources.EMAIL
      else if @utm.medium is "ppc" or @utm.medium is "banner"
        @sources.SEM
      else
        undefined

    else if @properties.engine?
      @sources.SEO

    else if @properties.referer isnt ""
      if @properties.isSocial()
        @sources.SOCIAL
      else
        @sources.REFERRAL

    else if @properties.referer is ""
      @sources.DIRECT
    else
      undefined

  append: ->
    if @registerSouce()
      value = @getValue()
      @writeFirstTouch(value)
      @writeLastTouch(value)
      @writeSource(value)
      value

  registerSouce: ->
    @utm.medium isnt undefined or !@properties.isInternal()

  firstTouchIsExpired: ()->
    first_touch_ms = Date.parse(mixpanel.get_property(@firstTimestampProperty))
    exp_days_ms = @expirationDays*24*60*60*1000
    current_time_ms = (new Date()).getTime()

    isNaN(first_touch_ms) or ((first_touch_ms + exp_days_ms) < current_time_ms)

  writeFirstTouch: (value)->
    if @firstTouchIsExpired()
      props = {}
      props[@firstSourceProperty] = value
      props[@firstTimestampProperty] = new Date()
      mixpanel.register(props)

  writeLastTouch: (value)->
    prop = {}
    prop[@lastSourceProperty] = value
    mixpanel.register(prop)

  writeSource: (value)->
    source = mixpanel.get_property(@sourceProperty)
    if source
      if source[source.length-1] != value
        mixpanel.get_property(@sourceProperty).push(value)
    else
      prop = {}
      prop[@sourceProperty] = [value]
      mixpanel.register(prop)
