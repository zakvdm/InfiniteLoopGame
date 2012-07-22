### This behaviour attaches the particle to the first Ring it encounters and 'glides' it around the Ring ###

namespace "FNT", (exports) ->

  class exports.RingRiding extends Behaviour

    constructor: (@levelModel, @useMass = yes, @callback = null) ->

        # Delta between particle positions.
        @_delta = new Vector()
        
        @OVERLAP = 5 # How much the particle and the Ring edge will overlap when the particle is attached

        super
        @
    
    apply: (p, dt, index) ->
      ring = @getAttachableRing(p)
      
      if not ring?
        return
        
      # Couple position to Ring
      dist = @distanceBetween(p, ring) # After this call, @_delta holds a vector from the center of the ring to p
      if dist < ring.radius
        # Attach to inside
        currentOverlap = dist + p.radius - ring.radius
        offset = @OVERLAP - currentOverlap
        p.pos.add(@_delta.norm().scale(offset))
      else
        # Attach to outside
        currentOverlap = ring.radius + p.radius - dist
        offset = currentOverlap - @OVERLAP # (Vector points from ring -> p, so if the overlap is too small, we need a negative offset)
        p.pos.add(@_delta.norm().scale(offset))
      
      
      # Apply user input
    
    getAttachableRing: (p) ->
      if p.ring?
        return p.ring
    
      for ring in @levelModel.getRings() # ring is FNT.RingModel
        dist = @distanceBetween(p, ring)

        outer_perimeter = ring.radius + p.radius
        inner_perimeter = ring.radius - p.radius
        
        if inner_perimeter < dist < outer_perimeter # Basically, does p overlap with the Ring
        
          # The particle overlaps with the ring so we attach it:
          p.ring = ring
          return p.ring
        
        null  
     
     distanceBetween: (a, b) ->
       @_delta.copy(a.pos).sub(b.position) # delta points from ring.position to p.pos
        
       return @_delta.mag()
        
       
