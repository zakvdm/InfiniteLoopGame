

# GAME MODEL EVENTS
GameModelEvents =
    UPDATE_STATUS:         "update_status_event",
    CREATE_LEVEL:          "create_level_event",
    ADDED_PLAYER:          "added_player_event",

# GAME MODEL
class GameModel extends ObservableModel
  constructor: ->
    super()
    @
    
  create: ->
    this.createLevel()
    this.createPlayer()
    @
    

  createPlayer: ->
    @player = new FNT.PlayerModel().create()
    
    @notifyObservers( FNT.GameModelEvents.ADDED_PLAYER, @player )
  
  
  createLevel: ->
    @level = new FNT.LevelModel().create()
    
    @notifyObservers( FNT.GameModelEvents.CREATE_LEVEL, @level )
  
  
  startGame: (@gameMode) ->
    @loadLevel(0)
      
      
  loadLevel: (levelIndex) ->
    @currentLevelData = FNT.GameModes.quest.levelData[levelIndex];
    @level.load(this.currentLevelData.ringData);
      
    @onLevelLoaded(); # TODO: This should be called later when the level is actually done loading (including animations)
    
        
  onLevelLoaded: ->
    @player.spawn(@currentLevelData.spawnLocation);



namespace "FNT", (exports) ->
  exports.GameModelEvents = GameModelEvents
  exports.GameModel = GameModel