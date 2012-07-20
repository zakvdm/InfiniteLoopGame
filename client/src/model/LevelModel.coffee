
# LEVEL EVENTS
LevelEvents =
    LOAD:    "level_event_load"

# LEVEL MODEL
class LevelModel extends ObservableModel
  constructor: ->
    super()
    @rings = []
    @
    
  create: ->
    @
        
  load : (ringData) ->
    for ring in ringData
      @rings.push new FNT.RingModel().create(ring) # TODO: Why not just pass the 'ring' object?
    
    @notifyObservers(FNT.LevelEvents.LOAD, @)
  
  getRings: -> @rings


namespace "FNT", (exports) ->
  exports.LevelEvents = LevelEvents
  exports.LevelModel = LevelModel
