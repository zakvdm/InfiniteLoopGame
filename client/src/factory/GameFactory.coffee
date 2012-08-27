
# THIS CLASS BUILDS A GAME (The Models, Views, Controllers, EVERYTHING!)
namespace "FNT", (exports) ->

  class exports.GameFactory
      
    @build: (director) ->
    
      gameModel = @createGameModel()
      gameController = @createGameController(gameModel)
      
      @createDatGui(gameModel)
      
      return @createGameView(director, gameModel, gameController)
    
    @createGameModel: ->
      levelSequence = FNT.LevelSequenceFactory.build(FNT.GameModes.quest.levelData)
      playerModel = FNT.PlayerFactory.build()
      
      return new FNT.GameModel(levelSequence, playerModel)
    
    @createGameController: (gameModel) ->
      keyboard = new FNT.Keyboard().create()
      
      physics = new FNT.PhysicsController().create(gameModel, keyboard)
      @sound = new FNT.SoundController().create(gameModel, keyboard)
      
      return new FNT.GameController([physics, @sound], gameModel, keyboard)
      #return new FNT.GameController([physics], gameModel, keyboard)
      
    @createGameView: (director, gameModel, gameController) ->
      gameScene = FNT.GameSceneActorFactory.build(director, gameModel, gameController)
      
    @createDatGui: (gameModel) ->
      gui = new dat.GUI();
      
      physicsFolder = gui.addFolder('Physics')
      physicsFolder.add(FNT.PhysicsConstants, 'MOVE_SPEED', 0, 500);
      physicsFolder.add(FNT.PhysicsConstants.GRAVITY, 'y', -400, 400);
      physicsFolder.add(FNT.PhysicsConstants, 'AIR_MOVE_SPEED', 0, 200);
      physicsFolder.add(FNT.PhysicsConstants, 'ORBIT_SPEED', 0, 500);
      physicsFolder.add(FNT.PhysicsConstants, 'ORBIT_ATTACH_THRESHOLD', 0, 20);
      physicsFolder.add(FNT.PhysicsConstants, 'PORTAL_RADIUS', 0, 100);
      
      levelFolder = gui.addFolder('Level')
      levelController = levelFolder.add(gameModel.levelSequence, "_currentIndex", 0, gameModel.levelSequence._levels.length - 1).step(1).listen()
      levelController.onFinishChange((value) => gameModel.levelSequence.skipToLevel(value))
      
      playerFolder = gui.addFolder('Player')
      playerFolder.add(gameModel.player.position, "x").listen()
      playerFolder.add(gameModel.player.position, "y").listen()
      playerFolder.add(gameModel.player, "speed").listen()
      
      #soundFolder = gui.addFolder('Sound')
      #soundController = soundFolder.add(@sound, "VOLUME", 0, 1).step(0.1).listen()
      #soundController.onFinishChange((volume) => @sound.setVolume(volume))
      #freqModulator = soundFolder.add(@sound.playerSynth, "FREQUENCY_MODULATION", 0, 50).step(1).listen()
      #freqModulator.onFinishChange((modulation) => @sound.playerSynth.setFrequencyModulation(modulation))
      #soundFolder.add(FNT.PlayerSynth, "NORMAL_FREQUENCY", 10, 400)
      #soundFolder.add(FNT.PlayerSynth, "ORBIT_FREQUENCY", 10, 500)
      #soundFolder.add(FNT.PlayerSynth, "MAXIMUM_SPEED", 0, 12).step(1)
      #soundFolder.add(FNT.PlayerSynth, "GAIN_DELTA", 0, 1).step(0.005)
      #soundFolder.add(FNT.PlayerSynth, "FREQUENCY_DELTA", 0, 50).step(1)

