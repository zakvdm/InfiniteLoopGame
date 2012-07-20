
namespace "FNT", (exports) ->

  class exports.PhysicsController
    constructor: ->
      @
    
    create: (@gameModel) ->
      @physics = new Physics(new Verlet())
      @attraction = new Attraction(new Vector(300, 400), 1200, 1200)

      @gameModel.addObserver(this)
      @

    step: ->
      @physics.step()

    handleEvent: (event) ->
      switch event.type
        when FNT.GameModelEvents.ADDED_PLAYER
          @initPlayerPhysics event.data
          
    initPlayerPhysics: (playerModel) ->
      p = new Particle()
      
      p.setRadius playerModel.radius
      p.moveTo new Vector(playerModel.position.x, playerModel.position.y)
      
      couplePosition = new FNT.CouplePosition playerModel

      p.behaviours.push @attraction
      p.behaviours.push couplePosition # couple the particle position to the PlayerModel (which will in turn be represented by an Actor)

      @physics.particles.push p
      
