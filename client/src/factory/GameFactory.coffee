
# THIS CLASS BUILDS A GAME (The Models, Views, Controllers, EVERYTHING!)
namespace "FNT", (exports) ->

  class exports.GameFactory
      
    @build: (director) ->
      @createDatGui()
    
      gameModel = @createGameModel()
      gameController = @createGameController(gameModel)
      return @createGameView(director, gameModel, gameController)
    
    @createGameModel: ->
      levelSequence = FNT.LevelSequenceFactory.build(FNT.GameModes.quest.levelData)
      playerModel = FNT.PlayerFactory.build()
      
      return new FNT.GameModel(levelSequence, playerModel)
    
    @createGameController: (gameModel) ->
      keyboard = new FNT.Keyboard().create()
      
      physics = new FNT.PhysicsController().create(gameModel, keyboard)
      
      return new FNT.GameController(gameModel, physics, keyboard)
      
    @createGameView: (director, gameModel, gameController) ->
      gameScene = FNT.GameSceneActorFactory.build(director, gameModel, gameController)
      
    @createDatGui: ->
      gui = new dat.GUI();
      
      physicsFolder = gui.addFolder('Physics')
      physicsFolder.add(FNT.PhysicsConstants, 'MOVE_SPEED', 0, 500);
      physicsFolder.add(FNT.PhysicsConstants.GRAVITY, 'y', -400, 400);
      physicsFolder.add(FNT.PhysicsConstants, 'AIR_MOVE_SPEED', 0, 200);
      physicsFolder.add(FNT.PhysicsConstants, 'ORBIT_SPEED', 0, 500);
      physicsFolder.add(FNT.PhysicsConstants, 'ORBIT_ATTACH_THRESHOLD', 0, 20);
      physicsFolder.add(FNT.PhysicsConstants, 'PORTAL_RADIUS', 0, 100);
      

