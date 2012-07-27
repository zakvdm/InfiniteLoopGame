###
 # Game Scene Actor:
 #  Main entry point for all the Actors that constitute the scene.
 #  Responsible for creating the scene with the Director.
###

namespace "FNT", (exports) ->
  class exports.GameSceneActorFactory
    @build: (director, gameModel, gameController) ->
      gameActor = new FNT.GameSceneActor().create(director, gameModel, gameController)
      
      return gameActor

  class exports.GameSceneActor
    constructor: () ->
      @

    ###
     # Creates the main game Scene.
     # @param director a CAAT.Director instance.
     # @param gameModel The FNT.GameModel instance that this Actor will represent.
    ### 
    create: (@director, @gameModel, @gameController) -> 
      # Create a scene, and start the game when the scene finishes initializing
      @directorScene = director.createScene()
      @directorScene.activated = =>
        @gameModel.startGame()
      @directorScene.onRenderStart = (deltaTime) =>
        @gameController.step()
  
      # CREATE THE BACKGROUND (We want to add this first because it should be at the back):
      @backgroundContainer = new FNT.BackgroundContainer().create(@directorScene, director.width, director.height)

      @createLevelContainer(@gameModel.levelSequence)
      @createPlayer(@gameModel.player)

      @
  
    createLevelContainer : (levelSequence) ->
      @levelSequenceActor = new FNT.LevelSequenceActor().
                            create(@directorScene, levelSequence).
                            setLocation(0, 0)
                            
    createPlayer : (player) ->
      @playerActor = new FNT.PlayerActor().
                           create(@directorScene, player)

