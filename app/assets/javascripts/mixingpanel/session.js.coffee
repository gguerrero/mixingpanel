class @MixingpanelSession
  constructor: (@properties, options = {}) ->
    @_parseSession()
    if @mp_session.start
        mixpanel.register(@_sessionRegister())
    else if @mp_session.end
        @_sessionUnregister()
  
  _parseSession: ->
    qsObj = @properties.location.query_string
    @mp_session =
      start: qsObj.mp_session_start
      end: qsObj.mp_session_end

  _sessionRegister: ->
    mp_session_id: @mp_session.start
    mp_session_timestamp: (new Date()).toISOString()

  _sessionUnregister: ->
    mixpanel.unregister('mp_session_id')
    mixpanel.unregister('mp_session_timestamp')
