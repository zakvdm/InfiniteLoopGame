
namespace "FNT", (exports) ->

  class exports.GameController
    constructor: (@physicsController) ->
      @

    step: ->
      if @physicsController?
        @physicsController.step() # TODO: The way i'm doing the timestep is totally hacky (the physics engine ends up doing the same work that CAAT is, and what if it's slightly out of phase?)