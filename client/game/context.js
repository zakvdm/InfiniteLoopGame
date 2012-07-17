/**
 * See LICENSE file.
 *
 * Game model..
 */

// GAMEMODES
(function() {
    FNT.GameModes = {
        quest:  {
            arb:                true
            name:               'quest'
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

        context:       null,

        /**
         *
         * @param row
         * @param column
         * @param context the FNT.Context instance
         */
        initialize : function(x, y, radius, context) {

            this.position = new CAAT.Point(x, y);
            this.radius = radius;

            this.color = (Math.random() * context.getNumberColors())>>0;
            this.context = context;
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

        create : function( levelData, context ) {
            var ringData = null;
            for (var i = 0; i < levelData.length; i++) {
                ringData = levelData[i];

                var ring = new FNT.Ring();
                ring.initialize(ringData.x, ringData.y, ringData.color, context);

                this.rings.push(ring);
            }
        },
    };

})();

/* GAME MODEL */
(function() {

    FNT.Context= function() {
        this.eventListener= [];
        return this;
    };

    FNT.Context.prototype= {

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
        setGameMode : function(gameMode) {
            if (gameMode != this.gameMode ) {
                this.gameMode = gameMode;
            }

            this.initialize();
        },

        initialize : function() {
            this.setStatus( this.ST_STARTGAME );
            this.loadLevel(0);
            return this;
        },

        loadLevel : function(levelIndex) {
            this.level = new FNT.Level();
            this.level.create(levelData[levelIndex], this);

            this.fireEvent('context', 'levelchange', this.level);

            this.setStatus( this.ST_INITIALIZING );

            return this;
        },

        /**
         * Notify listeners of a context event
         * @param sSource event source object
         * @param sEvent an string indicating the event type
         * @param params an object with event parameters. Each event type will have its own parameter set.
         */
        fireEvent : function( sSource, sEvent, params ) {
            var i;
            for (i = 0; i < this.eventListener.length; i++) {
                this.eventListener[i].contextEvent( {
                    source: sSource,
                    event:  sEvent,
                    params: params
                });
            }
        },

        addContextListener : function( listener ) {
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
