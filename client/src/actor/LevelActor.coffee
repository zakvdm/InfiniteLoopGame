
namespace "FNT", (exports) ->

  class exports.LevelActor extends CAAT.ActorContainer
  
    @PORTAL_SCALE:   0.05  # 0.05 * 1000 (pixels) gives us a diameter of 50
    
    constructor: ->
      super()
      @setSize(FNT.Game.WIDTH, FNT.Game.HEIGHT)
      
      @ringActors = []
      @textActors = []
      @_prepareBehaviors()
      @
  
    prepare: (@levelModel, position) ->
      @emptyBehaviorList()
      
      @_createBorder()
      @_createRing(ringModel) for ringModel in @levelModel.getRings() # Create all the RingActors
      
      if @levelModel.getTexts()?
        @_createText(textData) for textData in @levelModel.getTexts()
      
      @setScale(FNT.LevelActor.PORTAL_SCALE, FNT.LevelActor.PORTAL_SCALE)
      
      @centerAt(position.x, position.y)
      
      @
    
    # The level has become "active" so we can start all the animations, etc.  
    start: (sceneTime) ->
      textActor.startTimer(sceneTime) for textActor in @textActors

    discard: ->
      ring.setDiscardable(true).setExpired(true) for ring in @ringActors
      @borderActor.setDiscardable(true).setExpired(true)
      @setDiscardable(true).setExpired(true)
      
    _prepareBehaviors: ->
      @fadeOut = new CAAT.AlphaBehavior().setValues(1, 0)
    
    _createBorder: ->
      sceneWidth = FNT.Game.WIDTH # This assumes that sceneWidth == sceneHeight
      r = sceneWidth / 2
      position = { x: r, y: r}
      diameter = Math.sqrt(2 * sceneWidth * sceneWidth) # Pythagoras to get the distance across the screen
      @borderActor = new FNT.PortalBorderActor().create(diameter, position)
      @addChild(@borderActor)
      
    removeBorder: ->
      @borderActor.addBehavior(@fadeOut.setDelayTime(0, FNT.Time.ONE_SECOND))
     
    _createRing: (ringModel) ->
      ringActor = new FNT.RingActor().create(ringModel, 0.5)
  
      # ADD TO THE SCENE
      @ringActors.push(ringActor)
      @addChild(ringActor) # Add it to the scene graph
        
    _createText: (textData) ->
      textActor = FNT.TextFactory.build(@, textData.text, textData.size)
      textActor.setLocation(textData.x, textData.y)
      textActor.setTimingInfo(textData.start, textData.duration)
      
      @textActors.push(textActor)
 
 