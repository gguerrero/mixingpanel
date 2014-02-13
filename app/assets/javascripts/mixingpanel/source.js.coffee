class @MixingpanelSource
  constructor: (@properties) ->
    @expiration_days = 30
    @first_source_property = "first_touch_source"
    @last_source_property = "last_touch_source"
    @source_property = "source"
    @sources =
      SEO: "SEO"
      SEM: "SEM"
      EMAIL: "Email"
      DIRECT: "Direct"
      SOCIAL: "Social"
      REFERRAL: "Referral"
      DISPLAY: "Display"
    @_setUTM()
    true

  _setUTM: ->
    qsObj = @properties.location.query_string
    @utm =
      source: qsObj.utm_source
      medium: qsObj.utm_medium
      campaign: qsObj.utm_campaign

  getValue: () ->
    if @utm.medium? or @utm.campaign?
      if @utm.medium is "email"
        @sources.EMAIL
      else
        @sources.SEM

    else if @properties.engine?
      @sources.SEO

    else if @properties.referer != ""
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
      @write_first_touch(value)
      @write_last_touch(value)
      @write_source(value)

  registerSouce: ->
    !@properties.isInternal()

  write_first_touch: (value)->
    prop = {}
    prop[@first_source_property] = value
    mixpanel.register(prop, @expiration_days) unless mixpanel.get_property(@first_source_property)

  write_last_touch: (value)->
    prop = {}
    prop[@last_source_property] = value
    mixpanel.register(prop)

  write_source: (value)->
    source = mixpanel.get_property(@source_property)
    if source
      if source[source.length-1] != value
        mixpanel.get_property(@source_property).push(value)
    else
      prop = {}
      prop[@source_property] = [value]
      mixpanel.register(prop)
