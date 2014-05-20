class @MixingpanelCookies
  constructor: ()->
    @_loadCookies()
    @cookieDefOpts =
      domain: null
      path: null
      expires_at: null

  _loadCookies: ->
    for cookie_token in document.cookie.split("; ")
      [key, value] = cookie_token.split("=") 
      @[key] = value

  set: (key, value, opts = {})->
    opts  = $.extend(@cookieDefOpts, opts)
    value = value.replace(";","\\;")

    keyValue = "#{key}=#{value}"
    domain   = if opts.domain? then "; domain=#{opts.domain}" else ""
    path     = if opts.path? then "; path=#{opts.path}" else ""
    expires  = if opts.expires_at? then "; expires=#{opts.expires_at.toGMTString()}" else ""

    document.cookie = (keyValue + expires + path + domain)
    @[key] = value

  delete: (key)->
    keyValue = "#{key}="
    expires  = "; expires=#{(new Date(0)).toGMTString()}"

    document.cookie = (keyValue + expires)
    delete @[key]
