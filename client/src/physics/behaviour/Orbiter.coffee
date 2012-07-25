### This behaviour attaches the particle to the first Ring it encounters and 'glides' it around the Ring ###

namespace "FNT", (exports) ->

  class exports.Orbiter extends Behaviour

    constructor: (@levelSequence, @keyboard, @callback = null) ->

        # Delta between particle positions.
        @_delta = new Vector()
        @_acceleration = new Vector()
        @_accumulated_acceleration = new Vector()
        
        @orbit = 0
        
        @TRACKING_FACTOR = 1.0 # This is basically the same as Spring 'stiffness'

        super
        @
        
    setActive: (@isActive) ->
      @ring = null # When the state changes, we always want to clear out the Ring we're currently attached to
   
    applyUserInput: (p, dt) ->
      @_acceleration.clear()
      speed = FNT.PhysicsConstants.ORBIT_SPEED
      
      if @keyboard.UP
        @_acceleration.y -= speed
        
      if @keyboard.DOWN
        @_acceleration.y += speed
          
      if @keyboard.RIGHT
        @_acceleration.x += speed
        
      if @keyboard.LEFT
        @_acceleration.x -= speed
        
      @_accumulated_acceleration.add(@_acceleration)
      
      @adjustOrbitOverTime(p, dt)
      
      p.acc.add(@_acceleration)
    
    adjustOrbitOverTime: (p, dt) ->
      if @orbit > @ring.radius # Orbiting on the outside
        @orbit -= (dt * FNT.PhysicsConstants.ORBIT_CHANGE_PER_SECOND) if @orbit > (@ring.radius + FNT.PhysicsConstants.MINIMUM_OUTER_ORBIT_OFFSET)
      else # Orbiting on the inside
        @orbit += (dt * FNT.PhysicsConstants.ORBIT_CHANGE_PER_SECOND) if @orbit < (@ring.radius - FNT.PhysicsConstants.MINIMUM_INNER_ORBIT_OFFSET)
      
     
    applyTracking: (p) ->
      # This uses a spring-like approach
      dist = @distanceBetween(p, @ring) + 0.000001 # After this call, @_delta holds a vector from the centre of the ring to p
      
      force = ((@orbit - dist) * @TRACKING_FACTOR)
      p.pos.add(@_delta.norm().scale(force))
    
    apply: (p, dt, index) ->
      if not @isActive then return
      
      @ring ?= @findAttachableRing(p)
      
      if not @ring? then return # We're not Orbiting anything yet
       
      @applyTracking(p) # We do this first so we can re-use the calculated value of @_delta when we apply user input
      @applyUserInput(p, dt)
      

    findAttachableRing: (p) ->
      for r in @levelSequence.getCurrentLevel().getRings() # ring is FNT.RingModel
        dist = @distanceBetween(p, r)
  
        outer_perimeter = r.radius + p.radius
        inner_perimeter = r.radius - p.radius
        
        threshold = FNT.PhysicsConstants.ORBIT_ATTACH_THRESHOLD
        
        if inner_perimeter - threshold < dist < outer_perimeter + threshold
          # Overlaps!
          @ring = r
          @_accumulated_acceleration.clear()
          if dist < @ring.radius # We're inside the ring
            @orbit = @ring.radius - FNT.PhysicsConstants.INITIAL_ORBIT_OFFSET
          else
            @orbit = @ring.radius + FNT.PhysicsConstants.INITIAL_ORBIT_OFFSET
          
          # Fire callback if defined.
          @callback?(p, @ring)
          
          return @ring
        
      null
     
    distanceBetween: (a, b) ->
       @_delta.copy(a.pos).sub(b.position) # delta points from ring.position to p.pos
       return @_delta.mag()
        
       
