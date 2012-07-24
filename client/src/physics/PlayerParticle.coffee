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
        
      @keyboard.addListener(FNT.Keys.ORBIT, FNT.KeyDown, => @setOrbitState(true))
      @keyboard.addListener(FNT.Keys.ORBIT, FNT.KeyUp, => @setOrbitState(false))

      @setRadius(@playerModel.radius)

      @playerModel.addObserver(this)
      @
      
    setOrbitState: (isOrbiting) ->
      @clearState() # Always start in the normal state, and the behaviours can change the state as appropriate
      
      @orbiter.setActive(isOrbiting)
      @levelCollision.setActive(not isOrbiting)

    clearState: ->
      @playerModel.state.set(FNT.PlayerStates.NORMAL)
      @playerModel.level.resetAllRings()

    handleEvent: (event) ->
      switch event.type
        when FNT.PlayerEvents.SPAWN
          @spawn()

    onOrbitStart: (p, ring) ->
      p.playerModel.state.set(FNT.PlayerStates.ORBITING)
      ring.setOrbited(true)
      

    spawn: ->
      @moveTo new Vector(@playerModel.position.x, @playerModel.position.y)
      
      @levelCollision = new FNT.LevelCollision(@playerModel.level, @keyboard)
      @orbiter = new FNT.Orbiter(@playerModel.level, @keyboard, @onOrbitStart)

      @behaviours.push(@orbiter) # Allow the player to be controlled by User input (we want these accelerations to be applied first (they can be modified by later behaviours))
      @behaviours.push(@levelCollision)
      @behaviours.push(@couplePosition) # couple the particle position to the PlayerModel (which will in turn be represented by an Actor)
      
      @orbiter.setActive(false)
      @levelCollision.setActive(true)
      
