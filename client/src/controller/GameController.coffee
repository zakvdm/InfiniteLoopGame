
namespace "FNT", (exports) ->

  class exports.GameController
    constructor: (@gameModel, @physicsController, @keyboard) ->
      @registerKeyListeners(@keyboard)
      @

    step: ->
      if @physicsController?
        @physicsController.step() # TODO: The way i'm doing the timestep is totally hacky (the physics engine ends up doing the same work that CAAT is, and what if it's slightly out of phase?)

    reset: ->
      @gameModel.startLevel()
    
    registerKeyListeners: ->      
      @keyboard.RESET.addListener(FNT.KeyDown, => @reset())
      @keyboard.NEXT_LEVEL.addListener(FNT.KeyDown, => @gameModel.loadLevel(@gameModel.currentLevelIndex + 1))
      @keyboard.PREVIOUS_LEVEL.addListener(FNT.KeyDown, => @gameModel.loadLevel(@gameModel.currentLevelIndex - 1))
      