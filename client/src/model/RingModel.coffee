
namespace "FNT", (exports) ->

  # LEVEL EVENTS
  exports.RingEvents =
      ORBITED:    "ring_event_orbited"
      
  # LEVEL MODEL
  class exports.RingModel extends FNT.ObservableModel
    constructor: ->
      @position = new CAAT.Point(0, 0)
      super()
      @
      
      
    diameter:     0
  
    create: (ringData) ->
      @position = new CAAT.Point(ringData.x, ringData.y)
      @diameter = ringData.diameter
      @radius = @diameter / 2
      
      @
  
    setOrbited: (@orbited) ->
      @notifyObservers(FNT.RingEvents.ORBITED, @orbited)      
