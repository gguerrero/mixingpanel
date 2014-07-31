#= require mixingpanel/ua-parser.min

class @MixingpanelByPass
  constructor: ->
    @parser = new UAParser()
    @ua = @parser.getResult()

  parse: (event, properties = {}) ->
    if @ua.os.name is "Android" and @ua.browser.name isnt "Chrome"
      [ "#{event} [Android Mobile]",
        $.extend(properties, {user_agent: @ua.ua}) ]
    else
      [ event, properties ]
