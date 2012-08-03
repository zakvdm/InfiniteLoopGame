
namespace "FNT", (exports) ->

  class exports.LevelActor extends CAAT.ActorContainer
  
    @PORTAL_SCALE:   0.05  # 0.05 * 1000 (pixels) gives us a diameter of 50
    
    constructor: ->
      super()
      @setSize(FNT.Game.WIDTH, FNT.Game.HEIGHT)
      
      @ringActors = []
      @portalActors = []
      @textActors = []
      @_prepareBehaviors()
      @
  
    prepare: (@levelModel, position) ->
      @emptyBehaviorList()
      
      @_createBorder()
      @_createRing(ringModel) for ringModel in @levelModel.getRings() # Create all the RingActors
      
      @_createPortal(portalModel) for portalModel in @levelModel.getPortals()
      
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
      portal.setDiscardable(true).setExpired(true) for portal in @portalActors
      text.setDiscardable(true).setExpired(true) for text in @textActors
      @borderActor.setDiscardable(true).setExpired(true)
      @setDiscardable(true).setExpired(true)
      
    _prepareBehaviors: ->
      @fadeOut = new CAAT.AlphaBehavior().setValues(1, 0)
    
    _createBorder: ->
      sceneWidth = FNT.Game.WIDTH
      sceneHeight = FNT.Game.HEIGHT
      position = { x: sceneWidth / 2, y: sceneHeight / 2}
      diameter = Math.sqrt(sceneWidth * sceneWidth + sceneHeight * sceneHeight) # Pythagoras to get the distance across the screen
      @borderActor = new FNT.PortalActor().create(@, diameter, position)
      
    removeBorder: ->
      @borderActor.addBehavior(@fadeOut.setDelayTime(0, FNT.Time.ONE_SECOND))
     
    _createRing: (ringModel) ->
      ringActor = new FNT.RingActor().create(ringModel, 0.5)
  
      # ADD TO THE SCENE
      @ringActors.push(ringActor)
      @addChild(ringActor) # Add it to the scene graph
      
    _createPortal: (portal) ->
      @portalActors.push(new FNT.PortalActor().create(@, portal.diameter, portal.position, portal.type.color))
        
    _createText: (textData) ->
      textActor = FNT.TextFactory.build(@, textData.text, textData.size)
      textActor.setLocation(textData.x, textData.y)
      textActor.setTimingInfo(textData.start, textData.duration)
      
      @textActors.push(textActor)
 
 