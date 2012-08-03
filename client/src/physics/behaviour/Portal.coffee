### This behaviour calls a callback when particles enter a specific circle ###

namespace "FNT", (exports) ->

  class exports.Portal extends Behaviour
    constructor: (@levelSequence, @player, @exitCallback, @respawnCallback) ->
      super()
      @_delta = new Vector()
      @
      
    apply: (p, dt, index) ->
      if @player.state.get() is FNT.PlayerStates.DEAD then return
      
      @_checkExit(p)
      
      @_checkRespawn(p)
        
    _checkExit: (p) ->
      dist = @_getDistance(@levelSequence.currentLevel().exit, p)
      
      if dist < FNT.PhysicsConstants.PORTAL_RADIUS
        @exitCallback()
        
    _checkRespawn: (p) ->
      for portal in @levelSequence.currentLevel().getPortals()
        dist = @_getDistance(portal.position, p)
        
        if dist < portal.radius + FNT.PlayerConstants.RADIUS
          @respawnCallback()
        
    _getPortalPosition: ->
      return new Vector(@levelSequence.currentLevel().exit.x, @levelSequence.currentLevel().exit.y)
      
    _getDistance: (portal, p) ->
      position = new Vector(portal.x, portal.y)
      return @_delta.copy(position).sub(p.pos).mag()
      
