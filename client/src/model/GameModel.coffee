
namespace "FNT", (exports) ->

  # GAME MODEL
  class exports.GameModel extends FNT.ObservableModel
    constructor: (@level, @player) ->
      @level.addObserver(@) # Listen to LevelModel events
      super()
      @

    step: ->
      if @physicsController?
        @physicsController.step() # TODO: The way i'm doing the timestep is totally hacky (the physics engine ends up doing the same work that CAAT is, and what if it's slightly out of phase?)
  
    handleEvent: (event) ->
      switch event.type
        when FNT.STATE_CHANGE_EVENT, event.data is FNT.LevelStates.LOADED, event.source is @level
          @startLevel()

    startGame: (@gameMode) ->
      @loadLevel(0)

    loadLevel: (@currentLevelIndex) ->
      if not (0 <= @currentLevelIndex < FNT.GameModes.quest.levelData.length) then return
      
      @currentLevelData = FNT.GameModes.quest.levelData[@currentLevelIndex];
      @level.load(this.currentLevelData.ringData);

    startLevel: ->
      @player.spawn(@currentLevelData.spawnLocation);
      @level.state.set(FNT.LevelStates.PLAYING)
