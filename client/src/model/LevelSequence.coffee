
namespace "FNT", (exports) ->

  # LEVEL SEQUENCE STATES
  exports.LevelSequenceStates =
    STARTING:         "level_state_start"
    ADVANCING:        "level_state_advancing"
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
      @state.set(FNT.LevelSequenceStates.STARTING)
      
    currentLevel: -> @_levels[@_currentIndex]
    
    nextLevel: -> @_levels[@_nextIndex()]
    
    advance: ->
      @_currentIndex = @_nextIndex()
      @state.set(FNT.LevelSequenceStates.ADVANCING)
      
    skipToLevel: (levelIndex) ->
      @_currentIndex = levelIndex % @_levels.length
      @state.set(FNT.LevelSequenceStates.STARTING) # We can start the sequence from an arbitrary point (and it'll just loop from there)
    
      
    _nextIndex: ->
      return (@_currentIndex + 1) % @_levels.length
      
    
    
      

    