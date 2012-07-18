/**
 * See LICENSE file.
 *
 * Game model..
 */

// GAMEMODES
(function() {
    FNT.GameModes = {
        quest:  {
            arb:                true,
            name:               'quest',
            levelData: [
               {  // LEVEL 1
                   spawnLocation : {x: 512, y: 800},
                   ringData : [  
                                  {x: 512, y: 512, diameter: 900},
                                  {x: 100, y: 400, diameter: 190},
                                  {x: 300, y: 600, diameter: 200},
                                  {x: 512, y: 512, diameter: 100},
                                  {x: 700, y: 800, diameter: 200}],
               },
               {  // LEVEL 2
                   spawnLocation : {x: 512, y: 800},
                   ringData : [
                                  {x: 512, y: 512, diameter: 1000},
                                  {x: 100, y: 100, diameter: 100}],
               },
            ]
                        
        },
        race : {
            name:               'race'
        },
        pwn : {
            name:               'pwn'
        }
    }
})();

// EVENT SOURCES
(function() {
    FNT.EventSources = {
    	LEVEL:         "event_source_level",
    	GAME_MODEL:    "event_source_game_model"
    }
})();

// PLAYERS
(function() {

    FNT.Player = function() {
        this.position = new CAAT.Point(0, 0);

        return this;
    };

    FNT.Player.prototype = {

        diameter:        0,
        position:        null,
        color:           "#F00",

        create : function(x, y, diameter) {
            this.position = new CAAT.Point(x, y);
            this.diameter = diameter;
            
            return this;
        },
    };

})();

// RINGS
(function() {

    FNT.Ring = function() {
        this.position = new CAAT.Point(0, 0);

        return this;
    };

    FNT.Ring.prototype= {

        diameter:        0,
        position:      null,
        color:         null,

        create : function(x, y, diameter) {
            this.position = new CAAT.Point(x, y);
            this.diameter = diameter;
            
            return this;
        },
    };

})();

// LEVEL EVENTS
(function() {
    FNT.LevelEvents = {
    	LOAD:         "level_events_load"
    }
})();

// LEVEL
(function () {
    FNT.Level = function() {
        this.rings = []
        return this;
    };
    
    FNT.Level.prototype = {
        rings:        null,
        gameModel:    null,

        create : function( ringData, gameModel ) {
        	this.gameModel = gameModel;
        	
            var currentRing = null;
            for (var i = 0; i < ringData.length; i++) {
                currentRing = ringData[i];

                var ring = new FNT.Ring().create(currentRing.x, currentRing.y, currentRing.diameter);

                this.rings.push(ring);
            }
            
            this.gameModel.fireEvent(FNT.EventSources.LEVEL, FNT.LevelEvents.LOAD, this);
        },
        
        getRings : function () { return this.rings },
    };

})();

// GAME MODEL EVENTS
(function() {
    FNT.GameModelEvents = {
    	UPDATE_STATUS:         "game_model_events_update_status"
    }
})();

/* GAME MODEL */
(function() {

    FNT.GameModel= function() {
        this.eventListener= [];
        return this;
    };

    FNT.GameModel.prototype= {

        eventListener:      null,   // context listeners

        gameMode:           null,

        level:              null,
        player:             null,
        currentLevelIndex:  0,

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
            this.player = new FNT.Player().create()
            
            return this;
        },
        
        startGame : function(gameMode) {
            if (gameMode != this.gameMode ) {
                this.gameMode = gameMode;
            }
            
            this.setStatus( this.ST_STARTGAME );
            this.loadLevel(0);
            
            this.spawnPlayer();
        },

        loadLevel : function(levelIndex) {
            var ringData = FNT.GameModes.quest.levelData[levelIndex].ringData;
            this.level = new FNT.Level().create(ringData, this);

            this.setStatus( this.ST_INITIALIZING );
        },
        
        spawnPlayer : function() {
            
        },

        /**
         * Notify listeners of a gamemodel event
         * @param sSource event source object
         * @param sEvent an string indicating the event type
         * @param params an object with event parameters. Each event type will have its own parameter set.
         */
        fireEvent : function( sSource, sEvent, params ) {
            var i;
            for (i = 0; i < this.eventListener.length; i++) {
                this.eventListener[i].handleEvent( {
                    source: sSource,
                    event:  sEvent,
                    params: params
                });
            }
        },

        addEventListener : function( listener ) {
            this.eventListener.push(listener);
            return this;
        },
        
        setStatus : function( status ) {
            this.status= status;
            this.fireEvent( FNT.EventSources.GAME_MODEL, FNT.GameModelEvents.UPDATE_STATUS, this.status );
        },

        timeUp : function() {
            this.setStatus( this.ST_ENDGAME );
        },
    };
})();
