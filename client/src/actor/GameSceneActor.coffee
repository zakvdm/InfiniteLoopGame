###
 # Game Scene Actor:
 #  Main entry point for all the Actors that constitute the scene.
 #  Responsible for creating the scene with the Director.
###

namespace "FNT", (exports) ->
  class exports.GameSceneActor
    constructor: ->
      @
  
    ###
     # Creates the main game Scene.
     # @param director a CAAT.Director instance.
    ### 
    create: (@director) -> 
      @gameModel = new FNT.GameModel().addObserver this # Create a GameModel and register to observe changes to it
  
      # Create a scene, and start the game when the scene finishes initializing
      @directorScene = director.createScene()
      @directorScene.activated = =>
        @gameModel.startGame(FNT.GameModes.quest)
      @directorScene.onRenderStart = (deltaTime) =>
        @gameModel.step()
  
      # CREATE THE BACKGROUND (We want to add this first because it should be at the back):
      @backgroundContainer = new FNT.BackgroundContainer().create(@directorScene, director.width, director.height)
  
      # This will create all of the entities contained in the GameModel
      # (so the Scene should already be created so there's something to attach the entities to...)
      this.gameModel.create()
  
      @
  
    createLevel : (levelModel) ->
      @levelContainer = new FNT.LevelContainer().
                            create(@directorScene, levelModel).
                            setSize(@director.width, @director.height).
                            setLocation(0, 0)
  
    createPlayer : (player) ->
      @playerActor = new FNT.PlayerActor().
                           create(@directorScene, player)
  
    handleEvent : (event) ->
      switch event.type
        when FNT.GameModelEvents.ADDED_PLAYER
          @createPlayer event.data
        when FNT.GameModelEvents.CREATE_LEVEL
          @createLevel event.data
        else
          console.log "UNKNOWN EVENT TYPE! #{event.type}"
           
