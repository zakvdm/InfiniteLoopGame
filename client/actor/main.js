/**
 * See LICENSE file.
 *
 * Entry point.
 */

function __CAAT__loadingScene(director) {

    var ladingImg =      director.getImage('lading');
    var ladingActor =    null;
    var oImg =           director.getImage('rueda');
    var oActor =         null;
    var scene =          director.createScene();

    scene.addChild(
            new CAAT.Actor().
                setBackgroundImage(
                    director.getImage('splash'))
            );

    scene.addChild(
            ladingActor = new CAAT.Actor().
                setBackgroundImage(ladingImg).
                setLocation(
                    director.width-ladingImg.width-10,
                    director.height-ladingImg.height-30 )
            );

    scene.addChild(
            oActor= new CAAT.Actor().
                setBackgroundImage(oImg).
                setLocation( ladingActor.x+20, ladingActor.y+10 ).
                addBehavior(
                    new CAAT.RotateBehavior().
                            setValues(0,2*Math.PI).
                            setFrameTime(0,1000).
                            setCycle(true)
                    )
            );

    scene.loadedImage = function(count, images) {
        if ( count == images.length ) {
            __end_loading(director, images);
        }
    };

    return scene;
}

function __end_loading(director, images) {

    director.emptyScenes();
    director.setImagesCache(images);

    var gameScene = new FNT.GameScene().create(director);
           
    // LOAD THE FIRST SCENE: 
    director.easeIn(
            0,
            CAAT.Scene.prototype.EASE_TRANSLATE,
            1000,
            false,
            CAAT.Actor.prototype.ANCHOR_TOP,
            new CAAT.Interpolator().createExponentialInOutInterpolator(5,false) );
}

function createCanvas() {
    var director;

    if ( window.innerWidth>window.innerHeight ) {
        director= new CAAT.Director().initialize(700,500).setClear( false );
    } else {
        director= new CAAT.Director().initialize(500,750).setClear(false);
    }

    return director;
}

function __frenetic_init()   {

    // uncomment to avoid decimal point coordinates.
    // Runs faster on anything but latest chrome.
    // CAAT.setCoordinateClamping(false);

    // uncomment to show CAAT's debug bar
    CAAT.DEBUG = 1;

    var director = createCanvas();

    // Uncomment to make the game conform to window's size.
    //director.enableResizeEvents(CAAT.Director.prototype.RESIZE_PROPORTIONAL);

    FNT.director = director;

    var prefix = typeof __RESOURCE_URL !== 'undefined' ? __RESOURCE_URL : '';

    new CAAT.ImagePreloader().loadImages(
        [
            {id:'splash',   url: prefix + 'splash/splash.jpg'},
            {id:'lading',   url: prefix + 'splash/lading.png'},
            {id:'rueda',    url: prefix + 'splash/rueda.png'}
        ],
        function( counter, images ) {

            if ( counter == images.length ) {
                director.setImagesCache(images);
                var scene_loading = __CAAT__loadingScene(director);

                new CAAT.ImagePreloader().loadImages(
                    [
                        {id:'target-number',    url: prefix + 'res/img/target.png'}
                    ],


                    function( counter, images ) {

                        if ( counter===images.length ) {
                            director.
                                addAudio("music",           prefix+"res/sound/music.mp3");
                        }

                        scene_loading.loadedImage(counter, images);

                    }
                );

            }
        }
    );

    CAAT.loop(60);
}

window.addEventListener('load', __frenetic_init, false);
