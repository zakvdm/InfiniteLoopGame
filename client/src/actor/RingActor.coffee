
namespace "FNT", (exports) ->
  class exports.RingActor extends FNT.CircleActor
    constructor: ->
      super()
      @
      
    create: (@ring, @_alpha = 0.5) ->
      @setDiameter(ring.diameter)
      @setPosition(ring.position)
  
      @setStrokeStyle(FNT.Color.BLACK)
      @setFillStyle(FNT.Color.GRAY)
      @setAlpha(@_alpha)
      @setLineWidth(1)
  
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
        #@setFillStyle(FNT.Color.DARK_GRAY)
        @setAlpha(0.9)
        #@setFillStyle(FNT.Color.MEDIUM_DULL)
        #@setStrokeStyle(FNT.Color.MEDIUM_DULL)
      else
        @setLineWidth(1)
        @setFillStyle(FNT.Color.GRAY)
        @setAlpha(@_alpha)
  
