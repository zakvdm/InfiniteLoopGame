### Controller responsible for physics ###
namespace "FNT", (exports) ->

  class exports.PhysicsController
    constructor: ->
    
    create: (@gameModel, @keyboard) ->
      @physics = new Physics(new Verlet())

      # Add gravity
      @gravity = new ConstantForce(FNT.PhysicsConstants.GRAVITY)
      @physics.behaviours.push(@gravity)

      @initPlayerPhysics(@gameModel.player, @gameModel.levelSequence)
      
      @portal = new FNT.Portal(@gameModel.levelSequence,
                               @gameModel.player,
                               => @gameModel.nextLevel(), # onExit
                               => @gameModel.startLevel()) # onRespawn
      @physics.behaviours.push(@portal)
      
      @

    step: ->
      @physics.step()
    
    initPlayerPhysics: (playerModel, levelSequence) ->
      @player = new FNT.PlayerParticle().create(playerModel, levelSequence, @keyboard)
      
      @physics.particles.push(@player)
      
