
namespace "FNT", (exports) ->

  exports.PanelState =
    SHY:      "PANEL_STATE_SHY"
    OUTGOING: "PANEL_STATE_OUTGOING"
    
  class exports.Panel extends FNT.CircleActor
    constructor: ->
      super()
      
      @
      
    _getPositionForState: (state) ->
      throw "Should overide!"
      
    _getInitialPosition: ->
      throw "Should overide!"
      
    _createText: ->
      console.log("No text added to Panel") # Can be overridden!
    
    create : (@scene) ->
      @setFillStyle(FNT.Color.BACKGROUND)
      @setLineWidth(2)
      @setStrokeStyle(FNT.Color.BLACK)
      
      @scene.addChild(@)
      
      @_createText()
      
      @_prepareBehaviors()
      
      @
     
    _prepareBehaviors: -> 
      @path = new CAAT.LinearPath()
      @pathBehavior = new CAAT.PathBehavior().
          setPath(@path).
          setInterpolator(new CAAT.Interpolator().createExponentialOutInterpolator(6, false))
          
      @addBehavior(@pathBehavior)
      
    setState: (state, animationTime = FNT.Time.ONE_SECOND) ->
      pos = @_getPositionForState(state)
      
      @path.setInitialPosition(@x, @y)
      @path.setFinalPosition(pos.x, pos.y)
      @pathBehavior.setFrameTime(@scene.time, animationTime)
      
    animateIn: ->
      @setPosition(@_getInitialPosition())
      @setState(FNT.PanelState.OUTGOING, FNT.Time.FOUR_SECONDS)
      
      