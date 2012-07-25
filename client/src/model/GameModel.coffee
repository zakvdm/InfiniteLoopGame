
namespace "FNT", (exports) ->

  # GAME MODEL
  class exports.GameModel extends FNT.ObservableModel
    constructor: (@levelSequence, @player) ->
      @levelSequence.addObserver(@) # Listen to LevelSequence events
      super()
      @

    step: ->
      if @physicsController?
        @physicsController.step() # TODO: The way i'm doing the timestep is totally hacky (the physics engine ends up doing the same work that CAAT is, and what if it's slightly out of phase?)
  
    handleEvent: (event) ->
      switch event.data
        when FNT.LevelSequenceStates.READY
          @startLevel()

    startGame: ->
      @levelSequence.start()

    startLevel: ->
      @player.spawn(@levelSequence.getCurrentLevel().spawnLocation)
      @levelSequence.state.set(FNT.LevelSequenceStates.PLAYING)
      
    nextLevel: ->
      @levelSequence.advance()
