### Controller responsible for physics ###
namespace "FNT", (exports) ->

  class exports.PhysicsController
    constructor: ->
      @
    
    create: (@gameModel) ->
      @physics = new Physics(new Verlet())
      
      #@attraction = new Attraction(new Vector(500, 200), 1200, 1200)
      
      # Add gravity
      @gravity = new ConstantForce(new Vector 0.0, 150.0)
      @physics.behaviours.push @gravity
      
      @inputControlled = new FNT.InputControlled().create()

      @gameModel.addObserver(this)
      @

    step: ->
      @physics.step()
      
    applyInput: (inputState) ->
      @input.state = inputState

    handleEvent: (event) ->
      switch event.type
        when FNT.GameModelEvents.CREATE_LEVEL
          @levelModel = event.data
        when FNT.GameModelEvents.ADDED_PLAYER
          @initPlayerPhysics(event.data)
        when FNT.PlayerEvents.SPAWN
          @spawnPlayer(event.data)
          
          
    initPlayerPhysics: (playerModel) ->
      @player = new Particle()
      @player.setRadius(playerModel.radius)
      
      playerModel.addObserver(this)
      
    spawnPlayer: (playerModel) ->
      @player.moveTo new Vector(playerModel.position.x, playerModel.position.y)
      
      levelCollision = new FNT.LevelCollision @levelModel
      couplePosition = new FNT.CouplePosition playerModel

      @player.behaviours.push levelCollision
      @player.behaviours.push @inputControlled # Allow the player to be controlled by User input
      @player.behaviours.push couplePosition # couple the particle position to the PlayerModel (which will in turn be represented by an Actor)

      @physics.particles.push @player
      
