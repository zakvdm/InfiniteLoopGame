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
               [{x: 10, y: 10, radius: 100}, {x: 500, y: 200, radius: 500}], // LEVEL 1
               [{x: 10, y: 10, radius: 300}, {x: 500, y: 200, radius: 400}], // LEVEL 2
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

// RINGS
(function() {

    FNT.Ring = function() {
        this.position = new CAAT.Point(0, 0);

        return this;
    };

    FNT.Ring.prototype= {

        radius:        0,
        position:      null,
        color:         null,

        gamemodel:     null,

        /**
         *
         * @param row
         * @param column
         * @param gamemodel the FNT.GameModel instance
         */
        create : function(x, y, radius, gamemodel) {

            this.position = new CAAT.Point(x, y);
            this.radius = radius;

            this.color = (Math.random() * context.getNumberColors())>>0;
            this.gamemodel = gamemodel;
            
            return this;
        },
    };

})();

// LEVEL
(function () {
    FNT.Level = function() {
        this.rings = []
        return this;
    };

    FNT.Level.prototype = {
        rings:        null,

        create : function( levelData, gamemodel ) {
            var ringData = null;
            for (var i = 0; i < levelData.length; i++) {
                ringData = levelData[i];

                var ring = new FNT.Ring().create(ringData.x, ringData.y, ringData.color, gamemodel);

                this.rings.push(ring);
            }
        },
    };

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
            return this;
        },
        
        startGame : function(gameMode) {
            if (gameMode != this.gameMode ) {
                this.gameMode = gameMode;
            }
            
            this.setStatus( this.ST_STARTGAME );
            this.loadLevel(0);
        },

        loadLevel : function(levelIndex) {
            this.level = new FNT.Level();
            this.level.create(levelData[levelIndex], this);

            this.fireEvent(FNT.Level.LEVEL_EVENT, FNT.Level.LOAD_LEVEL, this.level);

            this.setStatus( this.ST_INITIALIZING );
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
            this.fireEvent( 'context', 'status', this.status );
        },

        timeUp : function() {
            this.setStatus( this.ST_ENDGAME );
        },
    };
})();
