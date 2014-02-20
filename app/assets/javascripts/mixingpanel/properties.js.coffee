class @MixingpanelProperties
  constructor: (@internal_domain = window.location.host, url, search) ->
    @location = @_getLocation(search)
    @referer = if url? then url else ($("body").data('referer') || document.referrer)
    @uri = @_getUri()
    @host = if @uri.host? then @uri.host.toLowerCase().replace(/^www\./, '') else ""

    @engine = @_getEngine()
    @search_terms = @_getSearchTerms()
    @search_terms_string = @search_terms.join(' ')
    @type = @_getType()

  _getLocation: (search) ->
    keys = [ 'protocol', 'hostname', 'host', 
             'pathname', 'port', 'search', 'hash', 'href']

    location = {}
    location.query_string = {}

    location[key] = window.location[key] for key in keys
    location.search = search if search?
    location.search.replace /[?&]+([^=&]+)=([^&]*)/gi, (m, key, value) ->
      location.query_string[key] = decodeURIComponent value;

    location

  _getUri: ->
    return {} if @referer is ""

    keys = [ 'protocol', 'hostname', 'host', 
             'pathname', 'port', 'search', 'hash', 'href']

    anchor = document.createElement('a')
    anchor.href = @referer

    uri = {}
    uri[key] = anchor[key] for key in keys
    uri

  _getEngine: ->
    if @google()
      "google"
    else if @yahoo()
      "yahoo"
    else if @bing()
      'bing'
    else
      null

  _getSearchTerms: ->
    return [] if not @engine? or not @uri.search? or @uri.search is ""

    if @uri.search?
      key = if @engine is 'yahoo' then 'p' else 'q' # Yahoo are special with a 'p'
      
      query_string = @uri.search.split("#{key}=")
      return [] unless query_string.length > 1

      query_string = query_string[1].split('&')[0]
      if query_string.indexOf('%20', 0) > 0
        query_string.split('%20')
      else
        query_string.split('+')

  _getType: ->
    if @referer == ""
      "Direct"
    else if @location.query_string.utm_campaign? and @location.query_string.utm_campaign.match /^sem/
      "SEM"
    else if @engine?
      "SEO"
    else
      "Referral"

  google: ->
    !@host.match(/plus.google\.[a-z]{2,4}/) && @host.match(/google\.[a-z]{2,4}/)

  yahoo: ->
    @host.match(/yahoo\.com$/)

  bing: ->
    @host.match(/bing\.com$/)

  isInternal: ->
    domain = @internal_domain.split('.').slice(-2).join('.')
    if @host.match("#{domain}$") then true else false

  isSocial: ->
    (@host.match(/busuu\.com$/) or
     @host.match(/delicious\.com$/) or
     @host.match(/facebook\.com$/) or
     @host.match(/flickr\.com$/) or
     @host.match(/foursquare\.com$/) or
     @host.match(/plus.google\.com$/) or
     @host.match(/hi5\.com$/) or
     @host.match(/linkedin\.com$/) or
     @host.match(/myspace\.com$/) or
     @host.match(/pinterest\.com$/) or
     @host.match(/sonico\.com$/) or
     @host.match(/tuenti\.com$/) or
     @host.match(/tumblr\.com$/) or
     @host.match(/twitter\.com$/) or
     @host.match(/t\.co$/) or
     @host.match(/xing\.com$/))?

  pageName: ->
    if (@location.pathname == '/')
      "Home"
    else if $('body').data('page-name')?
      $('body').data('page-name')
    else if $('article').data('page-name')?
      $('article').data('page-name')
    else if $('article h1').html()?
      $('article h1').html()
    else if $('h1').html()?
      $('h1').html()
    else if $('article h2').html()?
      $('article h2').html()
    else if $('h2').html()?
      $('h2').html()
    else if $('article h3').html()?
      $('article h3').html()
    else if $('h3').html()?
      $('h3').html()
    else
      "unknown"

  pageType: ->
    $("body").data('page-type') or "Default"
