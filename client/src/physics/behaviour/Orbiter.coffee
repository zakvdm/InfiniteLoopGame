### This behaviour attaches the particle to the first Ring it encounters and 'glides' it around the Ring ###

namespace "FNT", (exports) ->

  class exports.Orbiter extends Behaviour

    constructor: (@levelModel, @keyboard, @physics, @useMass = yes, @callback = null) ->

        # Delta between particle positions.
        @_delta = new Vector()
        @_acceleration = new Vector()
        @_accumulated_acceleration = new Vector()
        
        @orbit = 0
        @INITIAL_ORBIT_OFFSET = 12
        @MINIMUM_INNER_ORBIT_OFFSET = 6
        @MINIMUM_OUTER_ORBIT_OFFSET = 6 # This value is higher so that there's less "jump" when you let go from the outside (which makes it easier to go from one outer orbit to the next)
        @ORBIT_CHANGE_PER_SECOND = 6
        
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
      
      #@adjustOrbit(p, @_accumulated_acceleration)
      @adjustOrbitOverTime(p, dt)
      
      p.acc.add(@_acceleration)
    
    adjustOrbitOverTime: (p, dt) ->
      if @orbit > @ring.radius # Orbiting on the outside
        @orbit -= (dt * @ORBIT_CHANGE_PER_SECOND) if @orbit > (@ring.radius + @MINIMUM_OUTER_ORBIT_OFFSET)
      else # Orbiting on the inside
        @orbit += (dt * @ORBIT_CHANGE_PER_SECOND) if @orbit < (@ring.radius - @MINIMUM_INNER_ORBIT_OFFSET)
      
     
    adjustOrbit: (p, acceleration) ->
      # Lets work out the component of acceleration that is perpendicular to the orbit (this is what determines if we shift orbits or not)
      # @_delta is a vector from the ring centre to p
      @_delta.copy(p.pos).sub(@ring.position)
      orbit_changing_force = @_delta.dot(acceleration) / @_delta.magSq() # Positive here means change towards the outer orbit (ie. along @_delta)
      
      THRESHOLD = FNT.PhysicsConstants.ORBIT_CHANGE_THRESHOLD
      if (-1 * THRESHOLD) < orbit_changing_force < THRESHOLD then return
      
      if @orbit > @ring.radius and orbit_changing_force < 0 # We are orbiting outside and moving inside
        @orbit = @ring.radius - FNT.PhysicsConstants.ORBIT_OFFSET
      else if @orbit < @ring.radius and orbit_changing_force > 0 # We are orbiting inside and moving outside
        @orbit = @ring.radius + FNT.PhysicsConstants.ORBIT_OFFSET
        
    
    applyTracking: (p) ->
      dist = @distanceBetween(p, @ring) + 0.000001 # After this call, @_delta holds a vector from the center of the ring to p
      
      force = ((@orbit - dist) * @TRACKING_FACTOR)
      p.pos.add(@_delta.norm().scale(force))
    
    apply: (p, dt, index) ->
      if not @isActive then return
      
      @ring ?= @findAttachableRing(p)
      
      if not @ring? then return
       
      @applyTracking(p) # We do this first so we can re-use the calculated value of @_delta when we apply user input
      @applyUserInput(p, dt)
      

    findAttachableRing: (p) ->
      for r in @levelModel.getRings() # ring is FNT.RingModel
        dist = @distanceBetween(p, r)
  
        outer_perimeter = r.radius + p.radius
        inner_perimeter = r.radius - p.radius
        
        if inner_perimeter < dist < outer_perimeter
          # Overlaps!
          @ring = r
          @_accumulated_acceleration.clear()
          if dist < @ring.radius # We're inside the ring
            #@orbit = @ring.radius - FNT.PhysicsConstants.ORBIT_OFFSET
            @orbit = @ring.radius - @INITIAL_ORBIT_OFFSET
          else
            #@orbit = @ring.radius + FNT.PhysicsConstants.ORBIT_OFFSET
            @orbit = @ring.radius + @INITIAL_ORBIT_OFFSET
          return @ring
        
      null
     
    distanceBetween: (a, b) ->
       @_delta.copy(a.pos).sub(b.position) # delta points from ring.position to p.pos
        
       return @_delta.mag()
        
       
