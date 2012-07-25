
namespace "FNT", (exports) ->
  
  class exports.LevelActorContainer extends CAAT.ActorContainer
    constructor: ->
      super()
      @ringActors = []
      @
      
    create: (scene, levelModel) ->
      @scene = scene
      @levelModel = levelModel
  
      # Register for Level Events
      @levelModel.addObserver(this)
      @scene.addChild(this)
  
      @
     
    handleEvent: (event) ->
      switch event.type
        when FNT.LevelEvents.LOAD
          @loadLevel()
      
    loadLevel: ->
      @_clearCurrentLevel()
      
      @_create ringModel for ringModel in @levelModel.getRings() # Create all the RingActors
      @_animate ringActor for ringActor in @ringActors # Animate them all into place
     
    _clearCurrentLevel: ->
      for ring in @ringActors
        ring.setDiscardable(true).setExpired(true)
        
      @ringActors = []
    
      
    _create: (ringModel) ->
      ringActor = new FNT.RingActor().create(ringModel)
      ringActor.setVisible false
  
      # ADD TO THE SCENE
      @ringActors.push ringActor
      @addChild ringActor # Add it to the scene graph
      
    _animate: (ringActor) ->
      @_animateInUsingScale(ringActor, @scene.time, 1000)
      ringActor.setVisible true
      
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
      @levelModel.state.set(FNT.LevelStates.LOADED)
      
      
       