class @MixingpanelQueue extends Array
  constructor: ->
    @promises = [
      "mixpanel", 
      "mixpanel.get_property", 
      "mixpanel.register", 
      "mixpanel.identify" ]

    @promiseTimeout = 100
    @lockTimeout = 200

    @isReady = false
    @executionLocked = false

    @_promiseRunner()

  append: (name, callback, params = []) ->
    # TODO: Parse params on the callback call
    @push([name, callback, params])
    @run()

  run: ->
    debugger
    return unless @_runLock()
    while @length > 0
      job = @shift()
      console.log "Running job '#{job[0]}'"
      job[1].call(this)
    @_runUnlock()

  _promiseRunner: ->
    @intervalID = setInterval =>
      @isReady = true
      for promise in @promises
        try
          @isReady = false if eval(promise) is undefined
        catch e
          @isReady = false

      if @isReady
        clearInterval(@intervalID)
    , @promiseTimeout

    setTimeout =>
      clearInterval(@intervalID)
    , (@promiseTimeout*60)

  _runLock: () ->
    if not @isReady or @executionLocked
      # TODO: lockID should be override, otherwhise the older interval will never be cleared!!
      @lockID = setInterval =>
        console.log "Waiting for exection..."
        if @isReady and not @executionLocked
          @run()
          clearInterval(@lockID)
      , @lockTimeout

      setTimeout =>
        clearInterval(@lockID)
      , (@lockTimeout*100)

      false
    else
      @executionLocked = true
      true

  _runUnlock: () ->
    console.log "Unlocking exection"
    @executionLocked = false
