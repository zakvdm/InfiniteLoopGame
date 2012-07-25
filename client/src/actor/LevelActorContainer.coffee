
namespace "FNT", (exports) ->
  
  class exports.NextLevelPortal extends CAAT.ActorContainer
  
    @SCALE:   0.05  # 0.05 * 1000 (pixels) gives us a diameter of 50
    
    constructor: ->
      super()
      @ringActors = []
      @
  
    prepare: (@levelModel, width, height) ->
      @setSize(width, height)
      
      @_createBorder(width)
      @_create(ringModel) for ringModel in @levelModel.getRings() # Create all the RingActors
      
      @setScale(FNT.NextLevelPortal.SCALE, FNT.NextLevelPortal.SCALE)
      
      @
    
    _createBorder: (sceneWidth) -> # This assumes that sceneWidth == sceneHeight
      r = sceneWidth / 2
      position = { x: r, y: r}
      diameter = Math.sqrt(2 * sceneWidth * sceneWidth) # Pythagoras to get the distance across the screen
      @borderActor = new FNT.PortalBorderActor().create(diameter, position)
      @addChild(@borderActor)
     
    _create: (ringModel) ->
      ringActor = new FNT.RingActor().create(ringModel, 0.8)
  
      # ADD TO THE SCENE
      @ringActors.push(ringActor)
      @addChild(ringActor) # Add it to the scene graph
        
  
  class exports.LevelActorContainer extends CAAT.ActorContainer
    constructor: ->
      super()
      @ringActors = []
      @
      
    create: (@scene, @levelSequence) ->
      # Register for Level Events
      @levelSequence.addObserver(this)
      
      @scene.addChild(this)
  
      @
     
    handleEvent: (event) ->
      switch event.data
        when FNT.LevelSequenceStates.PREPARING
          @drawLevel()
      
    drawLevel: ->
      @_clearCurrentLevel()
      
      @_create ringModel for ringModel in @levelSequence.currentLevel().getRings() # Create all the RingActors
      @_animate ringActor for ringActor in @ringActors # Animate them all into place
     
      if @nextLevelPortal? # TODO: This is ugly, I'd rather "swap in" the Portal level somehow...
        @removeChild(@nextLevelPortal)
        @nextLevelPortal.setDiscardable(true).setExpired(true)
        
      @nextLevelPortal = new FNT.NextLevelPortal().prepare(@levelSequence.nextLevel(), @width, @height)
      exitLocation = @levelSequence.currentLevel().exit
      @nextLevelPortal.centerAt(exitLocation.x, exitLocation.y)
      @addChild(@nextLevelPortal)
      
      @
     
      
    _clearCurrentLevel: ->
      for ring in @ringActors
        ring.setDiscardable(true).setExpired(true)
        
      @ringActors = []
    
      
    _create: (ringModel) ->
      ringActor = new FNT.RingActor().create(ringModel)
      ringActor.setVisible(false)
  
      # ADD TO THE SCENE
      @ringActors.push(ringActor)
      @addChild(ringActor) # Add it to the scene graph
      
    _animate: (ringActor) ->
      @_animateInUsingScale(ringActor, @scene.time, 1000)
      ringActor.setVisible(true)
      
    ###
     # Adds a CAAT.ScaleBehavior to the entity, used on animate in
    ###
    _animateInUsingScale : (actor, startTime, duration) ->
      @scaleBehavior ?= @_createScaleBehavior()
      
      actor.scaleX = actor.scaleY = @scaleBehavior.startScaleX
      @scaleBehavior.setFrameTime(startTime, duration)
      actor.addBehavior(@scaleBehavior)
    
    _createScaleBehavior: (startScale, endScale) ->
      @scaleBehavior = new CAAT.ScaleBehavior()
      @scaleBehavior.anchor = CAAT.Actor.prototype.ANCHOR_CENTER
      
      @scaleBehavior.startScaleX = @scaleBehavior.startScaleY = 0.1
      @scaleBehavior.endScaleX = @scaleBehavior.endScaleY = 1
      @scaleBehavior.setCycle(false)
      @scaleBehavior.setInterpolator(new CAAT.Interpolator().createBounceOutInterpolator(false))
      
      @scaleBehavior.addListener({ behaviorExpired : (behavior, time, actor) => @_doneAnimating()})
      
      return @scaleBehavior
      
    _doneAnimating: ->
      @levelSequence.state.set(FNT.LevelSequenceStates.READY)
      
      
       