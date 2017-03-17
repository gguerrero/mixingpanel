describe "MixingpanelParameterizer", ->

  describe "cookie management", ->
    it "should register only whitelisted params on a cookie for tracking", ->
      setMixingpanelOptions(tracking_params: ['foo','bar'])
      mpp  = new MixingpanelProperties("bar.org",
                                       "http://foo.external.com",
                                       "?foo=foo&bar=bar&baz=baz")
      mppa = new MixingpanelParameterizer(mpp)

      expect(mppa.read()).toEqual
        foo: "foo"
        bar: "bar"

    it "should remove cookie always if referral is external", ->
      setMixingpanelOptions(tracking_params: ['foo','bar'])
      mpp  = new MixingpanelProperties("bar.org",
                                       "http://foo.external.com")
      mppa = new MixingpanelParameterizer(mpp)

      expect(mppa.read()).toBe undefined

    it "should not create the cookie when referrer is internal", ->
      setMixingpanelOptions(tracking_params: ['foo','bar'])
      mpp  = new MixingpanelProperties("bar.org",
                                       "http://foo.bar.org",
                                       "?foo=foo&bar=bar&baz=baz")
      mppa = new MixingpanelParameterizer(mpp)

      expect(mppa.read()).toBe undefined
