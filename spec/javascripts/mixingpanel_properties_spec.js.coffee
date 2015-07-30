describe "MixingpanelProperties", ->
  beforeEach ->
    @internal_domain = "bar.org"
  
  it "should map URI and host", ->
    mpp = new MixingpanelProperties(@internal_domain, "http://www.example.com:8080/blah?meh#wat#wat")
    expect(mpp.host).toBe("example.com")
    expect(mpp.uri.protocol).toBe('http:')
    expect(mpp.uri.hostname).toBe('www.example.com')
    expect(mpp.uri.host).toBe('www.example.com:8080')
    expect(mpp.uri.pathname).toBe('/blah')
    expect(mpp.uri.port).toBe('8080')
    expect(mpp.uri.search).toBe('?meh')
    expect(mpp.uri.hash).toBe('#wat#wat')
    expect(mpp.uri.href).toBe('http://www.example.com:8080/blah?meh#wat#wat')

  describe "check if search engine", ->
    it "should get google", ->
      mpp = new MixingpanelProperties(@internal_domain, "http://www.google.es?meh#wat#wat")
      expect(mpp.engine).toBe("google")

    it "should get yahoo", ->
      mpp = new MixingpanelProperties(@internal_domain, "http://www.yahoo.com?meh#wat#wat")
      expect(mpp.engine).toBe("yahoo")

    it "should get bing", ->
      mpp = new MixingpanelProperties(@internal_domain, "http://www.bing.com?meh#wat#wat")
      expect(mpp.engine).toBe("bing")

    it "should ignore a regular website", ->
      mpp = new MixingpanelProperties(@internal_domain, "http://meh.bar.org?q=meh#wat#wat")
      expect(mpp.engine).toBeNull()
      expect(mpp.search_terms).toEqual([])

    it "should ignore google plus", ->
      mpp = new MixingpanelProperties(@internal_domain, "http://plus.google.com?q=meh#wat#wat")
      expect(mpp.engine).toBeNull()
      expect(mpp.search_terms).toEqual([])

    it "should get the keywords for a google referrer", ->
      mpp = new MixingpanelProperties(@internal_domain, "http://www.google.com.ar/url?sa=t&rct=j&q=compra%20de%20vehiculos%20en%20el%20extranjero%20por%20internet&source=web&cd=4&ved=0CFMQFjAD&url=http%3A%2F%2Fwww.bar.org")
      expect(mpp.search_terms).toEqual([ 'compra', 'de', 'vehiculos', 'en', 'el', 'extranjero', 'por', 'internet' ])

    it "should get the keywords for a yahoo referrer", ->
      mpp = new MixingpanelProperties(@internal_domain, "http://www.yahoo.com/?p=special+search+term&")
      expect(mpp.search_terms).toEqual([ 'special', 'search', 'term' ])

    it "should get the keywords for a bing referrer", ->
      mpp = new MixingpanelProperties(@internal_domain, "http://www.bing.com/?q=special+search+term")
      expect(mpp.search_terms).toEqual([ 'special', 'search', 'term' ])

    it "should have empty keywords for an unknown referrer", ->
      mpp = new MixingpanelProperties(@internal_domain, "http://www.example.com/?q=special+search+term")
      expect(mpp.search_terms).toEqual([])

    it "should have empty keywords with empty parameters", ->
      mpp = new MixingpanelProperties(@internal_domain, "http://www.google.com/?q=")
      expect(mpp.search_terms).toEqual([''])

    it "should have empty keywords with no parameters", ->
      mpp = new MixingpanelProperties(@internal_domain, "https://www.google.com/")
      expect(mpp.search_terms).toEqual([])

    it "should concatenate the keywords for a seo referrer", ->
      mpp = new MixingpanelProperties(@internal_domain, "http://www.google.com.ar/url?sa=t&rct=j&q=compra%20de%20vehiculos%20en%20el%20extranjero%20por%20internet&source=web&cd=4&ved=0CFMQFjAD&url=http%3A%2F%2Fwww.bar.org")
      expect(mpp.search_terms_string).toEqual('compra de vehiculos en el extranjero por internet')

  describe "check if internal", ->
    it "should return True if bar.org domain", ->
      mpp = new MixingpanelProperties(@internal_domain, "http://meh.bar.org?meh#wat#wat")
      expect(mpp.isInternal()).toBe(true)

    it "should return False if not bar.org domain", ->
      mpp = new MixingpanelProperties(@internal_domain, "http://meh.helisto.es?bar.org#wat#wat")
      expect(mpp.isInternal()).toBe(false)

  describe "check if social", ->
    it "should return False if not social", ->
      mpp = new MixingpanelProperties(@internal_domain, "http://meh.bar.org?meh#wat#wat")
      expect(mpp.isSocial()).toBe(false)

    it "should return True if twitter", ->
      mpp = new MixingpanelProperties(@internal_domain, "http://meh.twitter.com?meh#wat#wat")
      expect(mpp.isSocial()).toBe(true)

    it "should return True if t.co", ->
      mpp = new MixingpanelProperties(@internal_domain, "http://t.co?meh#wat#wat")
      expect(mpp.isSocial()).toBe(true)

    it "should return True if facebook", ->
      mpp = new MixingpanelProperties(@internal_domain, "http://meh.facebook.com?meh#wat#wat")
      expect(mpp.isSocial()).toBe(true)

    it "should return True if G+", ->
      mpp = new MixingpanelProperties(@internal_domain, "http://plus.google.com?meh#wat#wat")
      expect(mpp.isSocial()).toBe(true)

    it "should return False if regular google", ->
      mpp = new MixingpanelProperties(@internal_domain, "http://meh.google.com?meh#wat#wat")
      expect(mpp.isSocial()).toBe(false)

  describe "event/type name", ->
    it "should get 'Direct' for a non referrer", ->
      mpp = new MixingpanelProperties(@internal_domain, "")
      expect(mpp.type).toEqual("Direct")

    it "should get 'SEO' for a google referrer", ->
      mpp = new MixingpanelProperties(@internal_domain, "https://google.com")
      expect(mpp.type).toEqual("SEO")

    it "should get 'SEO' for a yahoo referrer", ->
      mpp = new MixingpanelProperties(@internal_domain, "http://www.yahoo.com")
      expect(mpp.type).toEqual("SEO")

    it "should get 'SEO' for a bing referrer", ->
      mpp = new MixingpanelProperties(@internal_domain, "http://www.bing.com")
      expect(mpp.type).toEqual("SEO")

    it "should get 'SEM' when utm_medium param is 'ppc'", ->
      mpp = new MixingpanelProperties(@internal_domain, "https://google.com", "?utm_medium=ppc")
      expect(mpp.type).toEqual("SEM")

    it "should get 'Display' when utm_medium param is 'banner'", ->
      mpp = new MixingpanelProperties(@internal_domain, "https://google.com", "?utm_medium=banner")
      expect(mpp.type).toEqual("Display")

    it "should get 'Referral' for an internal referrer", ->
      mpp = new MixingpanelProperties(@internal_domain, "http://www.bar.org/")
      expect(mpp.type).toEqual("Referral")

    it "should get 'Referral' for a facebook referrer", ->
      mpp = new MixingpanelProperties(@internal_domain, "http://facebook.com")
      expect(mpp.type).toEqual("Referral")

    it "should get 'Referral' for a google+ referrer", ->
      mpp = new MixingpanelProperties(@internal_domain, "http://plus.google.com")
      expect(mpp.type).toBe("Referral")

    it "should get 'Referral' for a foo.bar referrer", ->
      mpp = new MixingpanelProperties(@internal_domain, "http://foo.bar.com")
      expect(mpp.type).toBe("Referral")
