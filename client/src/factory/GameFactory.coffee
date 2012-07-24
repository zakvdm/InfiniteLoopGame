
# THIS CLASS BUILDS A GAME (The Models, Views, Controllers, EVERYTHING!)
namespace "FNT", (exports) ->

  class exports.GameFactory extends FNT.ObservableModel
      
    @build: (director) ->
      gameModel = @createGameModel()
      gameController = @createGameController(gameModel)
      return @createGameView(director, gameModel, gameController)
    
    @createGameModel: ->
      levelModel = FNT.LevelFactory.build()
      playerModel = FNT.PlayerFactory.build()
      
      return new FNT.GameModel(levelModel, playerModel)
    
    @createGameController: (gameModel) ->
      keyboard = new FNT.Keyboard().create()
      
      physics = new FNT.PhysicsController().create(gameModel, keyboard)
      
      return new FNT.GameController(gameModel, physics, keyboard)
      
    @createGameView: (director, gameModel, gameController) ->
      gameScene = FNT.GameSceneActorFactory.build(director, gameModel, gameController)
