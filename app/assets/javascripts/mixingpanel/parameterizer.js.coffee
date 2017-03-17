class @MixingpanelParameterizer
  constructor: (@properties) ->
    @cookies    = new MixingpanelCookies()
    @whitelist  = mixingpanel_options.tracking_params
    @cookieName = 'mp_tracking_params'

    if not @properties.isInternal() or @properties.isExternalDomainException()
      @delete() and @write()

  write: ->
    opts =
      path: '/'
      domain: "." + @properties.internal_domain.split(".").slice(-2).join(".")

    values = @getValues()
    if Object.keys(values).length > 0
      @cookies.set(@cookieName, values, opts)

  read: ->
    @cookies[@cookieName]

  delete: ->
    @cookies.delete(@cookieName)

  getValues: ->
    values = {}
    qs     = @properties.location.query_string

    for whitelist_value in @whitelist
      values[whitelist_value] = qs[whitelist_value] if qs[whitelist_value]?
    values
