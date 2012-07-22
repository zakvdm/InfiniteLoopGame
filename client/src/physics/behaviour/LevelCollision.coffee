### This Behaviour handles Collisions with the FNT.LevelModel ###

namespace "FNT", (exports) ->

  class exports.LevelCollision extends Behaviour

    constructor: (@levelModel, @useMass = yes, @callback = null) ->

        # Delta between particle positions.
        @_delta = new Vector()

        super
        
    setActive: (@isActive) ->
    
    apply: (p, dt, index) ->
      if not @isActive then return
      
      for ring in @levelModel.getRings() # ring is FNT.RingModel
        @_delta.copy(p.pos).sub(ring.position) # delta points from ring.position to p.pos
        
        # Distance from the particle centre to the Ring centre
        dist = @_delta.mag()
        
        outer_perimeter = ring.radius + p.radius
        inner_perimeter = ring.radius - p.radius
        
        if inner_perimeter < dist < outer_perimeter # Basically, does p overlap with the Ring
          if dist > ring.radius # p is 'outside' the Ring
            overlap = outer_perimeter - dist
          else # p is 'inside' the Ring (so we should move it towards the centre of the Ring)
            overlap = inner_perimeter - dist # This will be 'negative' overlap
        
          # The Ring is static, so we move p out of the collision
          p.pos.add(@_delta.norm().scale(overlap))
           
          # Fire callback if defined.
          @callback?(p, o, overlap)
