describe "MixingpanelSource", ->
<<<<<<< Updated upstream
=======
  beforeAll ->
    timerCallback = jasmine.createSpy("timerCallback");
    jasmine.clock().install()
    
    # WoW SKYNET is here!!
    @judgmentDate = new Date(1997, 8, 29)
    jasmine.clock().mockDate(@judgmentDate)
>>>>>>> Stashed changes

  afterAll ->
    jasmine.clock().uninstall()

  it "should parse UTM params successfully", ->
    setMixingpanelOptions(source: {append: false})
    mpp = new MixingpanelProperties("bar.org",
                                    "http://google.es/",
                                    "?utm_source=foo&utm_medium=bar&utm_term=this+that&utm_content=zap&utm_campaign=meh")
    mps = new MixingpanelSource(mpp)

    expect(mps.utm).toEqual
      source:   "foo"
      medium:   "bar"
      term:     "this+that"
      content:  "zap"
      campaign: "meh"

  describe "register source", ->
    it "should return true when utm_medium is present", ->
      setMixingpanelOptions(source: {append: false})
      mpp = new MixingpanelProperties("bar.org",
                                      "http://foo.bar.org",
                                      "?utm_source=foo&utm_medium=bar&utm_term=this+that&utm_content=zap&utm_campaign=meh")
      mps = new MixingpanelSource(mpp)

      expect(mps.registerSource()).toBe(true)

    it "should return true when referrer is not internal", ->
      mpp = new MixingpanelProperties("bar.org", "http://google.es")
      mps = new MixingpanelSource(mpp)

      expect(mps.registerSource()).toBe(true)

    it "should return true when exceptional referring domains are given", ->
      setMixingpanelOptions
        external_domains: ['foo.org','bar.org'],
        source:
          append: false

      mpp = new MixingpanelProperties("bar.org", "http://foo.bar.org")
      mps = new MixingpanelSource(mpp)
      expect(mps.registerSource()).toBe(true)

    it "should return false in any other case", ->
      setMixingpanelOptions
        external_domains: ['foo.org','baz.org'],
        source:
          append: false

      mpp = new MixingpanelProperties("bar.org",
                                      "http://foo.bar.org",
                                      "?utm_foo=bar&utm_baz=bar")
      mps = new MixingpanelSource(mpp)
      expect(mps.registerSource()).toBe(false)      
    
  describe "retrieve source value", ->
    it "should return Email when the utm_medium is 'email'", ->
      mpp = new MixingpanelProperties("bar.org",
                                      "http://www.bar.org/",
                                      "?utm_source=foo&utm_medium=email&utm_campaign=bar")
      mps = new MixingpanelSource(mpp)
      expect(mps.getValue()).toEqual("Email")

    it "should return SEM when the utm_medium is 'ppc'", ->
      mpp = new MixingpanelProperties("bar.org",
                                      "http://google.es/",
                                      "?utm_source=foo&utm_medium=ppc&utm_campaign=bar")
      mps = new MixingpanelSource(mpp)
      expect(mps.getValue()).toEqual("SEM")

    it "should return SEM when the utm_medium is 'banner'", ->
      mpp = new MixingpanelProperties("bar.org",
                                      "http://google.es/",
                                      "?utm_source=foo&utm_medium=banner&utm_campaign=bar")
      mps = new MixingpanelSource(mpp)
      expect(mps.getValue()).toEqual("SEM")

    it "should return SEO when there aren't UTM params and referer is google", ->
      mpp = new MixingpanelProperties("bar.org", "http://www.google.es/")
      mps = new MixingpanelSource(mpp)
      expect(mps.getValue()).toEqual("SEO")

    it "should return Referral when referer is not a Social network", ->
      mpp = new MixingpanelProperties("bar.org", "http://foo.bar.org")
      mps = new MixingpanelSource(mpp)
      expect(mps.getValue()).toEqual("Referral")

    it "should return Social when referer is a Social network", ->
      mpp = new MixingpanelProperties("bar.org", "http://facebook.com")
      mps = new MixingpanelSource(mpp)
      expect(mps.getValue()).toEqual("Social")

    it "should return Direct when there is no referer", ->
      mpp = new MixingpanelProperties("bar.org", "")
      mps = new MixingpanelSource(mpp)
      expect(mps.getValue()).toEqual("Direct")

  describe "append value on source super-properties", ->
    it "shouldn't set any property if it's and internal referer", ->
      setMixingpanelOptions(source: {append: false})
      mpp = new MixingpanelProperties("bar.org", "http://foo.bar.org")
      mps = new MixingpanelSource(mpp)

      spyOn(mps, "getFirstTouch")
      spyOn(mps, "getLastTouch")

      mps.append()

      expect(mps.getFirstTouch).not.toHaveBeenCalled()
      expect(mps.getLastTouch).not.toHaveBeenCalled()

    it "should set the first touch source property", ->
      setMixingpanelOptions(source: {append: false})
      mpp = new MixingpanelProperties("bar.org", "http://www.google.com")
      mps = new MixingpanelSource(mpp)

      spyOn(mps, "getFirstTouch")
      spyOn(mps, "firstTouchIsExpired").and.returnValue(true)

      mps.append()

      expect(mps.getFirstTouch).toHaveBeenCalled()

    it "shouldn't set the first touch property if it is already setted", ->
      setMixingpanelOptions(source: {append: false})
      mpp = new MixingpanelProperties("bar.org", "http://www.google.com")
      mps = new MixingpanelSource(mpp)

      spyOn(mps, "getFirstTouch")
      spyOn(mps, "firstTouchIsExpired").and.returnValue(false)

      mps.append()

      expect(mps.getFirstTouch).not.toHaveBeenCalled()

    it "should set the last touch source property", ->
      setMixingpanelOptions(source: {append: false})
      mpp = new MixingpanelProperties("bar.org", "http://www.facebook.com")
      mps = new MixingpanelSource(mpp)

      spyOn(mixpanel, "register")

      mps.append()

      source = mixpanel.register.calls.mostRecent().args[0].last_touch_source
      expect(source).toEqual("Social")

  describe "append properties", ->
    it "should register append props on first session load", ->
      setMixingpanelOptions(source: {append: false})

      expectedProperties =
        first_touch_source:       'SEM'
        first_touch_timestamp:    (new Date()).toISOString()
        last_touch_source:        'SEM'
        last_touch_start_session: true
        last_touch_utm_source:    'foo'
        last_touch_utm_medium:    'ppc'
        last_touch_utm_term:      null
        last_touch_utm_content:   null
        last_touch_utm_campaign:  'bar'

      mpp = new MixingpanelProperties("bar.org",
                                      "http://google.es/",
                                      "?utm_source=foo&utm_medium=ppc&utm_campaign=bar")
      mps = new MixingpanelSource(mpp)

      spyOn(mixpanel, 'register')
      mps.append()

      registrationArgs = mixpanel.register.calls.mostRecent().args[0]

      expect(registrationArgs).toEqual(expectedProperties)

    it "should register false on last_touch_start_session on internal load", ->
      setMixingpanelOptions(source: {append: false})

      mpp = new MixingpanelProperties("bar.org",
                                      "http://www.bar.org/")
      mps = new MixingpanelSource(mpp)

      spyOn(mixpanel, 'register')
      mps.append()

      registrationArgs = mixpanel.register.calls.mostRecent().args[0]
      expect(registrationArgs).toEqual(last_touch_start_session: false)
