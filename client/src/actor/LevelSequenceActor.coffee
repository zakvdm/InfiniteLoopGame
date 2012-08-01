
namespace "FNT", (exports) ->
  
  class exports.LevelSequenceActor extends CAAT.ActorContainer
    constructor: ->
      super()
      @setSize(FNT.Game.WIDTH, FNT.Game.HEIGHT)
      
      @ringActors = []
      @
      
    create: (@scene, @levelSequence) ->
      @scene.addChild(this)
      
      # Register for Level Sequence Events
      @levelSequence.addObserver(this)
      
      @_prepareZoom()
  
      @
     
    handleEvent: (event) ->
      switch event.data
        when FNT.LevelSequenceStates.STARTING
          @_startSequence()
        when FNT.LevelSequenceStates.ADVANCING
          @_advanceLevel()
          
    _startSequence: ->
      @_cleanAll()
      
      # Prepare the initial level which we transition into right away
      @_prepareNextLevel(@levelSequence.currentLevel(), new CAAT.Point(FNT.Game.WIDTH / 2, FNT.Game.HEIGHT / 2))
      
      @_advanceLevel() # Move to the first level
      
      
    _advanceLevel: ->
      @_cleanUpLevel()
      
      @_zoomIn(@nextLevelActor, @scene.time, => @_doneZooming())
      @activeLevelActor = @nextLevelActor
        
      @
    
    _cleanAll: ->
      if @nextLevelActor?
        @nextLevelActor.discard()
        @removeChild(@nextLevelActor)
      @_cleanUpLevel()
      
    _cleanUpLevel: ->
      if @activeLevelActor?
        @activeLevelActor.discard()
        @removeChild(@activeLevelActor)
    
    _doneZooming: ->
      @_prepareNextLevel(@levelSequence.nextLevel(), @levelSequence.currentLevel().exit)
      @activeLevelActor.start(@scene.time)
      @levelSequence.state.set(FNT.LevelSequenceStates.READY)
    
    _prepareNextLevel: (level, position) -> 
      @nextLevelActor = new FNT.LevelActor()
      @nextLevelActor.prepare(level, position) # We pre-load the first level so that when the game starts, we can just "transition" it in
      @addChild(@nextLevelActor)
    
    _prepareZoom: ->  
      interpolator = new CAAT.Interpolator().createExponentialInInterpolator(4, false)
      
      @zoomScaleBehavior = new CAAT.ScaleBehavior()
      @zoomScaleBehavior.anchor = CAAT.Actor.prototype.ANCHOR_CENTER
      
      @zoomScaleBehavior.startScaleX = @zoomScaleBehavior.startScaleY = FNT.LevelActor.PORTAL_SCALE
      @zoomScaleBehavior.endScaleX = @zoomScaleBehavior.endScaleY = 1
      @zoomScaleBehavior.setInterpolator(interpolator)
      
      @zoomPath = new CAAT.LinearPath().setFinalPosition(0, 0);
      @zoomPathBehavior = new CAAT.PathBehavior().
          setPath(@zoomPath).
          setInterpolator(interpolator)
      
    _zoomIn: (levelActor, startTime, callback) ->
      levelActor.removeBorder()
      
      @zoomScaleBehavior.emptyListenerList()
      if callback? then @zoomScaleBehavior.addListener({ behaviorExpired : (behavior, time, actor) => callback()})
      
      @zoomPath.setInitialPosition(levelActor.x, levelActor.y)
      
      @zoomScaleBehavior.setFrameTime(startTime, FNT.Time.TWO_SECONDS)
      @zoomPathBehavior.setFrameTime(startTime, FNT.Time.TWO_SECONDS)
      
      levelActor.addBehavior(@zoomScaleBehavior)
      levelActor.addBehavior(@zoomPathBehavior)
      
       