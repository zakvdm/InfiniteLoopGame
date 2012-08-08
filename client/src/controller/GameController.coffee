
namespace "FNT", (exports) ->

  class exports.GameController
    constructor: (@controllers, @gameModel, @keyboard) ->
      @registerKeyListeners(@keyboard)
      @

    step: ->
      for controller in @controllers when controller?
        controller.step() # TODO: The way i'm doing the timestep is totally hacky (the physics engine ends up doing the same work that CAAT is, and what if it's slightly out of phase?)

    reset: ->
      @gameModel.startLevel()
    
    registerKeyListeners: ->      
      @keyboard.RESET.addListener(FNT.KeyDown, => @reset())
      @keyboard.NEXT_LEVEL.addListener(FNT.KeyDown, => @gameModel.nextLevel())
      