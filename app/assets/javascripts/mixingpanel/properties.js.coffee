class @MixingpanelProperties
  constructor: ->
    @referer = $("body").data('referer') || document.referrer
    @uri = @_parseReferer()
    @host = @uri.host.toLowerCase().replace(/^www\./, '')

  _parseReferer: ->
    keys = [ 'protocol', 'hostname', 'host', 
             'pathname', 'port', 'search', 'hash', 'href']

    anchor = document.createElement('a')
    anchor.href = @referer

    uri = {}
    uri[key] = anchor[key] for key in keys
    uri

  type: ->
    if @referer == ""
      "Direct"
    else if @searchEngineType()?
      "SEO"
    else
      "Referral"

  searchEngine: ->
    [@searchEngineType(), @uri]

  google: ->
    !@host.match(/plus.google\.[a-z]{2,4}/) && @host.match(/google\.[a-z]{2,4}/)

  yahoo: ->
    @host.match(/yahoo\.com$/)

  bing: ->
    @host.match(/bing\.com$/)

  searchEngineType: ->
    if @google()
      @engine = 'google'
    else if @yahoo()
      @engine = 'yahoo'
    else if @bing()
      @engine = 'bing'
    else
      @engine = null
    @engine

  search_terms: ->
    @searchEngine(@url)
    if @engine?
      split_by = if @engine is 'yahoo' then 'p' else 'q' #yahoo are special with a p
      return unless @uri.search?
      return if @uri.search is ""
      query_string = @uri.search.split("#{split_by}=")[1].split('&')[0]
      return if query_string is ""
      if query_string.indexOf('%20', 0) > 0
        query_string.split('%20')
      else
        query_string.split('+')

  search_terms_concatenated: (search_terms) ->
    search_terms.join(' ')

  isItInternal: ->
    kelisto_site = @host.match(/kelisto\.es$/)
    if kelisto_site? then "si" else "no"

  isSocial: ->
    (@host.match(/busuu\.com$/) or
     @host.match(/delicious\.com$/) or
     @host.match(/facebook\.com$/) or
     @host.match(/flickr\.com$/) or
     @host.match(/foursquare\.com$/) or
     @host.match(/plus.google\.com$/) or
     @host.match(/h15\.com$/) or
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
    page_name = "unknown"
    if ($('body.landing-page').html()?)
      page_name = "Landing Page: " + window.location.href.split("?")[0]
    else if ($('article').attr('data-page-name')?)
      page_name = $('article').attr('data-page-name')
    else if (window.location.pathname == '/')
      page_name = "Home"
    else if ($('article h1').html()?)
      page_name = $('article h1').html()
    else if ($('h1').html()?)
      page_name = $('h1').html()
    else if ($('article h2').html()?)
      page_name = $('article h2').html()
    else if ($('h2').html()?)
      page_name = $('h2').html()
    else if ($('article h3').html()?)
      page_name = $('article h3').html()
    else if ($('h3').html()?)
      page_name = $('h3').html()
    page_name
