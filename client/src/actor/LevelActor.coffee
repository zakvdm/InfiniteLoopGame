
namespace "FNT", (exports) ->

  class exports.NextLevelPortal extends CAAT.ActorContainer
  
    @SCALE:   0.05  # 0.05 * 1000 (pixels) gives us a diameter of 50
    
    constructor: ->
      super()
      @setSize(FNT.Game.WIDTH, FNT.Game.HEIGHT)
      
      @ringActors = []
      @_prepareBehaviors()
      @
  
    prepare: (@levelModel, position) ->
      @emptyBehaviorList()
      
      @_createBorder()
      @_create(ringModel) for ringModel in @levelModel.getRings() # Create all the RingActors
      
      @setScale(FNT.NextLevelPortal.SCALE, FNT.NextLevelPortal.SCALE)
      
      @centerAt(position.x, position.y)
      
      @
      
    zoomIn: (startTime, callback) ->
      @_removeBorder()
      
      interpolator = new CAAT.Interpolator().createExponentialInInterpolator(4, false)
      
      scaleBehavior = new CAAT.ScaleBehavior()
      scaleBehavior.anchor = CAAT.Actor.prototype.ANCHOR_CENTER
      
      scaleBehavior.startScaleX = scaleBehavior.startScaleY = FNT.NextLevelPortal.SCALE
      scaleBehavior.endScaleX = scaleBehavior.endScaleY = 1
      scaleBehavior.setFrameTime(startTime, FNT.Time.TWO_SECONDS)
      scaleBehavior.setInterpolator(interpolator)
      if callback? then scaleBehavior.addListener({ behaviorExpired : (behavior, time, actor) => callback()})
      
      @addBehavior(scaleBehavior)
      
      path = new CAAT.LinearPath().
        setInitialPosition(@x, @y).
        setFinalPosition(0, 0);
      pathBehavior= new CAAT.PathBehavior().
          setPath(path).
          setFrameTime(startTime, FNT.Time.TWO_SECONDS).
          setInterpolator(interpolator)
          
      @addBehavior(pathBehavior)
      
      @
      
      return @scaleBehavior
      
    _prepareBehaviors: ->
      @fadeOut = new CAAT.AlphaBehavior().setValues(1, 0)
    
    _createBorder: ->
      sceneWidth = FNT.Game.WIDTH # This assumes that sceneWidth == sceneHeight
      r = sceneWidth / 2
      position = { x: r, y: r}
      diameter = Math.sqrt(2 * sceneWidth * sceneWidth) # Pythagoras to get the distance across the screen
      @borderActor = new FNT.PortalBorderActor().create(diameter, position)
      @addChild(@borderActor)
      
    _removeBorder: ->
      @borderActor.addBehavior(@fadeOut.setDelayTime(0, FNT.Time.ONE_SECOND))
      
     
    _create: (ringModel) ->
      ringActor = new FNT.RingActor().create(ringModel, 0.8)
  
      # ADD TO THE SCENE
      @ringActors.push(ringActor)
      @addChild(ringActor) # Add it to the scene graph
        