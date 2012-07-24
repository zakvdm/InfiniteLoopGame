
# THIS CLASS BUILDS A GAME (The Models, Views, Controllers, EVERYTHING!)
namespace "FNT", (exports) ->

  class exports.GameFactory extends FNT.ObservableModel
      
    @build: (director) ->
      gameModel = @createGameModel()
      gameController = @createGameController(gameModel)
      gameView = @createGameView(director, gameModel, gameController)
      return gameView
    
    @createGameModel: ->
      levelModel = FNT.LevelFactory.build()
      playerModel = FNT.PlayerFactory.build()
      
      gameModel = new FNT.GameModel(levelModel, playerModel)
      return gameModel
    
    @createGameController: (gameModel) ->
      physics = new FNT.PhysicsController().create(gameModel)
      gameController = new FNT.GameController(physics)
      return gameController
      
    @createGameView: (director, gameModel, gameController) ->
      gameScene = FNT.GameSceneActorFactory.build(director, gameModel, gameController)
