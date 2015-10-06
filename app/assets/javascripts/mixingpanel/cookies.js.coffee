class @MixingpanelCookies
  constructor: ()->
    @_loadCookies()
    @mainLevelDomain = '.' + window.location.host.split(".").slice(-2).join(".")
    @cookieDefOpts =
      domain: null
      path: null
      expires_at: null

  _loadCookies: ->
    for cookie_token in document.cookie.split("; ")
      [key, value] = cookie_token.split("=")
      try
        @[key] = JSON.parse(decodeURIComponent(value))
      catch
        @[key] = value
    true

  set: (key, value, opts = {})->
    opts = $.extend({}, @cookieDefOpts, opts)

    cookie_value = if typeof(value) is 'string'
      value.replace(";","\\;")
    else
      encodeURIComponent(JSON.stringify(value))

    keyValue = "#{key}=#{cookie_value}"
    domain   = if opts.domain? then "; domain=#{opts.domain}" else ""
    path     = if opts.path? then "; path=#{opts.path}" else ""
    expires  = if opts.expires_at? then "; expires=#{opts.expires_at.toGMTString()}" else ""

    document.cookie = (keyValue + expires + path + domain)
    @[key] = value

  delete: (key)->
    # Multiple set for deleting a domain level and root path cookies
    @set(key, '', {expires_at: new Date(0)})
    @set(key, '', {expires_at: new Date(0), path: '/'})
    @set(key, '', {expires_at: new Date(0), domain: @mainLevelDomain})
    @set(key, '', {expires_at: new Date(0), domain: @mainLevelDomain, path: '/'})

    delete @[key]
