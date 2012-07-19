/*
 * Game Entities
 */

// PLAYER EVENTS
(function() {
    FNT.PlayerEvents = {
    	SPAWN:         "player_event_spawn"
    }
})();

// PLAYERS
(function() {

    FNT.Player = function() {
        FNT.Player.superclass.constructor.call(this);
        
        return this;
    };

    FNT.Player.prototype = {
        diameter:        25,
        position:        null,
        color:           "#F00",
        
        create : function() {
            this.position = new CAAT.Point(0, 0);
            
            return this;
        },

        spawn : function(spawnLocation) {
            this.position.x = spawnLocation.x;
            this.position.y = spawnLocation.y;
            
            this.notifyObservers(FNT.PlayerEvents.SPAWN, this);
        },
    };

    extend( FNT.Player, FNT.ObservableModel);
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
        LOAD:         "level_event_load"
    }
})();

// LEVEL
(function () {
    FNT.LevelModel = function() {
        FNT.LevelModel.superclass.constructor.call(this);
        
        this.rings = []
        return this;
    };
    
    FNT.LevelModel.prototype = {
        rings:        null,
        gameModel:    null,

        create : function() {
            return this;
        },
        
        load : function( ringData ) {
            var currentRing = null;
            for (var i = 0; i < ringData.length; i++) {
                currentRing = ringData[i];

                var ring = new FNT.Ring().create(currentRing.x, currentRing.y, currentRing.diameter);

                this.rings.push(ring);
            }
            
            this.notifyObservers(FNT.LevelEvents.LOAD, this);
        },
        
        getRings : function () { return this.rings },
    };

    extend( FNT.LevelModel, FNT.ObservableModel);
})();
