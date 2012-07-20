
namespace "FNT", (exports) ->

  # GAME MODEL EVENTS
  exports.GameModelEvents =
      UPDATE_STATUS:         "update_status_event",
      CREATE_LEVEL:          "create_level_event",
      ADDED_PLAYER:          "added_player_event",
  
  # GAME MODEL
  class exports.GameModel extends FNT.ObservableModel
    constructor: ->
      super()
      @
      
    create: ->
      @initPhysics()
      @createLevel()
      @createPlayer()
      @
    
    step: ->
      if @physicsController?
        @physicsController.step() # TODO: The way i'm doing the timestep is totally hacky (the physics engine ends up doing the same work that CAAT is, and what if it's slightly out of phase?)
  
    createPlayer: ->
      @player = new FNT.PlayerModel().create()
      
      @notifyObservers( FNT.GameModelEvents.ADDED_PLAYER, @player )
    
    
    createLevel: ->
      @level = new FNT.LevelModel().create()
      
      @notifyObservers( FNT.GameModelEvents.CREATE_LEVEL, @level )
    
    
    startGame: (@gameMode) ->
      @loadLevel(0)
      
    initPhysics: ->
      @physicsController = new FNT.PhysicsController().create(@)
      
      @
        
        
    loadLevel: (levelIndex) ->
      @currentLevelData = FNT.GameModes.quest.levelData[levelIndex];
      @level.load(this.currentLevelData.ringData);
        
      @onLevelLoaded(); # TODO: This should be called later when the level is actually done loading (including animations)
      
          
    onLevelLoaded: ->
      @player.spawn(@currentLevelData.spawnLocation);
  