describe "MixingpanelSource", ->
  beforeEach ->
    @internal_domain = "kelisto.es"

  it "should parse UTM params successfully", ->
    mpp = new MixingpanelProperties("kelisto.es",
                                    "http://google.es/",
                                    "?utm_source=foo&utm_medium=bar&utm_term=this+that&utm_content=zap&utm_campaign=meh")
    mps = new MixingpanelSource(mpp)

    expect(mps.utm).toEqual
      source:   "foo"
      medium:   "bar"
      term:     "this+that"
      content:  "zap"
      campaign: "meh"

  describe "retrieve source value", ->
    it "should return Email when the utm_medium is 'email'", ->
      mpp = new MixingpanelProperties("kelisto.es",
                                      "http://kelisto.es/",
                                      "?utm_source=foo&utm_medium=email&utm_campaign=bar")
      mps = new MixingpanelSource(mpp)
      expect(mps.getValue()).toEqual("Email")

    it "should return SEM when the utm_medium is 'ppc'", ->
      mpp = new MixingpanelProperties("kelisto.es",
                                      "http://google.es/",
                                      "?utm_source=foo&utm_medium=ppc&utm_campaign=bar")
      mps = new MixingpanelSource(mpp)
      expect(mps.getValue()).toEqual("SEM")

    it "should return SEM when the utm_medium is 'banner'", ->
      mpp = new MixingpanelProperties("kelisto.es",
                                      "http://google.es/",
                                      "?utm_source=foo&utm_medium=banner&utm_campaign=bar")
      mps = new MixingpanelSource(mpp)
      expect(mps.getValue()).toEqual("SEM")

    it "should return SEO when there aren't UTM params and referer is google", ->
      mpp = new MixingpanelProperties("kelisto.es", "http://www.google.es/")
      mps = new MixingpanelSource(mpp)
      expect(mps.getValue()).toEqual("SEO")

    it "should return Referral when referer is not a Social network", ->
      mpp = new MixingpanelProperties("kelisto.es", "http://foo.bar.org")
      mps = new MixingpanelSource(mpp)
      expect(mps.getValue()).toEqual("Referral")

    it "should return Social when referer is a Social network", ->
      mpp = new MixingpanelProperties("kelisto.es", "http://facebook.com")
      mps = new MixingpanelSource(mpp)
      expect(mps.getValue()).toEqual("Social")

    it "should return Direct when there is no referer", ->
      mpp = new MixingpanelProperties("kelisto.es", "")
      mps = new MixingpanelSource(mpp)
      expect(mps.getValue()).toEqual("Direct")

  describe "append value on source super-properties", ->
    it "shouldn't set any property if it's and internal referer", ->
      mpp = new MixingpanelProperties("kelisto.es", "http://meh.kelisto.es")
      mps = new MixingpanelSource(mpp, append: false)

      spyOn mixpanel, "register"

      mps.append()

      expect(mixpanel.register).not.toHaveBeenCalled()

    it "should set the first touch source property", ->
      mpp = new MixingpanelProperties("kelisto.es", "http://www.google.com")
      mps = new MixingpanelSource(mpp, append: false)

      spyOn(mps, "writeSource")
      spyOn(mps, "writeLastTouch")
      spyOn(mps, "firstTouchIsExpired").andReturn(true)
      spyOn(mixpanel, "register")

      mps.append()

      expect(mixpanel.register).toHaveBeenCalled()

    it "shouldn't set the first touch property if it is already setted", ->
      mpp = new MixingpanelProperties("kelisto.es", "http://www.google.com")
      mps = new MixingpanelSource(mpp, append: false)

      spyOn(mps, "writeSource")
      spyOn(mps, "writeLastTouch")
      spyOn(mixpanel, "register")
      spyOn(mps, "firstTouchIsExpired").andReturn(false)

      mps.append()

      expect(mixpanel.register).not.toHaveBeenCalled()

    it "should set the last touch source property", ->
      mpp = new MixingpanelProperties("kelisto.es", "http://www.facebook.com")
      mps = new MixingpanelSource(mpp, append: false)

      spyOn(mps, "writeSource")
      spyOn(mps, "writeFirstTouch")
      spyOn(mixpanel, "register")

      mps.append()

      prop = {}
      prop[mps.lastSourceProperty] = "Social"
      expect(mixpanel.register).toHaveBeenCalledWith(prop)

    it "should add the first value to source property if it's undefined", ->
      mpp = new MixingpanelProperties("kelisto.es", "http://www.facebook.com")
      mps = new MixingpanelSource(mpp, append: false)

      spyOn(mps, "writeFirstTouch")
      spyOn(mps, "writeLastTouch")
      spyOn(mixpanel, "register")
      spyOn(mixpanel, "get_property").andReturn(undefined)

      mps.append()

      prop = {}
      prop[mps.sourceProperty] = ['Social']
      expect(mixpanel.register).toHaveBeenCalledWith(prop)

    it "should append value to source property if the last value isn't the same", ->
      mpp = new MixingpanelProperties("kelisto.es", "http://www.facebook.com")
      mps = new MixingpanelSource(mpp, append: false)
      array = ['Direct']

      spyOn(mps, "writeFirstTouch")
      spyOn(mps, "writeLastTouch")
      spyOn(mixpanel, "get_property").andReturn(array)
      spyOn(array, "push")

      mps.append()

      expect(array.push).toHaveBeenCalledWith('Social')

    it "shouldn't add value to source property if the last value is the same", ->
      mpp = new MixingpanelProperties("kelisto.es", "http://www.facebook.com")
      mps = new MixingpanelSource(mpp, append: false)
      array = ['Social']

      spyOn(mps, "writeFirstTouch")
      spyOn(mps, "writeLastTouch")
      spyOn(mixpanel, "get_property").andReturn(array)
      spyOn(array, "push")

      mps.append()

      expect(array.push).not.toHaveBeenCalledWith('Social')
