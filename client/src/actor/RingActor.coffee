
namespace "FNT", (exports) ->
  class exports.RingActor extends FNT.CircleActor
    constructor: ->
      super()
      @
      
    create: (@ring, @_alpha = 0.5) ->
      @setDiameter(ring.diameter)
      @setPosition(ring.position)
  
      @setStrokeStyle(FNT.Color.BLACK)
      
      @_normalState()
      
      # Register for Ring Events
      @ring.addObserver(this)
  
      @
      
    handleEvent: (event) ->
      switch event.type
        when FNT.RingStates.NORMAL
          @_normalState()
        when FNT.RingStates.ORBITED
          @_orbitedState()
        when FNT.RingStates.PASSABLE
          @_passableState()
    
    _normalState: ->
      @setLineWidth(1)
      @setFillStyle(FNT.Color.GRAY)
      @setAlpha(@_alpha)
  
    
    _orbitedState: ->
      @setLineWidth(2)
      @setAlpha(0.8)
        
    _passableState: ->
      @setLineWidth(1)
      @setFillStyle(FNT.Color.GRAY)
      @setAlpha(0.2)
  
