###
 # Main Entry Point
###
namespace "FNT", (exports) ->

  __FNT__createLoadingScene = (director) ->
    ladingImg = director.getImage('lading');
    oImg = director.getImage('rueda');
    scene = director.createScene();
  
    ###  
    scene.addChild(
      new CAAT.Actor().
        setBackgroundImage(
          director.getImage('splash')
        )
    )
  
    scene.addChild(
      ladingActor = new CAAT.Actor().
        setBackgroundImage(ladingImg).
        setLocation(
          director.width - ladingImg.width - 10,
          director.height - ladingImg.height - 30
        )
    )
  
    scene.addChild(
      oActor = new CAAT.Actor().
        setBackgroundImage(oImg).
        setLocation(ladingActor.x + 20, ladingActor.y + 10).
        addBehavior(
          new CAAT.RotateBehavior().
            setValues(0,2*Math.PI).
            setFrameTime(0, FNT.Time.ONE_SECOND).
            setCycle(true)
          )
    )
    ###
  
    scene.loadedImage = (count, images) ->
      __end_loading(director, images) if count == images.length
  
    scene # return the scene object
    
  __end_loading = (director) ->
    director.emptyScenes()
  
    gameScene = FNT.GameFactory.build(director)
  
    # LOAD THE FIRST SCENE: 
    director.easeIn(
      0,
      CAAT.Scene.prototype.EASE_TRANSLATE,
      1000,
      false,
      CAAT.Actor.prototype.ANCHOR_TOP,
      new CAAT.Interpolator().createExponentialInOutInterpolator(5,false)
    )
  
  __createCanvas = ->
    return new CAAT.Director().initialize(FNT.Game.WIDTH, FNT.Game.HEIGHT).setClear( false )
  
  exports.initGame = (font) ->
    console.log("Starting game")
    
    FNT.Game.FONT = font
    # uncomment to avoid decimal point coordinates.
    # Runs faster on anything but latest chrome.
    # CAAT.setCoordinateClamping(false)
  
    # uncomment to show CAAT's debug bar
    CAAT.DEBUG = 1
  
    director = __createCanvas()
    
    console.log("Created canvas")
  
    # Uncomment to make the game conform to window's size.
    #director.enableResizeEvents(CAAT.Director.prototype.RESIZE_PROPORTIONAL)
    
    __end_loading(director)
    
    console.log("Starting game")
  
    CAAT.loop(60);

