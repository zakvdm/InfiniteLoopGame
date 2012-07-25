### Controller responsible for physics ###
namespace "FNT", (exports) ->

  class exports.PhysicsController
    constructor: ->
    
    create: (@gameModel, @keyboard) ->
      @physics = new Physics(new Verlet())
      
      #@attraction = new Attraction(new Vector(500, 200), 1200, 1200)
      
      # Add gravity
      @gravity = new ConstantForce(new Vector 0.0, 150.0)
      @physics.behaviours.push @gravity

      @initPlayerPhysics(@gameModel.player, @gameModel.levelSequence)

      @gameModel.addObserver(@)
      @

    step: ->
      @physics.step()
      
    initPlayerPhysics: (playerModel, levelSequence) ->
      @player = new FNT.PlayerParticle().create(playerModel, levelSequence, @keyboard)
      
      @physics.particles.push(@player)
