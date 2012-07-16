
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
        initialize : function( ring ) {

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
        FNT.LevelActor.superclass.constructor.call(this);
        this.ringActors = [];
        return this;
    };

    FNT.LevelActor.prototype= {
        ringActors:    null,

        initialize : function() {
            return this;
        },

        contextEvent : function(event) {
            if ( event.source == 'context' ) {
                if ( event.event == 'levelchange') {
                    this.loadLevel(event.params);
                }
            }
        },
        
        loadLevel : function(levelData) {
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

    extend(FNT.LevelActor, CAAT.ActorContainer);
})();

(function() {
    FNT.GameScene = function() {
        this.gameListener= [];
        return this;
    };

    FNT.GameScene.prototype= {

        context:                    null,
        directorScene:              null,

        levelContainer:             null,

        timer:                      null,

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

            this.context = new FNT.Context().
                    create().
                    addContextListener(this);

            this.directorScene = director.createScene();
            this.directorScene.activated = function() {
                me.prepareSound();
            };

            var dw = director.width;
            var dh = director.height;

            this.levelContainer = new CAAT.ActorContainer().
                    create().
                    setSize(dw, dh).
                    setLocation(0, 0);

            this.directorScene.addChild(this.ringsContainer);

            this.levelContainer.loadLevel(this.context.getLevel());

            ////////////////////////////////////////////////
            this.create_EndGame(director);
            this.create_EndLevel(director);
            this.soundControls( director );
            ////////////////////////////////////////////////
            return this;
        },

        create_EndLevel : function( director ) {
            // HANDLE LEVEL COMPLETE HERE!
        },
        create_EndGame : function(director, go_to_menu_callback ) {
            // HANDLE END GAME HERE!
        },

        contextEvent : function( event ) {

            var me= this;

            if ( event.source=='context' ) {
                if ( event.event=='levelchange') {
                    //this.bricksContainer.enableEvents(true);
                } else if ( event.event=='status') {
                    if ( event.params==this.context.ST_INITIALIZING ) {
                        //this.initializeActors();
                    } else if ( event.params==this.context.ST_RUNNNING) {
                        //this.cancelTimer();
                        //this.enableTimer();

                    }
                }
            }
        },
        addGameListener : function(gameListener) {
            this.gameListener.push(gameListener);
        },
        fireEvent : function( type, data ) {
            for( var i=0, l= this.gameListener.length; i<l; i++ ) {
                this.gameListener[i].gameEvent(type, data);
            }
        },
        setDifficulty : function(level) {
            this.context.difficulty=level;
        },
        cancelTimer : function(){
            if ( this.timer!=null ) {
                this.timer.cancel();
            }
            this.timer= null;
        },
        enableTimer : function() {
            var me= this;
            
            this.timer= this.directorScene.createTimer(
                this.directorScene.time,
                this.context.turnTime,
                function timeout(sceneTime, time, timerTask) {
                    me.context.timeUp();
                },
                function tick(sceneTime, time, timerTask) {
                    me.chronoActor.tick(time, timerTask.duration);
                });

        },
        setGameMode : function(gameMode) {
            this.context.setGameMode(gameMode);
        },
        endLevel : function() {
            var level= this.context.level;
            if ( level>7 ) {
                level=7;
            }
            var image= this.director.getImage( 'msg'+level);
            if ( null!=image ) {
                this.endLevelMessage.setBackgroundImage( image, true );
                this.endLevelMessage.setLocation(
                        (this.endLevelMessage.parent.width-image.width)/2,
                        this.endLevelMessage.parent.height/2 - 25
                        );
            }
            this.showGameEvent( this.endLevelActor );
        },
        removeGameEvent : function( actor, callback ) {
            actor.enableEvents(false);
            this.uninitializeActors();

            var me= this;

            actor.emptyBehaviorList();
            actor.addBehavior(
                new CAAT.PathBehavior().
                    setFrameTime( actor.time, 2000 ).
                    setPath(
                        new CAAT.LinearPath().
                                setInitialPosition( actor.x, actor.y ).
                                setFinalPosition( actor.x, -actor.height )
                    ).
                    setInterpolator(
                        new CAAT.Interpolator().createExponentialInInterpolator(2,false)
                    ).
                    addListener(
                        {
                            behaviorExpired : function(behavior, time, actor) {
                                actor.setOutOfFrameTime();
                                callback();
                            }
                        }
                    )
            );
        },
        showGameEvent : function(actor) {
            // parar y eliminar cronometro.
            this.cancelTimer();

            // quitar contorl de mouse.
            this.bricksContainer.enableEvents(false);

            // mostrar endgameactor.

            var x= (this.directorScene.width - actor.width)/2;
            var y= (this.directorScene.height - actor.height)/2 - 100;

            var me_endGameActor= actor;
            actor.emptyBehaviorList().
                setFrameTime(this.directorScene.time, Number.MAX_VALUE).
                enableEvents(false).
                addBehavior(
                    new CAAT.PathBehavior().
                        setFrameTime( this.directorScene.time, 2000 ).
                        setPath(
                            new CAAT.LinearPath().
                                setInitialPosition( x, this.directorScene.height ).
                                setFinalPosition( x, y ) ).
                        setInterpolator(
                            new CAAT.Interpolator().createExponentialInOutInterpolator(3,false) ).
                        addListener( {
                            behaviorExpired : function(behavior, time, actor) {
                                me_endGameActor.enableEvents(true);

                                me_endGameActor.emptyBehaviorList();
                                me_endGameActor.addBehavior(
                                        new CAAT.PathBehavior().
                                            setFrameTime( time, 3000 ).
                                            setPath(
                                                new CAAT.LinearPath().
                                                        setInitialPosition( me_endGameActor.x, me_endGameActor.y ).
                                                        setFinalPosition(
                                                            me_endGameActor.x+(Math.random()<.5?1:-1)*(5+5*Math.random()),
                                                            me_endGameActor.y+(Math.random()<.5?1:-1)*(5+5*Math.random()) )
                                            ).
                                            addListener( {
                                                behaviorExpired : function(behavior, time, actor) {
                                                    behavior.setFrameTime( time, 3000 );
                                                    behavior.path.setFinalPosition(
                                                            me_endGameActor.x+(Math.random()<.5?1:-1)*(5+5*Math.random()),
                                                            me_endGameActor.y+(Math.random()<.5?1:-1)*(5+5*Math.random())
                                                            );
                                                },
                                                behaviorApplied : function(behavior, time, normalizedTime, actor, value) {
                                                }
                                            }).
                                            setInterpolator(
                                                new CAAT.Interpolator().createExponentialInOutInterpolator(3,true)
                                                )
                                        );

                            },
                            behaviorApplied : function(behavior, time, normalizedTime, actor, value) {
                            }
                        } )
                );
        },
        soundControls : function(director) {
            var ci= new CAAT.SpriteImage().initialize( director.getImage('sound'), 2,3 );
            var dw= director.width;
            var dh= director.height;

            var music= new CAAT.Actor().
                    setAsButton( ci.getRef(),0,1,0,0, function(button) {
                        director.audioManager.setMusicEnabled( !director.audioManager.isMusicEnabled() );
                        if ( director.audioManager.isMusicEnabled() ) {
                            button.setButtonImageIndex(0,1,0,0);
                        } else {
                            button.setButtonImageIndex(2,2,2,2);
                        }
                    }).
                    setBounds( dw-ci.singleWidth-2, 2, ci.singleWidth, ci.singleHeight );

            var sound= new CAAT.Actor().
                    setAsButton( ci.getRef(),3,4,3,3, function(button) {
                        director.audioManager.setSoundEffectsEnabled( !director.audioManager.isSoundEffectsEnabled() );
                        if ( director.audioManager.isSoundEffectsEnabled() ) {
                            button.setButtonImageIndex(3,4,3,3);
                        } else {
                            button.setButtonImageIndex(5,5,5,5);
                        }
                    });
            if ( director.width>director.height ) {
                sound.setBounds( dw-ci.singleWidth-2, 2+2+ci.singleHeight, ci.singleWidth, ci.singleHeight );
            } else {
                sound.setBounds( dw-ci.singleWidth*2-2, 2+2, ci.singleWidth, ci.singleHeight );
            }

            music.prepare= function() {
                if ( director.audioManager.isMusicEnabled() ) {
                    this.setButtonImageIndex(0,1,0,0);
                } else {
                    this.setButtonImageIndex(2,2,2,2);
                }
            }

            sound.prepare= function() {
                if ( director.audioManager.isSoundEffectsEnabled() ) {
                    this.setButtonImageIndex(3,4,3,3);
                } else {
                    this.setButtonImageIndex(5,5,5,5);
                }
            }

            this.directorScene.addChild(sound);
            this.directorScene.addChild(music);

            this.music= music;
            this.sound= sound;
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
