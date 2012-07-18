/*
 * A Bunch of utility Actors which don't really fit anywhere
 */

(function() {

    FNT.BackgroundContainer = function() {
        FNT.BackgroundContainer.superclass.constructor.call(this);
        return this;
    };

    FNT.BackgroundContainer.prototype = {

        create : function(scene, width, height) {

            this.setBounds(0, 0, width, height);
            this.setFillStyle("#555");

            scene.addChild(this);

            return this;
        },
    };

    extend(FNT.BackgroundContainer, CAAT.ActorContainer);

})();

