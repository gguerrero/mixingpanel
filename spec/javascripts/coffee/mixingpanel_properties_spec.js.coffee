describe "MixingpanelProperties", ->
  it "should get_uri_and_host", ->
    mpp = new MixingpanelProperties("http://www.example.com:8080/blah?meh#wat#wat")
    expect(mpp.host).toBe("example.com:8080")
    expect(mpp.uri.protocol).toBe('http:')
    expect(mpp.uri.hostname).toBe('www.example.com')
    expect(mpp.uri.host).toBe('www.example.com:8080')
    expect(mpp.uri.pathname).toBe('/blah')
    expect(mpp.uri.port).toBe('8080')
    expect(mpp.uri.search).toBe('?meh')
    expect(mpp.uri.hash).toBe('#wat#wat')
    expect(mpp.uri.href).toBe('http://www.example.com:8080/blah?meh#wat#wat')

# describe "MixingpanelProperties", ->
#   it "should get_uri_and_host", ->
#     url = "http://www.example.com:8080/blah?meh#wat#wat"
#     [uri, host] = new MixingpanelProperties(url).get_uri_and_host()
#     expect(host).toBe("example.com:8080")
#     expect(uri.protocol).toBe('http:')
#     expect(uri.hostname).toBe('www.example.com')
#     expect(uri.host).toBe('www.example.com:8080')
#     expect(uri.pathname).toBe('/blah')
#     expect(uri.port).toBe('8080')
#     expect(uri.search).toBe('?meh')
#     expect(uri.hash).toBe('#wat#wat')
#     expect(uri.href).toBe('http://www.example.com:8080/blah?meh#wat#wat')

#   describe "check if search engine", ->
#     it "should get google", ->
#       url = "http://www.google.es?meh#wat#wat"
#       [se, uri] = new KelistoInsight(url).searchEngine(url)
#       expect(se).toBe("google")

#     it "should get yahoo", ->
#       url = "http://www.yahoo.com?meh#wat#wat"
#       [se, uri] = new KelistoInsight(url).searchEngine()
#       expect(se).toBe("yahoo")

#     it "should get bing", ->
#       url = "http://www.bing.com?meh#wat#wat"
#       [se, uri] = new KelistoInsight(url).searchEngine()
#       expect(se).toBe("bing")

#     it "should ignore a regular website", ->
#       url = "http://meh.kelisto.es?meh#wat#wat"
#       [se, uri] = new KelistoInsight(url).searchEngine()
#       expect(se).toBeNull()

#     it "should ignore google plus", ->
#       url = "http://plus.google.com?meh#wat#wat"
#       [se, uri] = new KelistoInsight(url).searchEngine()
#       expect(se).toBeNull()

#     it "should get the keywords for a google referrer", ->
#       url = "http://www.google.com.ar/url?sa=t&rct=j&q=compra%20de%20vehiculos%20en%20el%20extranjero%20por%20internet&source=web&cd=4&ved=0CFMQFjAD&url=http%3A%2F%2Fwww.kelisto.es"
#       terms = new KelistoInsight(url).search_terms()
#       expect(terms).toEqual([ 'compra', 'de', 'vehiculos', 'en', 'el', 'extranjero', 'por', 'internet' ])

#     it "should get the keywords for a yahoo referrer", ->
#       url = "http://www.yahoo.com/?p=special+search+term&"
#       terms = new KelistoInsight(url).search_terms()
#       expect(terms).toEqual([ 'special', 'search', 'term' ])

#     it "should get the keywords for a bing referrer", ->
#       url = "http://www.bing.com/?q=special+search+term"
#       terms = new KelistoInsight(url).search_terms()
#       expect(terms).toEqual([ 'special', 'search', 'term' ])

#     it "should have empty keywords for an unknown referrer", ->
#       url = "http://www.example.com/?q=special+search+term"
#       terms = new KelistoInsight(url).search_terms()
#       expect(terms).toBeUndefined()

#     it "should have empty keywords with empty parameters", ->
#       url = "http://www.google.com/?q="
#       terms = new KelistoInsight(url).search_terms()
#       expect(terms).toBeUndefined()

#     it "should have empty keywords with no parameters", ->
#       url = "https://www.google.com/"
#       terms = new KelistoInsight(url).search_terms()
#       expect(terms).toBeUndefined()

#     it "should concatenate the keywords for a seo referrer", ->
#       url = "http://www.google.com.ar/url?sa=t&rct=j&q=compra%20de%20vehiculos%20en%20el%20extranjero%20por%20internet&source=web&cd=4&ved=0CFMQFjAD&url=http%3A%2F%2Fwww.kelisto.es"
#       terms = new KelistoInsight(url).search_terms()
#       terms_concatenated = new KelistoInsight(url).search_terms_concatenated(terms)
#       expect(terms_concatenated).toEqual('compra de vehiculos en el extranjero por internet')

#   describe "check if internal", ->
#     it "should return si if kelisto.es domain", ->
#       url = "http://meh.kelisto.es?meh#wat#wat"
#       internal_site = new KelistoInsight(url).isItInternal()
#       expect(internal_site).toBe("si")

#     it "should return no if not kelisto.es domain", ->
#       url = "http://meh.helisto.es?kelisto.es#wat#wat"
#       internal_site = new KelistoInsight(url).isItInternal()
#       expect(internal_site).toBe("no")

