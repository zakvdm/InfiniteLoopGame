### CouplePosition Behaviour couples the position of an arbitrary entity to a particle ###

namespace "FNT", (exports) ->

  class exports.CouplePosition extends Behaviour
  
      constructor: (@target) ->
        super
  
      apply: (p, dt, index) ->
        @target.setPosition(p.pos)
  