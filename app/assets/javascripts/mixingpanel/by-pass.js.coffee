#= require mixingpanel/ua-parser.min

class @MixingpanelByPass
  constructor: ->
    @parser = new UAParser()
    @ua = @parser.getResult()

  parse: (event, properties = {}) ->
    if @ua.os.name is "Android" and @ua.browser.version is "4.0"
      [ "#{event} [Android Mobile v4.0]",
        $.extend(properties, {user_agent: @ua.ua}) ]
    else
      [ event, properties ]
