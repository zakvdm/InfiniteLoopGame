
namespace "FNT", (exports) ->
  class exports.RingActor extends FNT.CircleActor
    constructor: ->
      super()
      @
      
    create: (@ring) ->
      @setDiameter(ring.diameter)
      @setPosition(ring.position)
  
      @setStrokeStyle('#0')
      @setFillStyle('#AAA')
      @setAlpha(0.5)
  
      # Register for Ring Events
      @ring.addObserver(this)
  
      @
      
    handleEvent: (event) ->
      switch event.type
        when FNT.RingEvents.ORBITED
          @orbit(event.data)
          
    orbit: (orbited) ->
      if orbited
        @setLineWidth(2)
        @setFillStyle('yellow')
      else
        @setLineWidth(1)
        @setFillStyle('#AAA')
  
