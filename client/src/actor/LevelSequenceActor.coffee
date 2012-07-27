
namespace "FNT", (exports) ->
  
  class exports.LevelActorContainer extends CAAT.ActorContainer
    constructor: ->
      super()
      @setSize(FNT.Game.WIDTH, FNT.Game.HEIGHT)
      
      @ringActors = []
      @
      
    create: (@scene, @levelSequence) ->
      @scene.addChild(this)
      
      # Register for Level Events
      @levelSequence.addObserver(this)
      
      @_prepareNextLevel(@levelSequence.currentLevel(), new CAAT.Point(500, 500))
  
      @
     
    handleEvent: (event) ->
      switch event.data
        when FNT.LevelSequenceStates.PREPARING
          @prepareLevel()
      
    prepareLevel: ->
      #@_clearCurrentLevel()
      
      @_cleanUpLevel(@activeLevelActor)
      
      if @nextLevelPortal?
        @nextLevelPortal.zoomIn(@scene.time, => @_doneZooming())
        @activeLevelActor = @nextLevelPortal
        
        #@removeChild(@nextLevelPortal)
        #@nextLevelPortal.setDiscardable(true).setExpired(true)
      else # There is no nextLevelPortal, which means we're preparing the first level in the sequence...
        alert("IN ELSE!")
        @_create ringModel for ringModel in @levelSequence.currentLevel().getRings() # Create all the RingActors
        @_animate ringActor for ringActor in @ringActors # Animate them all into place
     
        @nextLevelPortal = new FNT.NextLevelPortal().prepare(@levelSequence.nextLevel())
        exitLocation = @levelSequence.currentLevel().exit
        @nextLevelPortal.centerAt(exitLocation.x, exitLocation.y)
        @addChild(@nextLevelPortal)
      
      @
    
    _doneZooming: ->
      @_prepareNextLevel(@levelSequence.nextLevel(), @levelSequence.currentLevel().exit)
      @_donePreparing()
    
    _cleanUpLevel: (levelActor) ->
      if levelActor?
        ring.setDiscardable(true).setExpired(true) for ring in levelActor.ringActors
        
        @removeChild(levelActor)
    
    _prepareNextLevel: (level, position) -> 
      @nextLevelPortal = new FNT.NextLevelPortal()
      @nextLevelPortal.prepare(level, position) # We pre-load the first level so that when the game starts, we can just "transition" it in
      @addChild(@nextLevelPortal)
      
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
      
      @scaleBehavior.addListener({ behaviorExpired : (behavior, time, actor) => @_donePreparing()})
      
      return @scaleBehavior
      
    _donePreparing: ->
      @levelSequence.state.set(FNT.LevelSequenceStates.READY)
      
      
       