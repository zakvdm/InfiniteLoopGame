### The InputControlled Behaviour applies user input to the player's particle ###

namespace "FNT", (exports) ->

  class exports.InputControlled extends Behaviour
  
      constructor: () ->
        super
        @
      
      create: (@keyboard) ->
        @
      
      apply: (p, dt, index) ->
          
        if @keyboard.JUMP
          p.acc.add(new Vector(0, FNT.PhysicsConstants.JUMP_SPEED))
            
        if @keyboard.LEFT
          p.acc.add(new Vector(-1 * FNT.PhysicsConstants.MOVE_SPEED, 0))
          
        if @keyboard.RIGHT
          p.acc.add(new Vector(FNT.PhysicsConstants.MOVE_SPEED, 0))

