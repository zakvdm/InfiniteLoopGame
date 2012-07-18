/**
 * Game model..
 */


/*
 * TODOS:
 *   1) Each of these model objects should probably be called xxxModel and should fire their own events? (instead of everything passing through the GameModel)
 */

(function() {
     FNT.ObservableModel = function() {
        this.observers = [];
        return this;
    };

    FNT.ObservableModel.prototype = {
        observers:      null,

        /**
         * Notify observers of a model event.
         *   The Event is an object with fields:
         *     eventType | eventData
         * @param eventType : a string indicating the event type
         * @param data an object with event data. Each event type will have its own data structure.
         */
        notifyObservers : function( eventType, eventData ) {
            for (var i = 0; i < this.observers.length; i++) {
                this.observers[i].handleEvent( {
                    type:  eventType,
                    data: eventData,
                });
            }
        },

        addObserver : function( observer ) {
            this.observers.push(observer);
            return this;
        },
    };
})();

// GAME MODEL EVENTS
(function() {
    FNT.GameModelEvents = {
    	UPDATE_STATUS:         "update_status_event",
    	CREATE_LEVEL:          "create_level_event",
    	ADDED_PLAYER:          "added_player_event",
    }
})();

/* GAME MODEL */
(function() {

    FNT.GameModel= function() {
        FNT.GameModel.superclass.constructor.call(this);
        
        return this;
    };

    FNT.GameModel.prototype= {

        gameMode:           null,

        level:              null,
        player:             null,
        currentLevelData:   null,

        ST_STARTGAME:       5,
        ST_INITIALIZING:    0,
        ST_START_LEVEL:     2,
        ST_RUNNNING:        1,
        ST_LEVEL_RESULT:    3,
        ST_ENDGAME:         4,

        /**
         * Called once on game startup.
         *
         * @return nothing.
         */
        create : function() {
            // NOTE: Creating Level before Player so that the Player ends up on top...
            this.createLevel();
            this.createPlayer();
            
            return this;
        },
        
        createPlayer : function() {
            this.player = new FNT.Player().create();
            
            this.notifyObservers( FNT.GameModelEvents.ADDED_PLAYER, this.player );
        },
        
        createLevel : function() {
            this.level = new FNT.LevelModel().create();
            
            this.notifyObservers( FNT.GameModelEvents.CREATE_LEVEL, this.level );
        },
        
        startGame : function(gameMode) {
            if (gameMode != this.gameMode ) {
                this.gameMode = gameMode;
            }
            
            this.setStatus(this.ST_STARTGAME);
            
            this.loadLevel(0);
            
        },

        loadLevel : function(levelIndex) {
            this.currentLevelData = FNT.GameModes.quest.levelData[levelIndex];
            this.level.load(this.currentLevelData.ringData);

            this.setStatus( this.ST_INITIALIZING );
            
            // TODO: This should be called later when the level is actually done loading (including animations)
            this.onLevelLoaded();
        },
        
        onLevelLoaded : function() {
            this.player.spawn(this.currentLevelData.spawnLocation);
        },

        setStatus : function( status ) {
            this.status= status;
            this.notifyObservers( FNT.GameModelEvents.UPDATE_STATUS, this.status );
        },

        timeUp : function() {
            this.setStatus( this.ST_ENDGAME );
        },
    };
    
    extend( FNT.GameModel, FNT.ObservableModel);
})();
