class @MixingpanelQueue extends Array
  constructor: ->
    @promises = [
      "mixpanel", 
      "mixpanel.get_property", 
      "mixpanel.register", 
      "mixpanel.identify" ]

    @promiseTimeout = 100
    @lockTimeout = 200

    @executionLock = false
    @isReady = false

    @_promiseRunner()

  append: (name, callback) ->
    @splice(0, 0, [name, callback])
    @run()

  run: ->
    return unless @isReady
    @_runLock()
    while @length > 0
      job = @pop()
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
    , (@promiseTimeout*40)

  _runLock: () ->
    @executionLock = true unless @executionLock
    
    @lockID = setInterval =>
      console.log "Some job is being executed"
      unless @executionLock
        @executionLock = true
        clearInterval(@lockID)
    , @lockTimeout

  _runUnlock: () ->
    console.log "Unlocking exection"
    @executionLock = false
