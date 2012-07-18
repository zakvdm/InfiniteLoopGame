
(function() {
    FNT.RingActor= function() {
        FNT.RingActor.superclass.constructor.call(this);

        return this;
    };

    FNT.RingActor.status= {
        REGULAR:    0,      // player can roll along inside and outside.
        SOLID:    1      // player can only roll along outside
    }

    FNT.RingActor.prototype = {

        status:         0,  // 0: regular state, 1: solid

        ring:           null,

        /**
         *
         * @param numberImage
         * @param brick a FNT.Brick instance.
         */
        create : function( ring ) {

            this.setSize(100,100);

            this.setBackgroundImage(numberImage.getRef(),true);

            this.ring = ring ;

            return this;
        },

        /**
         * Make initialize animation.
         * @param brickPosition
         */
        initializeForPlay: function( ringPosition, animationStartTime, animationDuration ) {

            var ringActor = this;

            ringActor.
                setLocation( ringPosition.x, ringPosition.y ).
                setScale( 1, 1 );

        },

        setStatus : function(st) {
            this.status = st;
            return this;
        },

        mouseEnter : function(mouseEvent) {

            if ( this.ring.selected ) {
                return;
            }

            this.parent.setZOrder( this, Number.MAX_VALUE );
        },
        mouseExit : function(mouseEvent) { },
        mouseDown : function(mouseEvent) {
            this.ring.changeSelection();
        },
        toString : function() {
            return 'FNT.Ring ' + this.ring.getLocation() + ',' + this.ring.getSize();
        },

        /**
         * brick selected.
         */
        setSelected : function() {

        },

        /**
         * game just started.
         */
        set: function() {
            this.status= FNT.RingActor.status.REGULAR;
            this.enableEvents(true);
        },

    };

    extend( FNT.RingActor, CAAT.Actor);
})();

(function() {
    FNT.LevelContainer = function() {
        FNT.LevelContainer.superclass.constructor.call(this);
        this.ringActors = [];
        return this;
    };

    FNT.LevelContainer.prototype= {
        ringActors:    null,
        
        create : function(gameModel) {
        	gameModel.addEventListener(this);
        	
        	return this;
        },


        handleEvent : function(event) {
            if ( event.source == FNT.Level.LEVEL_EVENT ) {
                if ( event.event == FNT.LEVEL.LOAD_LEVEL) {
                    this.loadLevel(event.params);
                }
            }
        },
        
        loadLevel : function(levelData) {
        	alert("Should be loading level!");
            // DO STUFF HERE!
            /*
            var snumber = this.level.toString();
            var i, number;
            var correction = this.font.singleWidth*.8;

            for( i = 0; i < snumber.length; i++ ) {
                number= parseInt(snumber.charAt(i));
                this.numbers[i].
                    setSpriteIndex(number).
                    setLocation(
                        (this.width - snumber.length*correction)/2 + i*correction, 24 ).
                    setVisible(true);
            }

            for( ;i<this.numbers.length; i++ ) {
                this.numbers[i].setVisible(false);
            }
            */
        }
    };

    extend(FNT.LevelContainer, CAAT.ActorContainer);
})();

(function() {
    FNT.GameScene = function() {
        this.gameListener= [];
        return this;
    };

    FNT.GameScene.prototype= {

        gameModel:                  null,
        directorScene:              null,

        levelContainer:             null,

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

            var me = this;
            var i,j;

            this.director = director;

            // Create a game model and register for game events
            this.gameModel = new FNT.GameModel().create().addEventListener(this);

            this.directorScene = director.createScene();
            this.directorScene.activated = function() {
                //me.prepareSound();
            };

            var dw = director.width;
            var dh = director.height;
            
            this.createLevel(dw,dh);

            ////////////////////////////////////////////////
            this.create_EndGame(director);
            this.create_EndLevel(director);
            this.soundControls( director );
            ////////////////////////////////////////////////
            
            this.gameModel.startGame(FNT.GameModes.quest);
            
            return this;
        },
        
        createLevel : function(width, height) {
            this.levelContainer = new CAAT.LevelContainer().
                    create(this.gameModel).
                    setSize(width, height).
                    setLocation(0, 0);
        },

        create_EndLevel : function( director ) {
            // HANDLE LEVEL COMPLETE HERE!
        },
        create_EndGame : function(director, go_to_menu_callback ) {
            // HANDLE END GAME HERE!
        },

        handleEvent : function( event ) {

            var me= this;

            if ( event.source == FNT.GameModel.GAME_EVENT ) {
                if ( event.event=='levelchange') {
                    //this.bricksContainer.enableEvents(true);
                } else if ( event.event=='status') {
                    if ( event.params==this.gameModel.ST_INITIALIZING ) {
                        //this.initializeActors();
                    } else if ( event.params==this.gameModel.ST_RUNNNING) {
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
