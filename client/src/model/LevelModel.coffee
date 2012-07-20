
namespace "FNT", (exports) ->

  # LEVEL EVENTS
  exports.LevelEvents =
      LOAD:    "level_event_load"
  
  # LEVEL MODEL
  class exports.LevelModel extends FNT.ObservableModel
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
  
  
