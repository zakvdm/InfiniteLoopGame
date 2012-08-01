### This class models a Player's interaction with the physics system ###

namespace "FNT", (exports) ->

  class exports.PlayerParticle extends Particle
    constructor: ->
      super()
      @
    
    create: (@playerModel, @levelSequence, @keyboard) ->
      @couplePosition = new FNT.CouplePosition(@playerModel)
        
      @keyboard.ORBIT.addListener(FNT.KeyDown, => @setOrbitState(true))
      @keyboard.ORBIT.addListener(FNT.KeyUp, => @setOrbitState(false))

      @setRadius(FNT.PlayerConstants.RADIUS)

      @levelCollision = new FNT.LevelCollision(@levelSequence, @keyboard)
      @orbiter = new FNT.Orbiter(@levelSequence, @keyboard, @onOrbitStart)
      
      @levelCollision.setActive(false)
      @orbiter.setActive(false)

      @behaviours.push(@orbiter) # Allow the player to be controlled by User input (we want these accelerations to be applied first (they can be modified by later behaviours))
      @behaviours.push(@levelCollision)
      @behaviours.push(@couplePosition) # couple the particle position to the PlayerModel (which will in turn be represented by an Actor)
      
      @playerModel.addObserver(this)
      @
      
    setOrbitState: (isOrbiting) ->
      @clearState() # Always start in the normal state, and the behaviours can change the state as appropriate
      
      @orbiter.setActive(isOrbiting)
      @levelCollision.setActive(not isOrbiting)

    clearState: ->
      @playerModel.state.set(FNT.PlayerStates.NORMAL)
      @levelSequence.currentLevel().resetAllRings()

    handleEvent: (event) ->
      switch event.type
        when FNT.PlayerEvents.SPAWN
          @spawn()
          
        when FNT.PlayerStates.DEAD
          @fixed = true

    onOrbitStart: (p, ring) ->
      p.playerModel.state.set(FNT.PlayerStates.ORBITING)
      @levelSequence.currentLevel().setOrbited(ring)
      

    spawn: ->
      @fixed = false
      @moveTo new Vector(@playerModel.position.x, @playerModel.position.y)
      
      @orbiter.setActive(false)
      @levelCollision.setActive(true)
      
