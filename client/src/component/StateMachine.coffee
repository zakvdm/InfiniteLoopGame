

namespace "FNT", (exports) ->

  # LEVEL STATES
  exports.STATE_CHANGE_EVENT = "state_change"
    
  class exports.StateMachine extends FNT.ObservableModel
    constructor: (@entity) ->
      super()
      @state = null
      @
      
    set: (newState) ->
      if newState == @state then return
      
      @state = newState
      @entity.notifyObservers(FNT.STATE_CHANGE_EVENT, @state)
    