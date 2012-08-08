
namespace "FNT", (exports) ->

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