#   describe "check if social", ->
#     it "should return no if not social", ->
#       url = "http://meh.kelisto.es?meh#wat#wat"
#       social = new KelistoInsight(url).isItASocialSite()
#       expect(social).toBe("no")

#     it "should return si if twitter", ->
#       url = "http://meh.twitter.com?meh#wat#wat"
#       social = new KelistoInsight(url).isItASocialSite()
#       expect(social).toBe("si")

#     it "should return si if t.co", ->
#       url = "http://t.co?meh#wat#wat"
#       social = new KelistoInsight(url).isItASocialSite()
#       expect(social).toBe("si")

#     it "should return si if facebook", ->
#       url = "http://meh.facebook.com?meh#wat#wat"
#       social = new KelistoInsight(url).isItASocialSite()
#       expect(social).toBe("si")

#     it "should return si if G+", ->
#       url = "http://plus.google.com?meh#wat#wat"
#       social = new KelistoInsight(url).isItASocialSite()
#       expect(social).toBe("si")

#     it "should return no if regular google", ->
#       url = "http://meh.google.com?meh#wat#wat"
#       social = new KelistoInsight(url).isItASocialSite()
#       expect(social).toBe("no")

#   describe "event/type name", ->
#     it "should get 'Kelisto Direct' for a non referrer", ->
#       url  = ""
#       type = new KelistoInsight(url).type()
#       expect(type).toBe("Kelisto Direct")

#     it "should get 'Kelisto SEO' for a google referrer", ->
#       url  = "https://google.com"
#       type = new KelistoInsight(url).type()
#       expect(type).toBe("Kelisto SEO")

#     it "should get 'Kelisto SEO' for a yahoo referrer", ->
#       url  = "http://www.yahoo.com"
#       type = new KelistoInsight(url).type()
#       expect(type).toBe("Kelisto SEO")

#     it "should get 'Kelisto SEO' for a bing referrer", ->
#       url  = "http://www.bing.com"
#       type = new KelistoInsight(url).type()
#       expect(type).toBe("Kelisto SEO")

#     it "should get 'Kelisto Referral' for an internal referrer", ->
#       url  = "http://www.kelisto.es/"
#       type = new KelistoInsight(url).type()
#       expect(type).toBe("Kelisto Referral")

#     it "should get 'Kelisto Referral' for a facebook referrer", ->
#       url  = "http://facebook.com"
#       type = new KelistoInsight(url).type()
#       expect(type).toBe("Kelisto Referral")

#     it "should get 'Kelisto Referral' for a google+ referrer", ->
#       url  = "http://plus.google.com"
#       type = new KelistoInsight(url).type()
#       expect(type).toBe("Kelisto Referral")

#     it "should get 'Kelisto Referral' for a foo.bar referrer", ->
#       url  = "http://foo.bar.com"
#       type = new KelistoInsight(url).type()
#       expect(type).toBe("Kelisto Referral")

#   describe "track buttons", ->
#     it "should call 'trackButton' with the right properties", ->
#       loadFixtures 'trackme_button'
#       spyOn KelistoInsight, 'trackButton'

#       KelistoInsight.trackButtons()

#       selector    = "#tracked-button"
#       event       = "TRACKME EXAMPLE"
#       extra_props = {foo: "bar"}
#       expect(KelistoInsight.trackButton).toHaveBeenCalledWith(selector, event, extra_props)

#   describe "track pages", ->
#     describe "homepage", ->
#       it "should call 'trackIt' with the right properties", ->
#         loadFixtures 'trackme_homepage_view'
#         spyOn KelistoInsight, 'trackIt'

#         KelistoInsight.trackPage()

#         extra_props = {}
#         expect(KelistoInsight.trackIt).toHaveBeenCalledWith(extra_props)

#     describe "articles", ->
#       it "should call 'trackIt' with the right properties", ->
#         loadFixtures 'trackme_article_view'
#         spyOn KelistoInsight, 'trackIt'

#         KelistoInsight.trackPage()

#         extra_props = {"product": "Example Product", "sub-product": "Example SubProduct"}
#         expect(KelistoInsight.trackIt).toHaveBeenCalledWith(extra_props)

#   describe "track emails", ->
#     it "should call 'trackIt' with the right properties", ->
#       loadFixtures 'trackme_email_view'
#       spyOn KelistoInsight, 'trackIt'
#       spyOn KelistoInsight, 'setMixpanelPeople'
#       spyOn(KelistoInsight, 'getWindowLocation').andReturn('http://example.com/foo/bar?date=18_10_2013&campaign=newsletter&mail=user%40example.com')

#       KelistoInsight.trackPage()

#       extra_props = {'Email campaign' : 'Email_Newsletter_Weekly_20131018'}
#       expect(KelistoInsight.setMixpanelPeople).toHaveBeenCalledWith("user@example.com")
#       expect(KelistoInsight.trackIt).toHaveBeenCalledWith(extra_props)

#   describe "track redirects", ->
#     it "should call mixpanelTrack with the right propeties", ->
#       loadFixtures 'trackme_redirect'
#       spyOn KelistoInsight, 'mixpanelTrack'

#       KelistoInsight.trackRedirects()

#       extra_props = {
#         'Referral type': ['communications', 'mobile'],
#         'Referral reference': 'mob-Simyo Tarifa 2 cent',
#         'Referral url': 'http://referer.com/foo/bar'
#       }
#       expect(KelistoInsight.mixpanelTrack).toHaveBeenCalledWith('Page interaction', extra_props)
