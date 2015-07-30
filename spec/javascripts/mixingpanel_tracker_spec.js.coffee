describe "MixingpanelTracker", ->
  beforeEach ->
    jasmine.getFixtures().fixturesPath = "__spec__/fixtures"
    @mixingpanel_tracker = new MixingpanelTracker
      internal_domain: "bar.org"

  describe "link tracker", ->
    it "should append body global properties when tracking", ->
      loadFixtures "link_tracker.html"
      spyOn(@mixingpanel_tracker.properties, 'globals').and.returnValue({"body-property":"body property"})
      spyOn mixpanel, 'track_links'

      @mixingpanel_tracker.bind()

      selector    = "#tracked-link"
      event       = "EXAMPLE EVENT"
      props = 
        "body-property": "body property"
        "Page name": @mixingpanel_tracker.properties.pageName()
        "origin": @mixingpanel_tracker.properties.referer,
        "link": document.URL
      extra_props = $.extend(props, {foo: "bar"})
      expect(mixpanel.track_links).toHaveBeenCalledWith(selector, event, extra_props)

    it "should create a random id for a tracked link without id", ->
      loadFixtures "link_tracker.html"
      spyOn @mixingpanel_tracker, 'track_links'
      
      @mixingpanel_tracker.bind()

      expect($(".no_id_link")).toHaveAttr('id')

    it "should call 'track_links' with the right properties", ->
      loadFixtures "link_tracker.html"
      spyOn @mixingpanel_tracker, 'track_links'

      @mixingpanel_tracker.bind()

      selector    = "#tracked-link"
      event       = "EXAMPLE EVENT"
      props = 
        "Page name": @mixingpanel_tracker.properties.pageName()
        "origin": @mixingpanel_tracker.properties.referer,
        "link": document.URL
      extra_props = $.extend(props, {foo: "bar"})
      expect(@mixingpanel_tracker.track_links).toHaveBeenCalledWith(selector, event, extra_props)

  describe "form tracker", ->
    it "should append body global properties when tracking", ->
      loadFixtures "form_tracker.html"
      spyOn(@mixingpanel_tracker.properties, 'globals').and.returnValue({"body-property":"body property"})
      spyOn mixpanel, 'track_forms'

      @mixingpanel_tracker.bind()

      selector    = "#tracked-form"
      event       = "EXAMPLE EVENT"
      extra_props = {"body-property": "body property", foo: "bar"}

      expect(mixpanel.track_forms).toHaveBeenCalledWith(selector, event, extra_props)

    it "should call 'track_forms' with the right properties", ->
      loadFixtures "form_tracker.html"
      spyOn @mixingpanel_tracker, 'track_forms'

      @mixingpanel_tracker.bind()

      selector    = "#tracked-form"
      event       = "EXAMPLE EVENT"
      extra_props = {foo: "bar"}

      expect(@mixingpanel_tracker.track_forms).toHaveBeenCalledWith(selector, event, extra_props)

  describe "event tracker", ->
    it "should append body global properties when tracking", ->
      loadFixtures "event_tracker.html"
      spyOn(@mixingpanel_tracker.properties, 'globals').and.returnValue({"body-property":"body property"})
      spyOn mixpanel, 'track'

      @mixingpanel_tracker.bind()

      event       = "EXAMPLE EVENT"
      body_props  = {"body-property": "body property"}
      extra_props = $.extend(body_props, {foo: "bar"})
      expect(mixpanel.track).toHaveBeenCalledWith(event, extra_props, undefined)

    it "should call 'track' with the right properties", ->
      loadFixtures "event_tracker.html"
      spyOn @mixingpanel_tracker, 'track'

      @mixingpanel_tracker.bind()

      event = "EXAMPLE EVENT"
      extra_props = {foo: "bar"}
      expect(@mixingpanel_tracker.track).toHaveBeenCalledWith(event, extra_props)
