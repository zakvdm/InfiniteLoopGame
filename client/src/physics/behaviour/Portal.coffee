### This behaviour calls a callback when particles enter a specific circle ###

namespace "FNT", (exports) ->

  class exports.Portal extends Behaviour
    constructor: (@levelSequence, @player, @callback) ->
      super()
      @_delta = new Vector()
      @
      
    apply: (p, dt, index) ->
      if @player.state.get() is FNT.PlayerStates.DEAD then return
      
      position = @_getPortalPosition()
      dist = @_delta.copy(position).sub(p.pos).mag()
      
      if dist < FNT.PhysicsConstants.PORTAL_RADIUS
        @callback()
        
    _getPortalPosition: ->
      return new Vector(@levelSequence.currentLevel().exit.x, @levelSequence.currentLevel().exit.y)
