/*
 * Base classes for Actors
 */

(function () {
    FNT.CircleActor = function() {
        FNT.CircleActor.superclass.constructor.call(this);
        
        return this;
    };
    
    FNT.CircleActor.prototype = {

        setPosition : function(x, y) {
            this.centerAt(x, y);
        },
        
        setDiameter : function(diameter) {
            this.setSize(diameter, diameter);
        },
    };
    
    extend(FNT.CircleActor, CAAT.ShapeActor);
})();
