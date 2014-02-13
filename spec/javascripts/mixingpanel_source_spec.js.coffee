describe "MixingpanelSource", ->
  beforeEach ->
    @internal_domain = "kelisto.es"

  it "should parse UTM params successfully", ->
    mpp = new MixingpanelProperties("kelisto.es",
                                    "http://google.es/",
                                    "?utm_source=foo&utm_medium=bar&utm_campaign=meh")
    mps = new MixingpanelSource(mpp)

    expect(mps.utm).toEqual
      source:   "foo"
      medium:   "bar"
      campaign: "meh"

  describe "retrieving source value", ->
    it "should return Email when the utm_medium is 'email'", ->
      mpp = new MixingpanelProperties("kelisto.es",
                                      "http://kelisto.es/",
                                      "?utm_source=foo&utm_medium=email&utm_campaign=meh")
      mps = new MixingpanelSource(mpp)
      expect(mps.getValue()).toEqual("Email")

    it "should return SEM when the utm_medium is not 'email'", ->
      mpp = new MixingpanelProperties("kelisto.es",
                                      "http://google.es/",
                                      "?utm_source=foo&utm_medium=bar&utm_campaign=meh")
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