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

      spyOn(mps, "getFirstTouch")
      spyOn(mps, "getLastTouch")

      mps.append()

      expect(mps.getFirstTouch).not.toHaveBeenCalled()
      expect(mps.getLastTouch).not.toHaveBeenCalled()

    it "should set the first touch source property", ->
      mpp = new MixingpanelProperties("kelisto.es", "http://www.google.com")
      mps = new MixingpanelSource(mpp, append: false)

      spyOn(mps, "getFirstTouch")
      spyOn(mps, "firstTouchIsExpired").and.returnValue(true)

      mps.append()

      expect(mps.getFirstTouch).toHaveBeenCalled()

    it "shouldn't set the first touch property if it is already setted", ->
      mpp = new MixingpanelProperties("kelisto.es", "http://www.google.com")
      mps = new MixingpanelSource(mpp, append: false)

      spyOn(mps, "getFirstTouch")
      spyOn(mps, "firstTouchIsExpired").and.returnValue(false)

      mps.append()

      expect(mps.getFirstTouch).not.toHaveBeenCalled()

    it "should set the last touch source property", ->
      mpp = new MixingpanelProperties("kelisto.es", "http://www.facebook.com")
      mps = new MixingpanelSource(mpp, append: false)

      spyOn(mixpanel, "register")

      mps.append()

      source = mixpanel.register.calls.mostRecent().args[0].last_touch_source
      expect(source).toEqual("Social")
