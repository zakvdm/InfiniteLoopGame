### This Behaviour handles Collisions with the FNT.LevelModel ###

namespace "FNT", (exports) ->

  class exports.LevelCollision extends Behaviour

    constructor: (@levelSequence, @keyboard, @useMass = yes, @callback = null) ->

        # Delta between particle positions.
        @_delta = new Vector()

        super
        
    setActive: (@isActive) ->
    
    apply: (p, dt, index) ->
      if not @isActive then return
      
      @handleCollisions(p)
      @applyUserInput(p)
    
    handleCollisions: (p) ->  
      @onRing = false
      
      for ring in @levelSequence.currentLevel().getRings() # ring is FNT.RingModel
        @_delta.copy(p.pos).sub(ring.position) # delta points from ring.position to p.pos
        
        # Distance from the particle centre to the Ring centre
        dist = @_delta.mag()
        
        outer_perimeter = ring.radius + p.radius
        inner_perimeter = ring.radius - p.radius
        
        if inner_perimeter < dist < outer_perimeter # Basically, does p overlap with the Ring
          # MOVING OUT OF THE RING:
          if dist > ring.radius
            @onRing = true if p.pos.y < ring.position.y
            
            overlap = outer_perimeter - dist
            delta = @_delta.clone()
            outward_force = delta.dot(p.vel) / delta.magSq() # Positive here means change towards the outer orbit (ie. along @_delta)
            if outward_force >= 0
              p.pos.add(p.vel.clone().norm().scale(overlap / 10)) # p is naturally going to leave the ring anyway, let's just help it along...
            else
              # The Ring is static, so we move p out of the collision
              p.pos.add(@_delta.norm().scale(overlap))
          
          # MOVING INTO THE RING:    
          else # p is 'inside' the Ring (so we should move it towards the centre of the Ring)
            @onRing = true if p.pos.y > ring.position.y
          
            overlap = inner_perimeter - dist # This will be 'negative' overlap
            # The Ring is static, so we move p out of the collision
            p.pos.add(@_delta.norm().scale(overlap))
        
           
          # Fire callback if defined.
          @callback?(p, o, overlap)

    applyUserInput: (p) ->
      speed = FNT.PhysicsConstants.AIR_MOVE_SPEED
      if @onRing # if touching level
        speed = FNT.PhysicsConstants.MOVE_SPEED
        
        if @keyboard.JUMP
          p.acc.add(new Vector(0, FNT.PhysicsConstants.JUMP_SPEED))
            
      if @keyboard.LEFT
        p.acc.add(new Vector(-1 * speed, 0))
        
      if @keyboard.RIGHT
        p.acc.add(new Vector(speed, 0))
   