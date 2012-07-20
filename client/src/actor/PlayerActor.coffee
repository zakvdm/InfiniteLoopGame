###
 # Player Actor
###
namespace "FNT", (exports) ->
  class exports.PlayerActor extends FNT.CircleActor
    constructor: ->
      super()
      @ # return this
      
    create: (scene, playerModel) ->
      @setVisible(false)
      
      @setDiameter(playerModel.diameter)
      @setPosition(playerModel.position)
      
      @setStrokeStyle('#0')
      @setFillStyle(playerModel.color)
      
      @playerModel = playerModel
      
      @prepareSpawnBehavior()
      
      playerModel.addObserver this
      scene.addChild this
      
      @
    
    prepareSpawnBehavior: ->
      @spawnScaleBehavior = new CAAT.ScaleBehavior().
          setPingPong().                       # We want it to swell and then return to its actual size
          setValues(1, 1.3, 1, 1.3, .50, .50).   # Scale to 1.3x normal size from centre
          setDelayTime(0, 1000)                # Take 1 second to scale
      
      
      @spawnAlphaBehavior = new CAAT.AlphaBehavior().
                     setValues(0, 1).          # Fade it in
                     setDelayTime(0, 1000);
       
    handleEvent: (event) ->
      switch event.type
        when FNT.PlayerEvents.SPAWN
          @spawn()
        when FNT.PlayerEvents.NEW_POSITION
          @setPosition(@playerModel.position)
      
    spawn: ->
      @setPosition(@playerModel.position)
      
      @addBehavior(@spawnScaleBehavior)
      @addBehavior(@spawnAlphaBehavior)
      
      @setVisible(true) 
        
