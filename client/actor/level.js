/*
 * Actors used by the Level
 */

(function() {
    FNT.RingActor = function() {
        FNT.RingActor.superclass.constructor.call(this);

        return this;
    };

    FNT.RingActor.status = {
        REGULAR : 0, // player can roll along inside and outside.
        SOLID : 1 // player can only roll along outside
    }

    FNT.RingActor.prototype = {
        status : 0, // 0: regular state, 1: solid
        ring : null,

        create : function(ring) {
            this.setDiameter(ring.diameter);
            this.setPosition(ring.position);

            this.setStrokeStyle('#0');
            this.setFillStyle('#AAA');
            this.setAlpha(0.5);

            this.ring = ring;

            return this;
        },

        mouseEnter : function(mouseEvent) {

            if (this.ring.selected) {
                return;
            }

            //this.parent.setZOrder( this, Number.MAX_VALUE );
        },
        mouseExit : function(mouseEvent) {
        },
        mouseDown : function(mouseEvent) {
            //this.ring.changeSelection();
        },
        toString : function() {
            return 'FNT.Ring ' + this.ring.getLocation() + ',' + this.ring.getSize();
        },
    };

    extend(FNT.RingActor, FNT.CircleActor);
})();

(function() {
    FNT.LevelContainer = function() {
        FNT.LevelContainer.superclass.constructor.call(this);
        this.ringActors = [];
        return this;
    };

    FNT.LevelContainer.prototype = {
        ringActors : null,
        scene : null,
        levelModel : null,

        create : function(scene, levelModel) {
            this.scene = scene;
            this.levelModel = levelModel;

            // Register for Level Events
            this.levelModel.addObserver(this);

            scene.addChild(this);

            return this;
        },

        handleEvent : function(event) {
            if (event.type == FNT.LevelEvents.LOAD) {
                this.loadLevel();
            }
        },

        /*
         * builds a visual representation of the supplied FNT.Level.
         */
        loadLevel : function() {
            var ring = null;
            var i;

            // CREATE ALL RINGS
            for ( i = 0; i < this.levelModel.getRings().length; i++) {
                ring = this.levelModel.getRings()[i];

                var ringActor = new FNT.RingActor().create(ring);
                ringActor.setVisible(false);

                // ADD TO THE SCENE
                this.ringActors.push(ringActor);
                this.addChild(ringActor);
                // Add it to the scene graph
            }

            // ANIMATE THEM ALL INTO PLACE
            for ( i = 0; i < this.levelModel.getRings().length; i++) {
                ringActor = this.ringActors[i];

                this.animateInUsingScale(ringActor, this.scene.time + Math.random() * 500, 1500, 0.1, 1);
                ringActor.setVisible(true);
            }
        },

        /**
         * Adds a CAAT.ScaleBehavior to the entity, used on animate in
         */
        animateInUsingScale : function(actor, startTime, endTime, startScale, endScale) {
            var scaleBehavior = new CAAT.ScaleBehavior();
            scaleBehavior.anchor = CAAT.Actor.prototype.ANCHOR_CENTER;
            actor.scaleX = actor.scaleY = scaleBehavior.startScaleX = scaleBehavior.startScaleY = startScale;
            // Fall from the 'sky' !
            scaleBehavior.endScaleX = scaleBehavior.endScaleY = endScale;
            scaleBehavior.setFrameTime(startTime, startTime + endTime);
            scaleBehavior.setCycle(false);
            scaleBehavior.setInterpolator(new CAAT.Interpolator().createBounceOutInterpolator(false));
            actor.addBehavior(scaleBehavior);

            return scaleBehavior;
        },
    };

    extend(FNT.LevelContainer, CAAT.ActorContainer);
})();
