
# THIS CLASS BUILDS A GAME (The Models, Views, Controllers, EVERYTHING!)
namespace "FNT", (exports) ->

  class exports.GameUIFactory
      
    @build: (scene, gameModel) ->
      return FNT.MenuActorFactory.build(scene, gameModel)

