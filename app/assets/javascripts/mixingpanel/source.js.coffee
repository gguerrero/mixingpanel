class @MixingpanelSource
  constructor: (@properties) ->
    @cookies = new MixingpanelCookies()
    @expirationDays = mixingpanel_options.source.firstTouchExpirationDays or 30
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
    @_setOptions(mixingpanel_options.source)
    @append() unless mixingpanel_options.source.append is false

  _setUTM: (qsObj = @properties.location.query_string) ->
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
    value = @getValue()
    allSources = {}

    if @registerSource()
      allSources = $.extend(allSources, @getFirstTouch(value)) if @firstTouchIsExpired()
      allSources = $.extend(allSources, @getLastTouch(value))
      mixpanel.register(allSources)
    else
      mixpanel.register(last_touch_start_session: false)

    allSources

  registerSource: ->
    @utm.medium? or !@properties.isInternal() or @properties.isExternalDomainException()

  tachanSource: ->
    words = @utm.medium.split(/\s|_/)
    new_words = []
    for word in words
      new_words.push (word[0].toUpperCase() + word.slice(1))
    new_words.join(" ")

  firstTouchIsExpired: ()->
    if @cookies[@firstTimestampProperty]?
      false
    else
      @setFirstTouchExpirationCookie()
      true

  setFirstTouchExpirationCookie: ()->
    exp_days_ms = @expirationDays*24*60*60*1000
    current_time_ms = (new Date()).getTime()

    opts =
      path: '/'
      domain: "." + @properties.internal_domain.split(".").slice(-2).join(".")
      expires_at: new Date(current_time_ms + exp_days_ms)

    @cookies.set(@firstTimestampProperty, @firstTimestampProperty, opts)

  getFirstTouch: (value)->
    first_touch_source:    value
    first_touch_timestamp: (new Date()).toISOString()

  getLastTouch: (value)->
    last_touch_source:        value
    last_touch_timestamp:     (new Date()).toISOString()
    last_touch_start_session: true
    last_touch_utm_source:    @utm.source   || null
    last_touch_utm_medium:    @utm.medium   || null
    last_touch_utm_term:      @utm.term     || null
    last_touch_utm_content:   @utm.content  || null
    last_touch_utm_campaign:  @utm.campaign || null
