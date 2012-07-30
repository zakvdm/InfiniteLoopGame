
# THIS CLASS BUILDS A GAME (The Models, Views, Controllers, EVERYTHING!)
namespace "FNT", (exports) ->

  class exports.GameUIFactory
      
    @build: (scene, gameModel) ->
      menuPanel = FNT.MenuPanelFactory.build(scene)
      infoPanel = FNT.InfoPanelFactory.build(scene)
      return FNT.MenuActorFactory.build(scene, gameModel, menuPanel, infoPanel)

