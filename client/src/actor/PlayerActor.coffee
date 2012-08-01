###
 # Player Actor
###
namespace "FNT", (exports) ->
  class exports.PlayerActor extends FNT.CircleActor
    constructor: ->
      super()
      @ # return this
    
    create: (scene, @playerModel) ->
      @setVisible(false)
      
      @setDiameter(@playerModel.diameter)
      @setPosition(@playerModel.position)
      
      @setLineWidth(2)
      @setStrokeStyle('#0')
      @setFillStyle(FNT.Color.PLAYER)
      
      @prepareBehaviors()
      
      @playerModel.addObserver(this)
      scene.addChild(this)
      
      @
    
    prepareBehaviors: ->
      @spawnScaleBehavior = new CAAT.ScaleBehavior().
          setPingPong().                       # We want it to swell and then return to its actual size
          setValues(1, 1.3, 1, 1.3, .50, .50)  # Scale to 1.3x normal size from centre
      
      
      @spawnAlphaBehavior = new CAAT.AlphaBehavior().
          setValues(0, 1)          # Fade it in
                     
      @deathBehavior = new CAAT.ScaleBehavior().
          setValues(1, 0, 1, 0, .5, .5)       # We start from full scale and shrink to nothing (centered)
       
    handleEvent: (event) ->
      switch event.type
        when FNT.PlayerEvents.SPAWN
          @spawn()
        when FNT.PlayerEvents.NEW_POSITION
          @setPosition(@playerModel.position)
        when FNT.PlayerStates.NORMAL
          @setAlpha(1)
        when FNT.PlayerStates.ORBITING
          @setAlpha(0.6)
        when FNT.PlayerStates.DEAD
          @kill()
        
     
    spawn: ->
      @setPosition(@playerModel.position)
      
      @emptyBehaviorList()
      @spawnScaleBehavior.setDelayTime(0, FNT.Time.ONE_SECOND)
      @spawnAlphaBehavior.setDelayTime(0, FNT.Time.ONE_SECOND)
      @addBehavior(@spawnScaleBehavior)
      @addBehavior(@spawnAlphaBehavior)
      
      @setVisible(true) 
    
    kill: ->
      @deathBehavior.setDelayTime(0, FNT.Time.ONE_SECOND)
      @addBehavior(@deathBehavior)
      
        
