
namespace "FNT", (exports) ->

  # LEVEL EVENTS
  exports.LevelEvents =
      LOAD:    "level_event_load"
      
  # LEVEL STATES
  exports.LevelStates =
    LOADED:           "level_state_loaded"

  class exports.LevelFactory
    @build: ->
      level = new FNT.LevelModel().create()
      
      # COMPONENTS:
      stateMachine = new FNT.StateMachine(level)
      level.state = stateMachine
      
      return level
      
  # LEVEL MODEL
  class exports.LevelModel extends FNT.ObservableModel
    constructor: ->
      super()
      @
      
    create: ->
      @
     
    load : (ringData) ->
      @rings = []
      
      for ring in ringData
        @rings.push new FNT.RingModel().create(ring)
      
      @notifyObservers(FNT.LevelEvents.LOAD, @)
    
    getRings: -> @rings
    
    resetAllRings: ->
      for ring in @rings
        ring.setOrbited(false)
    