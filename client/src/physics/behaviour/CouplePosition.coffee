### CouplePosition Behaviour couples the position of an arbitrary entity to a particle ###

namespace "FNT", (exports) ->

  class exports.CouplePosition extends Behaviour
  
      constructor: (@target) ->
        super()
        
        @_velocity = new Vector()
  
      apply: (p, dt, index) ->
        @_velocity.copy(p.pos).sub(@target.position)
        @target.setVelocity(@_velocity)
        @target.setPosition(p.pos)
  