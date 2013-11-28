describe "MixingpanelTracker", ->

#   describe "track buttons", ->
#     it "should call 'trackButton' with the right properties", ->
#       loadFixtures 'trackme_button'
#       spyOn KelistoInsight, 'trackButton'

#       KelistoInsight.trackButtons()

#       selector    = "#tracked-button"
#       event       = "TRACKME EXAMPLE"
#       extra_props = {foo: "bar"}
#       expect(KelistoInsight.trackButton).toHaveBeenCalledWith(selector, event, extra_props)

#   describe "track pages", ->
#     describe "homepage", ->
#       it "should call 'trackIt' with the right properties", ->
#         loadFixtures 'trackme_homepage_view'
#         spyOn KelistoInsight, 'trackIt'

#         KelistoInsight.trackPage()

#         extra_props = {}
#         expect(KelistoInsight.trackIt).toHaveBeenCalledWith(extra_props)

#     describe "articles", ->
#       it "should call 'trackIt' with the right properties", ->
#         loadFixtures 'trackme_article_view'
#         spyOn KelistoInsight, 'trackIt'

#         KelistoInsight.trackPage()

#         extra_props = {"product": "Example Product", "sub-product": "Example SubProduct"}
#         expect(KelistoInsight.trackIt).toHaveBeenCalledWith(extra_props)

#   describe "track emails", ->
#     it "should call 'trackIt' with the right properties", ->
#       loadFixtures 'trackme_email_view'
#       spyOn KelistoInsight, 'trackIt'
#       spyOn KelistoInsight, 'setMixpanelPeople'
#       spyOn(KelistoInsight, 'getWindowLocation').andReturn('http://example.com/foo/bar?date=18_10_2013&campaign=newsletter&mail=user%40example.com')

#       KelistoInsight.trackPage()

#       extra_props = {'Email campaign' : 'Email_Newsletter_Weekly_20131018'}
#       expect(KelistoInsight.setMixpanelPeople).toHaveBeenCalledWith("user@example.com")
#       expect(KelistoInsight.trackIt).toHaveBeenCalledWith(extra_props)

#   describe "track redirects", ->
#     it "should call mixpanelTrack with the right propeties", ->
#       loadFixtures 'trackme_redirect'
#       spyOn KelistoInsight, 'mixpanelTrack'

#       KelistoInsight.trackRedirects()

#       extra_props = {
#         'Referral type': ['communications', 'mobile'],
#         'Referral reference': 'mob-Simyo Tarifa 2 cent',
#         'Referral url': 'http://referer.com/foo/bar'
#       }
#       expect(KelistoInsight.mixpanelTrack).toHaveBeenCalledWith('Page interaction', extra_props)
