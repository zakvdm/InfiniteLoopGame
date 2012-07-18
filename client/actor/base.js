/*
 * Base classes for Actors
 */

(function () {
    FNT.CircleActor = function() {
        FNT.CircleActor.superclass.constructor.call(this);
        
        return this;
    };
    
    FNT.CircleActor.prototype = {

        setPosition : function(point) {
            this.centerAt(point.x, point.y);
        },
        
        setDiameter : function(diameter) {
            this.setSize(diameter, diameter);
        },
    };
    
    extend(FNT.CircleActor, CAAT.ShapeActor);
})();
