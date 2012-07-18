/*
 * Player Actor
 */

(function() {
    FNT.PlayerActor = function() {
        FNT.PlayerActor.superclass.constructor.call(this);

        return this;
    };

    FNT.PlayerActor.status= {
        REGULAR:    0,      // player can roll along inside and outside.
        SOLID:    1      // player can only roll along outside
    }

    FNT.PlayerActor.prototype = {

        status:         0,  // 0: regular state, 1: solid

        ring:           null,

        create : function( ring ) {
            this.setDiameter(ring.diameter);
            this.setPosition(ring.position.x, ring.position.y);
            
            this.setStrokeStyle('#0');
            this.setFillStyle('#AAA');
            this.setAlpha(0.5);

            this.ring = ring ;

            return this;
        },

        mouseEnter : function(mouseEvent) {

            if ( this.ring.selected ) {
                return;
            }

            //this.parent.setZOrder( this, Number.MAX_VALUE );
        },
        mouseExit : function(mouseEvent) { },
        mouseDown : function(mouseEvent) {
            this.ring.changeSelection();
        },
        toString : function() {
            return 'FNT.Player ' + this.player.getLocation() + ',' + this.player.getSize();
        },

    };

    extend( FNT.PlayerActor, FNT.CircleActor);
})();

