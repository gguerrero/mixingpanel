# See https://mixpanel.com/help/reference/javascript-full-api-reference#mixpanel.set_config
# There you'll find all the default values and what does they mean!
Mixingpanel.configure do |config|
  config.track_pageview         = false
  config.disable_cookie         = false
  config.cross_subdomain_cookie = true
  config.cookie_name            = ""
  config.cookie_expiration      = 365
end
