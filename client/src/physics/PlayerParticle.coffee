### This class models a Frenetic Player's interaction with the physics system ###

namespace "FNT", (exports) ->

  class exports.PlayerParticle extends Particle
    constructor: ->
      super()
      @
    
    create: (@playerModel) ->
      @couplePosition = new FNT.CouplePosition(@playerModel)

      @keyboard = new FNT.Keyboard().create(
        (inAlternateState) => @onStateChanged(inAlternateState))

      @setRadius(@playerModel.radius)

      @playerModel.addObserver(this)
      @

    onStateChanged: (inAlternateState) ->
      @orbiter.setActive(inAlternateState)
      @levelCollision.setActive(not inAlternateState)

    handleEvent: (event) ->
      switch event.type
        when FNT.PlayerEvents.SPAWN
          @spawn()

    spawn: ->
      @moveTo new Vector(@playerModel.position.x, @playerModel.position.y)
      
      @levelCollision = new FNT.LevelCollision(@playerModel.level, @keyboard)
      @orbiter = new FNT.Orbiter(@playerModel.level, @keyboard)

      @behaviours.push(@orbiter) # Allow the player to be controlled by User input (we want these accelerations to be applied first (they can be modified by later behaviours))
      @behaviours.push(@levelCollision)
      @behaviours.push(@couplePosition) # couple the particle position to the PlayerModel (which will in turn be represented by an Actor)
      
      @orbiter.setActive(false)
      @levelCollision.setActive(true)
      
