/*
 * Player Actor
 */

(function() {
    FNT.PlayerActor = function() {
        FNT.PlayerActor.superclass.constructor.call(this);

        return this;
    };

    FNT.PlayerActor.prototype = {

        player:                null,
        spawnScaleBehaviour:   null,
        spawnAlphaBehaviour:   null,

        create : function( scene, player ) {
            this.setVisible(false);
            
            this.setDiameter(player.diameter);
            this.setPosition(player.position);
            
            this.setStrokeStyle('#0');
            this.setFillStyle(player.color);

            this.player = player;
            
            this.prepareSpawnBehavior();

            player.addObserver(this);
            
            scene.addChild(this);
            
            return this;
        },
        
        prepareSpawnBehavior : function() {
            this.spawnScaleBehavior = new CAAT.ScaleBehavior().
                     setPingPong().  // We want it to swell and then return to its actual size
                     setValues(1, 1.3, 1, 1.3, .50, .50).  // Scale to 1.3x normal size from centre
                     setDelayTime(0, 1000); // takes 1 seconds to scale. time measured from parent's zero time.
                     
            this.spawnAlphaBehavior = new CAAT.AlphaBehavior().
                     setValues(0, 1). // Fade it in
                     setDelayTime(0, 1000);  // Finish fading in before animation completes
        },
        
        handleEvent : function(event) {
            if ( event.type == FNT.PlayerEvents.SPAWN) {
                this.spawn();
            }
        },
        
        spawn : function() {
            this.setPosition(this.player.position);
            
            this.addBehavior(this.spawnScaleBehavior);
            this.addBehavior(this.spawnAlphaBehavior);
            
            this.setVisible(true);
        },

    };

    extend( FNT.PlayerActor, FNT.CircleActor);
})();

