describe "MixingpanelTracker", ->
  beforeEach ->
    jasmine.getFixtures().fixturesPath = "__spec__/fixtures"
    @internal_domain = "kelisto.es"

  describe "link tracker", ->
    it "should create a random id for a tracked link without id", ->
      loadFixtures "link_tracker.html"
      spyOn mixingpanel_tracker, 'track_links'
      
      mixingpanel_tracker.activate(@internal_domain)

      expect($(".no_id_link")).toHaveAttr('id')

    it "should call 'track_links' with the right properties", ->
      loadFixtures "link_tracker.html"
      spyOn mixingpanel_tracker, 'track_links'

      mixingpanel_tracker.activate(@internal_domain)

      selector    = "#tracked-link"
      event       = "EXAMPLE EVENT"
      extra_props = {foo: "bar"}
      expect(mixingpanel_tracker.track_links).toHaveBeenCalledWith(selector, event, extra_props)

  describe "form tracker", ->
    it "should call 'track_forms' with the right properties", ->
      loadFixtures "form_tracker.html"
      spyOn mixingpanel_tracker, 'track_forms'

      mixingpanel_tracker.activate(@internal_domain)

      selector    = "#tracked-form"
      event       = "EXAMPLE EVENT"
      extra_props = {foo: "bar"}

      expect(mixingpanel_tracker.track_forms).toHaveBeenCalledWith(selector, event, extra_props)

  describe "event tracker", ->
    it "should call 'track' with the right properties", ->
      loadFixtures "event_tracker.html"
      spyOn mixingpanel_tracker, 'track'

      mixingpanel_tracker.activate(@internal_domain)

      event = "EXAMPLE EVENT"
      extra_props = {foo: "bar"}
      expect(mixingpanel_tracker.track).toHaveBeenCalledWith(event, extra_props)
