describe "MixingpanelSession", ->
  beforeAll ->
    jasmine.clock().install()
    
    # WoW SKYNET is here!!
    @judgmentDate = new Date(1997, 8, 29)
    jasmine.clock().mockDate(@judgmentDate)
    

  describe "start session", ->
    it "should detect the mp_session_start", ->

      mpp = new MixingpanelProperties("google.es",
                                      "http://google.es/",
                                      "?utm_source=foo&utm_medium=bar&utm_term=this+that&utm_content=zap&utm_campaign=meh&mp_session_start=10")

      mps = new MixingpanelSession(mpp)

      expect(mps.mp_session).toEqual
        start: "10"
        end: undefined

    it "should add mixpanel superproperty", ->
      spyOn(mixpanel, "register")


      mpp = new MixingpanelProperties("google.es",
                                      "http://google.es/",
                                      "?utm_source=foo&utm_medium=bar&utm_term=this+that&utm_content=zap&utm_campaign=meh&mp_session_start=10")


      mps = new MixingpanelSession(mpp)

      expect(mixpanel.register).toHaveBeenCalledWith
        mp_session_id: "10"
        mp_session_timestamp: (new Date()).toISOString()

    it "shouldn't detect the mp_session_start", ->
      spyOn(mixpanel, "register")

      mpp = new MixingpanelProperties("google.es",
                                      "http://google.es/",
                                      "?utm_source=foo&utm_medium=bar&utm_term=this+that&utm_content=zap&utm_campaign=meh")

      mps = new MixingpanelSession(mpp)

      expect(mps.mp_session).toEqual
        start: undefined
        end: undefined

      expect(mixpanel.register).not.toHaveBeenCalled

  describe "end session", ->
    it "should detect the mp_session_end", ->
      mpp = new MixingpanelProperties("google.es",
                                      "http://google.es/",
                                      "?utm_source=foo&utm_medium=bar&utm_term=this+that&utm_content=zap&utm_campaign=meh&mp_session_end=1")

      mps = new MixingpanelSession(mpp)

      expect(mps.mp_session).toEqual
        start: undefined
        end: "1"

    it "should remove mixpanel superproperty", ->
      spyOn(mixpanel, "unregister")

      mpp = new MixingpanelProperties("google.es",
                                      "http://google.es/",
                                      "?utm_source=foo&utm_medium=bar&utm_term=this+that&utm_content=zap&utm_campaign=meh&mp_session_end=1")

      mps = new MixingpanelSession(mpp)

      expect(mixpanel.unregister.calls.count()).toEqual(2)
      expect(mixpanel.unregister).toHaveBeenCalledWith("mp_session_id")
      expect(mixpanel.unregister).toHaveBeenCalledWith("mp_session_timestamp")

    it "shouldn't detect the mp_session_end", ->
      mpp = new MixingpanelProperties("google.es",
                                      "http://google.es/",
                                      "?utm_source=foo&utm_medium=bar&utm_term=this+that&utm_content=zap&utm_campaign=meh&mp_session_ASDend=1")

      mps = new MixingpanelSession(mpp)

      expect(mps.mp_session).toEqual
        start: undefined
        end: undefined
