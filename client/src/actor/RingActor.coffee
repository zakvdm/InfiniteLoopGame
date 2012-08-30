
namespace "FNT", (exports) ->
  class exports.RingActor extends FNT.CircleActor
    constructor: ->
      super()
      @
      
    create: (@ring, @_alpha = 0.5, @_lineWidth = 2) ->
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
      @setLineWidth(@_lineWidth)
      @setFillStyle(FNT.Color.GRAY)
      @setAlpha(@_alpha)
  
    
    _orbitedState: ->
      @setLineWidth(@_lineWidth * 1.5)
      @setAlpha(@_alpha * 1.5)
        
    _passableState: ->
      @setLineWidth(@_lineWidth / 2)
      @setFillStyle(FNT.Color.GRAY)
      @setAlpha(@_alpha / 3)
  
