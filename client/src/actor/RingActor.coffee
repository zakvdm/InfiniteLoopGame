
namespace "FNT", (exports) ->
  class exports.RingActor extends FNT.CircleActor
    constructor: ->
      super()
      @
      
    create: (ring) ->
      @setDiameter(ring.diameter)
      @setPosition(ring.position)
  
      @setStrokeStyle('#0')
      @setFillStyle('#AAA')
      @setAlpha(0.5)
  
      @ring = ring
  
      @
  
