/*
 * Game Scene Actor:
 *  Main entry point for all the Actors that constitute the scene.
 *  Responsible for creating the scene with the Director.
 */

(function() {
    FNT.GameScene = function() {
        return this;
    };

    FNT.GameScene.prototype = {

        gameModel : null,
        directorScene : null,

        // ACTORS:
        levelContainer : null,
        playerActor : null,
        backgroundContainer : null,

        director : null,

        music : null,
        sound : null,

        /**
         * Creates the main game Scene.
         * @param director a CAAT.Director instance.
         */
        create : function(director) {
            var me = this;
            // CLOSURE FOR 'directorScene.activated'

            this.director = director;

            this.gameModel = new FNT.GameModel().addObserver(this);
            // Create a GameModel and register to observe changes to it

            // Create a scene, and start the game when the scene finishes initializing
            this.directorScene = director.createScene();
            this.directorScene.activated = function() {
                me.gameModel.startGame(FNT.GameModes.quest);
            };

            // CREATE THE BACKGROUND (We want to add this first because it should be at the back):
            this.backgroundContainer = new FNT.BackgroundContainer().create(this.directorScene, director.width, director.height);

            // This will create all of the entities contained in the GameModel, so we need to create the scene first so there's something to attach them to...
            this.gameModel.create();

            ////////////////////////////////////////////////
            this.create_EndGame(director);
            this.create_EndLevel(director);
            ////////////////////////////////////////////////

            return this;
        },

        createLevel : function(levelModel) {
            this.levelContainer = new FNT.LevelContainer().
                                  create(this.directorScene, levelModel).
                                  setSize(this.director.width, this.director.height).
                                  setLocation(0, 0);
        },

        createPlayer : function(player) {
            this.playerActor = new FNT.PlayerActor().
                               create(this.directorScene, player);
        },

        create_EndLevel : function(director) {
            // HANDLE LEVEL COMPLETE HERE!
        },
        create_EndGame : function(director, go_to_menu_callback) {
            // HANDLE END GAME HERE!
        },

        handleEvent : function(event) {
            if (event.type == FNT.GameModelEvents.ADDED_PLAYER) {
                this.createPlayer(event.data);
            } else if (event.type == FNT.GameModelEvents.CREATE_LEVEL) {
                this.createLevel(event.data);
            } else if (event.type == FNT.GameModelEvents.UPDATE_STATUS) {
                if (event.data == this.gameModel.ST_INITIALIZING) {
                    //this.initializeActors();
                } else if (event.data == this.gameModel.ST_RUNNNING) {
                    //this.cancelTimer();
                    //this.enableTimer();

                }
            }
        },

        prepareSound : function() {
            try {
                this.sound.prepare();
                this.music.prepare();
            } catch(e) {

            }
        }
    };
})();
