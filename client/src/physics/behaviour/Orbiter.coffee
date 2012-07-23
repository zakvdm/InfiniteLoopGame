### This behaviour attaches the particle to the first Ring it encounters and 'glides' it around the Ring ###

namespace "FNT", (exports) ->

  class exports.RingRiding extends Behaviour

    constructor: (@levelModel, @useMass = yes, @callback = null) ->

        # Delta between particle positions.
        @_delta = new Vector()
        @_ring_to_p = new Vector()
        # Delta between pos and old.pos
        @_delta_pos = new Vector()
        
        @OVERLAP = 4 # How much the particle and the Ring edge will overlap when the particle is attached

        super
        @
        
        
    setActive: (@isActive) ->
      @ring = null # When the state changes, we always want to clear out the Ring we're currently attached to
    
    apply: (p, dt, index) ->
      if not @isActive then return
      
      @ring ?= @findAttachableRing(p)
      
      if not @ring?
        return
        
      # Couple position to Ring
      dist = @distanceBetween(p, @ring) # After this call, @_delta holds a vector from the center of the ring to p
      old_dist = new Vector()
      old_dist.copy(p.old).dist(@ring.position)
      
      if old_dist < @ring.radius < dist or dist < @ring.radius < old_dist
        beef = true
        console.log "CROSSING OVER!"
      
      if dist < @ring.radius
        # Attach to inside
        currentOverlap = dist + p.radius - @ring.radius
        
        if currentOverlap > 7
          console.log "Big overlap: #{currentOverlap} #{beef}"
        
        offset = @OVERLAP - currentOverlap
        p.pos.add(@_delta.norm().scale(offset))
      else
        # Attach to outside
        currentOverlap = @ring.radius + p.radius - dist

        if currentOverlap > 7
          console.log "Big overlap: #{currentOverlap} #{beef}"

        offset = currentOverlap - @OVERLAP # (Vector points from ring -> p, so if the overlap is too small, we need a negative offset)
        p.pos.add(@_delta.norm().scale(offset))
        #p.old.pos.add(@_delta)
        
      # Movement should only be along the circumference of the ring,
      # so we always project the old position so that old_pos -> new_pos
      # forms a vector that is a tangent to the ring
      @_ring_to_p.copy(p.pos).sub(@ring.position).norm()
      @_delta_pos.copy(p.pos).sub(p.old.pos)
      
      component_perpendicular_to_tangent = Vector.project(@_ring_to_p, @_delta_pos) # TODO: Do this without creating a new object (for performance?)
      
      if component_perpendicular_to_tangent.mag() > 2
        console.log "MAKING A BIG ADJUSTMENT"
      
      p.old.pos.add(component_perpendicular_to_tangent)

    findAttachableRing: (p) ->
      for r in @levelModel.getRings() # ring is FNT.RingModel
        if @overlapsWithRing(p, r)
          p.acc.clear()
          @ring = r
          return @ring
        
      null
     
     overlapsWithRing: (p, ring) ->
      dist = @distanceBetween(p, ring)

      outer_perimeter = ring.radius + p.radius
      inner_perimeter = ring.radius - p.radius
      
      return inner_perimeter < dist < outer_perimeter
       
     
     distanceBetween: (a, b) ->
       @_delta.copy(a.pos).sub(b.position) # delta points from ring.position to p.pos
        
       return @_delta.mag()
        
       
