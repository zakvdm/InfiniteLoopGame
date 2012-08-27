
namespace "FNT", (exports) ->

  # GAME EVENTS
  exports.GameEvents =
    TOGGLE_SOUND:    "game_event_toggle_sound"
    
  # GAME MODEL
  class exports.GameModel extends FNT.ObservableModel
    constructor: (@levelSequence, @player) ->
      @levelSequence.addObserver(@) # Listen to LevelSequence events
      super()
      @

    handleEvent: (event) ->
      switch event.data
        when FNT.LevelSequenceStates.READY
          @startLevel()

    startGame: ->
      @player.state.set(FNT.PlayerStates.DEAD)
      @levelSequence.start()

    startLevel: ->
      @player.spawn(@levelSequence.currentLevel().spawnLocation)
      @levelSequence.state.set(FNT.LevelSequenceStates.PLAYING)
      
    nextLevel: ->
      @player.state.set(FNT.PlayerStates.DEAD)
      @levelSequence.advance()

    toggleSound: (soundOn) ->    
      @notifyObservers(FNT.GameEvents.TOGGLE_SOUND, soundOn)
