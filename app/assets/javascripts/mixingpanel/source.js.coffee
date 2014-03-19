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
    value = @getValue()
    @writeReferenceTouch(value)
    if @registerSouce()
      @writeFirstTouch(value)
      @writeLastTouch(value)
      @writeSource(value)
      value

  registerSouce: ->
    @utm.medium isnt undefined or !@properties.isInternal()

  firstTouchIsExpired: ()->
    first_touch_ms = (new Date(mixpanel.get_property(@firstTimestampProperty))).getTime()
    exp_days_ms = @expirationDays*24*60*60*1000
    current_time_ms = (new Date()).getTime()

    isNaN(first_touch_ms) or ((first_touch_ms + exp_days_ms) < current_time_ms)

  writeReferenceTouch: (value)->
    mixpanel.register @propertiesFor(value, "ref_touch")

  writeFirstTouch: (value)->
    mixpanel.register @propertiesFor(value, "first_touch") if @firstTouchIsExpired()

  writeLastTouch: (value)->
    mixpanel.register @propertiesFor(value, "last_touch")

  writeSource: (value)->
    source = mixpanel.get_property(@sourceProperty)
    if source
      if source[source.length-1] != value
        mixpanel.get_property(@sourceProperty).push(value)
    else
      prop = {}
      prop[@sourceProperty] = [value]
      mixpanel.register(prop)

  propertiesFor: (source, base_name = "last_touch")->
    props = {}
    props[base_name+"_source"] = source
    props[base_name+"_timestamp"] = new Date()
    if @properties.location.href?
      props[base_name+"_location_url"] = @properties.location.href
      props[base_name+"_location_domain"] = @properties.location.href.match(/^(https*:\/\/.+)(\/.*)/)[1]
      props[base_name+"_location_path"] = @properties.location.href.match(/^(https*:\/\/.+)(\/.*)/)[2]
    if @properties.uri.href?
      props[base_name+"_referrer_url"] = @properties.uri.href
      props[base_name+"_referrer_domain"] = @properties.uri.href.match(/^(https*:\/\/.+)(\/.*)/)[1]
      props[base_name+"_referrer_path"] = @properties.uri.href.match(/^(https*:\/\/.+)(\/.*)/)[2]
    props[base_name+"_type"] = @properties.type
    props[base_name+"_page_type"] = @properties.pageType()
    props[base_name+"_page_name"] = @properties.pageName()
    props[base_name+"_seach_terms"] = @properties.search_terms

    props
