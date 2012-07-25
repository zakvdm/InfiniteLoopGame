
namespace "FNT", (exports) ->

  # LEVEL SEQUENCE EVENTS
  exports.LevelSequenceEvents =
      NEXT_LEVEL:    "level_sequence_event_next_level"
      
  # LEVEL SEQUENCE STATES
  exports.LevelSequenceStates =
    PREPARING:        "level_state_preparing"
    READY:            "level_state_ready"
    PLAYING:          "level_state_playing"


  class exports.LevelSequenceFactory
    @build: (allLevels) ->
      levelSequence = new FNT.LevelSequence()
      
      # COMPONENTS:
      stateMachine = new FNT.StateMachine(levelSequence)
      levelSequence.state = stateMachine
      
      for levelData in allLevels
        levelSequence.addLevel(FNT.LevelFactory.build(levelData))
        
      return levelSequence
      
  # LEVEL MODEL
  class exports.LevelSequence extends FNT.ObservableModel
    constructor: (@_levels = []) ->
      @_currentIndex = 0
      super()
      @
    
    addLevel: (levelModel) ->
      @_levels.push(levelModel)
      
    start: ->
      @_currentIndex = 0
      @state.set(FNT.LevelSequenceStates.PREPARING)
      
    currentLevel: -> @_levels[@_currentIndex]
    
    nextLevel: -> @_levels[@_currentIndex + 1]
    
    advance: ->
      @_currentIndex += 1 if @_currentIndex < (@_levels.length - 2)
      @state.set(FNT.LevelSequenceStates.PREPARING)
      
    
    
      

    