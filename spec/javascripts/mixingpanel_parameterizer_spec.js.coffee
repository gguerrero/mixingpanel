describe "MixingpanelParameterizer", ->

  describe "cookie management", ->
    it "should register only whitelisted params on a cookie for tracking", ->
      mpp  = new MixingpanelProperties("bar.org",
                                       "http://foo.external.com",
                                       "?foo=foo&bar=bar&baz=baz")
      mppa = new MixingpanelParameterizer(mpp, ['foo','bar'])

      expect(mppa.read()).toEqual
        foo: "foo"
        bar: "bar"

    it "should remove cookie always if referral is external", ->
      mpp  = new MixingpanelProperties("bar.org",
                                       "http://foo.external.com")
      mppa = new MixingpanelParameterizer(mpp, ['foo','bar'])

      expect(mppa.read()).toBe undefined

    it "should not create the cookie when referrer is internal", ->
      mpp  = new MixingpanelProperties("bar.org",
                                       "http://foo.bar.org",
                                       "?foo=foo&bar=bar&baz=baz")
      mppa = new MixingpanelParameterizer(mpp, ['foo','bar'])

      expect(mppa.read()).toBe undefined
