### This behaviour calls a callback when particles enter a specific circle ###

namespace "FNT", (exports) ->

  class exports.Portal extends Behaviour
    constructor: (@position, @radius, @callback) ->
      super()
      @_delta = new Vector()
      @
      
    apply: (p, dt, index) ->
      dist = @_delta.copy(@position).sub(p.pos).mag()
      
      if dist < @radius
        @callback()
