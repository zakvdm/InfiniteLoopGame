

namespace "FNT", (exports) ->

  class exports.StateMachine extends FNT.ObservableModel
    constructor: (@entity) ->
      super()
      @state = null
      @
      
    get: -> return @state
      
    set: (newState) ->
      if newState == @state then return
      
      oldState = newState 
      @state = newState
      @entity.notifyObservers(@state, oldState) # Send the old state as event.data
    