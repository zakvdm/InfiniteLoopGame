### This class models a Frenetic Player's interaction with the physics system ###

namespace "FNT", (exports) ->

  class exports.PlayerParticle extends Particle
    constructor: ->
      super()
      @
    
    create: (@playerModel) ->
      @keyboard = new FNT.Keyboard().create(
        (inAlternateState) => @onStateChanged(inAlternateState))
      
      @setRadius(@playerModel.radius)
      @inputControlled = new FNT.InputControlled().create(@keyboard)
      
      @playerModel.addObserver(this)
      @
      
    onStateChanged: (inAlternateState) ->
      if not @behaviours[0]? then return # We haven't spawned yet
      if inAlternateState
        @behaviours[0] = @ringRiding
      else
        @behaviours[0] = @levelCollision
      
    handleEvent: (event) ->
      switch event.type
        when FNT.PlayerEvents.SPAWN
          @spawn()

    spawn: ->
      @moveTo new Vector(@playerModel.position.x, @playerModel.position.y)
      
      @levelCollision = new FNT.LevelCollision(@playerModel.level)
      @ringRiding = new FNT.RingRiding(@playerModel.level)
      couplePosition = new FNT.CouplePosition(@playerModel)

      @behaviours.push(@levelCollision)
      @behaviours.push(@inputControlled) # Allow the player to be controlled by User input
      @behaviours.push(couplePosition) # couple the particle position to the PlayerModel (which will in turn be represented by an Actor)

    
