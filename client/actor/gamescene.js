/*
 * Game Scene Actor:
 *  Main entry point for all the Actors that constitute the scene.
 *  Responsible for creating the scene with the Director.
 */

(function() {
    FNT.GameScene = function() {
        this.gameListener= [];
        return this;
    };

    FNT.GameScene.prototype= {

        gameModel:                  null,
        directorScene:              null,

        levelContainer:             null,
        backgroundContainer:        null,

        director:                   null,

        actorInitializationCount:   0,  // flag indicating how many actors have finished initializing.

        music:                      null,
        sound:                      null,

        gameListener:               null,

        /**
         * Creates the main game Scene.
         * @param director a CAAT.Director instance.
         */
        create : function(director) {
            var me = this;  // CLOSURE FOR 'directorScene.activated'
            
            this.director = director;

            // Create a game model and register for game events
            this.gameModel = new FNT.GameModel().create().addEventListener(this);

            // Create a scene, and start the game when the scene finishes initializing
            this.directorScene = director.createScene();
            this.directorScene.activated = function() {
                me.gameModel.startGame(FNT.GameModes.quest);
            };

            var dw = director.width;
            var dh = director.height;
            
            // CREATE THE BACKGROUND:
            this.backgroundContainer = new FNT.BackgroundContainer().create(this.directorScene, dw, dh);
            
            this.createLevel(dw,dh);

            ////////////////////////////////////////////////
            this.create_EndGame(director);
            this.create_EndLevel(director);
            ////////////////////////////////////////////////
            
            
            return this;
        },
        
        createLevel : function(width, height) {
            this.levelContainer = new FNT.LevelContainer().
                    create(this.directorScene, this.gameModel).
                    setSize(width, height).
                    setLocation(0, 0);
                    
            this.directorScene.addChild(this.levelContainer);
        },

        create_EndLevel : function( director ) {
            // HANDLE LEVEL COMPLETE HERE!
        },
        create_EndGame : function(director, go_to_menu_callback ) {
            // HANDLE END GAME HERE!
        },

        handleEvent : function( event ) {

            var me= this;

            if ( event.source == FNT.EventSources.GAME_MODEL ) {
                if ( event.event == FNT.GameModelEvents.UPDATE_STATUS ) {
                    if ( event.params == this.gameModel.ST_INITIALIZING ) {
                        //this.initializeActors();
                    } else if ( event.params == this.gameModel.ST_RUNNNING) {
                        //this.cancelTimer();
                        //this.enableTimer();

                    }
                }
            }
        },
        
        prepareSound : function() {
            try {
                this.sound.prepare();
                this.music.prepare();
            }
            catch(e) {

            }
        }

    };
})();
