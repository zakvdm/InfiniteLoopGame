###
 # Main Entry Point
###

__FNT__createLoadingScene = (director) ->
  ladingImg = director.getImage('lading');
  oImg = director.getImage('rueda');
  scene = director.createScene();
  
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
          setFrameTime(0,1000).
          setCycle(true)
        )
  )

  scene.loadedImage = (count, images) ->
    __end_loading(director, images) if count == images.length

  scene # return the scene object
  
__end_loading = (director, images) ->
  director.emptyScenes()
  director.setImagesCache(images)

  gameScene = new FNT.GameSceneActor().create(director)
         
  # LOAD THE FIRST SCENE: 
  director.easeIn(
    0,
    CAAT.Scene.prototype.EASE_TRANSLATE,
    1000,
    false,
    CAAT.Actor.prototype.ANCHOR_TOP,
    new CAAT.Interpolator().createExponentialInOutInterpolator(5,false)
  )

createCanvas = ->
  return new CAAT.Director().initialize(1024,1024).setClear( false ) if window.innerWidth > window.innerHeight 
  
  alert("DOING SOMETHING UNEXPECTED!");
  return new CAAT.Director().initialize(500,750).setClear(false);

__frenetic_init = ->
  # uncomment to avoid decimal point coordinates.
  # Runs faster on anything but latest chrome.
  # CAAT.setCoordinateClamping(false)

  # uncomment to show CAAT's debug bar
  CAAT.DEBUG = 1

  director = createCanvas()

  # Uncomment to make the game conform to window's size.
  #director.enableResizeEvents(CAAT.Director.prototype.RESIZE_PROPORTIONAL)

  prefix = __RESOURCE_URL ? '' # TODO: What does this do? is it necessary?

  new CAAT.ImagePreloader().loadImages(
      [
          {id:'splash',   url: prefix + 'splash/splash.jpg'},
          {id:'lading',   url: prefix + 'splash/lading.png'},
          {id:'rueda',    url: prefix + 'splash/rueda.png'}
      ],
      (counter, images) ->
        if (counter == images.length)
          director.setImagesCache(images)
          loading_scene = __FNT__createLoadingScene(director)

          new CAAT.ImagePreloader().loadImages(
              [
                  #{id:'target-number',    url: prefix + 'res/img/target.png'}
              ],
              (counter, images) ->
                if (counter == images.length)
                  director.
                    addAudio("music", prefix + "res/sound/music.mp3")

                loading_scene.loadedImage(counter, images);
          )
  )

  CAAT.loop(60);

window.addEventListener('load', __frenetic_init, false)
