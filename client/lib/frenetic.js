// Generated by CoffeeScript 1.3.3
(function() {
  var createCanvas, namespace, __FNT__createLoadingScene, __end_loading, __frenetic_init,
    __slice = [].slice,
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  namespace = function(target, name, block) {
    var item, top, _i, _len, _ref, _ref1;
    if (arguments.length < 3) {
      _ref = [(typeof exports !== 'undefined' ? exports : window)].concat(__slice.call(arguments)), target = _ref[0], name = _ref[1], block = _ref[2];
    }
    top = target;
    _ref1 = name.split('.');
    for (_i = 0, _len = _ref1.length; _i < _len; _i++) {
      item = _ref1[_i];
      target = target[item] || (target[item] = {});
    }
    return block(target, top);
  };

  namespace("FNT", function(exports) {
    return exports.ObservableModel = (function() {

      function ObservableModel() {
        this.observers = [];
        this;

      }

      ObservableModel.prototype.addObserver = function(observer) {
        this.observers.push(observer);
        return this;
      };

      /*  
       # Notify observers of a model event.
       #   The Event is an object with fields:
       #     eventType | eventData
       # @param eventType : a string indicating the event type
       # @param data an object with event data. Each event type will have its own data structure.
      */


      ObservableModel.prototype.notifyObservers = function(eventType, eventData) {
        var observer, _i, _len, _ref, _results;
        _ref = this.observers;
        _results = [];
        for (_i = 0, _len = _ref.length; _i < _len; _i++) {
          observer = _ref[_i];
          _results.push(observer.handleEvent({
            type: eventType,
            data: eventData
          }));
        }
        return _results;
      };

      return ObservableModel;

    })();
  });

  namespace("FNT", function(exports) {
    return exports.GameModes = {
      quest: {
        name: "quest",
        levelData: [
          {
            spawnLocation: {
              x: 712,
              y: 200
            },
            ringData: [
              {
                x: 512,
                y: 512,
                diameter: 900
              }, {
                x: 100,
                y: 400,
                diameter: 190
              }, {
                x: 300,
                y: 600,
                diameter: 200
              }, {
                x: 512,
                y: 512,
                diameter: 100
              }, {
                x: 750,
                y: 800,
                diameter: 420
              }, {
                x: 850,
                y: 800,
                diameter: 200
              }
            ]
          }, {
            spawnLocation: {
              x: 512,
              y: 800
            },
            ringData: [
              {
                x: 512,
                y: 512,
                diameter: 1000
              }, {
                x: 100,
                y: 100,
                diameter: 100
              }
            ]
          }
        ]
      },
      race: {
        name: 'race'
      },
      pwn: {
        name: 'pwn'
      }
    };
  });

  namespace("FNT", function(exports) {
    exports.PlayerEvents = {
      SPAWN: "player_event_spawn",
      NEW_POSITION: "player_event_new_position"
    };
    return exports.PlayerModel = (function(_super) {

      __extends(PlayerModel, _super);

      function PlayerModel() {
        PlayerModel.__super__.constructor.call(this);
        this;

      }

      PlayerModel.prototype.radius = 12;

      PlayerModel.prototype.color = "#F00";

      PlayerModel.prototype.create = function() {
        this.position = new CAAT.Point(0, 0);
        this.diameter = this.radius * 2;
        return this;
      };

      PlayerModel.prototype.setPosition = function(pos) {
        this.position.set(pos.x, pos.y);
        return this.notifyObservers(FNT.PlayerEvents.NEW_POSITION, this);
      };

      /* Spawn in the given LevelModel at the given spawnLocation
      */


      PlayerModel.prototype.spawn = function(level, spawnLocation) {
        this.level = level;
        this.position.x = spawnLocation.x;
        this.position.y = spawnLocation.y;
        return this.notifyObservers(FNT.PlayerEvents.SPAWN, this);
      };

      return PlayerModel;

    })(FNT.ObservableModel);
  });

  namespace("FNT", function(exports) {
    return exports.RingModel = (function() {

      function RingModel() {
        this.position = new CAAT.Point(0, 0);
        this;

      }

      RingModel.prototype.diameter = 0;

      RingModel.prototype.create = function(ringData) {
        this.position = new CAAT.Point(ringData.x, ringData.y);
        this.diameter = ringData.diameter;
        this.radius = this.diameter / 2;
        return this;
      };

      return RingModel;

    })();
  });

  namespace("FNT", function(exports) {
    exports.LevelEvents = {
      LOAD: "level_event_load"
    };
    return exports.LevelModel = (function(_super) {

      __extends(LevelModel, _super);

      function LevelModel() {
        LevelModel.__super__.constructor.call(this);
        this.rings = [];
        this;

      }

      LevelModel.prototype.create = function() {
        return this;
      };

      LevelModel.prototype.load = function(ringData) {
        var ring, _i, _len;
        for (_i = 0, _len = ringData.length; _i < _len; _i++) {
          ring = ringData[_i];
          this.rings.push(new FNT.RingModel().create(ring));
        }
        return this.notifyObservers(FNT.LevelEvents.LOAD, this);
      };

      LevelModel.prototype.getRings = function() {
        return this.rings;
      };

      return LevelModel;

    })(FNT.ObservableModel);
  });

  namespace("FNT", function(exports) {
    exports.GameModelEvents = {
      UPDATE_STATUS: "update_status_event",
      CREATE_LEVEL: "create_level_event",
      ADDED_PLAYER: "added_player_event"
    };
    return exports.GameModel = (function(_super) {

      __extends(GameModel, _super);

      function GameModel() {
        GameModel.__super__.constructor.call(this);
        this;

      }

      GameModel.prototype.create = function() {
        this.initPhysics();
        this.createLevel();
        this.createPlayer();
        return this;
      };

      GameModel.prototype.step = function() {
        if (this.physicsController != null) {
          return this.physicsController.step();
        }
      };

      GameModel.prototype.createPlayer = function() {
        this.player = new FNT.PlayerModel().create();
        return this.notifyObservers(FNT.GameModelEvents.ADDED_PLAYER, this.player);
      };

      GameModel.prototype.createLevel = function() {
        this.level = new FNT.LevelModel().create();
        return this.notifyObservers(FNT.GameModelEvents.CREATE_LEVEL, this.level);
      };

      GameModel.prototype.startGame = function(gameMode) {
        this.gameMode = gameMode;
        return this.loadLevel(0);
      };

      GameModel.prototype.initPhysics = function() {
        this.physicsController = new FNT.PhysicsController().create(this);
        return this;
      };

      GameModel.prototype.loadLevel = function(levelIndex) {
        this.currentLevelData = FNT.GameModes.quest.levelData[levelIndex];
        this.level.load(this.currentLevelData.ringData);
        return this.onLevelLoaded();
      };

      GameModel.prototype.onLevelLoaded = function() {
        return this.player.spawn(this.level, this.currentLevelData.spawnLocation);
      };

      return GameModel;

    })(FNT.ObservableModel);
  });

  /*
   # Base class for circle-shaped Actors
  */


  namespace("FNT", function(exports) {
    return exports.CircleActor = (function(_super) {

      __extends(CircleActor, _super);

      function CircleActor() {
        CircleActor.__super__.constructor.call(this);
        this;

      }

      CircleActor.prototype.setPosition = function(point) {
        return this.centerAt(point.x, point.y);
      };

      CircleActor.prototype.setDiameter = function(diameter) {
        return this.setSize(diameter, diameter);
      };

      return CircleActor;

    })(CAAT.ShapeActor);
  });

  /*
   # Player Actor
  */


  namespace("FNT", function(exports) {
    return exports.PlayerActor = (function(_super) {

      __extends(PlayerActor, _super);

      function PlayerActor() {
        PlayerActor.__super__.constructor.call(this);
        this;

      }

      PlayerActor.prototype.create = function(scene, playerModel) {
        this.setVisible(false);
        this.setDiameter(playerModel.diameter);
        this.setPosition(playerModel.position);
        this.setStrokeStyle('#0');
        this.setFillStyle(playerModel.color);
        this.playerModel = playerModel;
        this.prepareSpawnBehavior();
        playerModel.addObserver(this);
        scene.addChild(this);
        return this;
      };

      PlayerActor.prototype.prepareSpawnBehavior = function() {
        this.spawnScaleBehavior = new CAAT.ScaleBehavior().setPingPong().setValues(1, 1.3, 1, 1.3, .50, .50).setDelayTime(0, 1000);
        return this.spawnAlphaBehavior = new CAAT.AlphaBehavior().setValues(0, 1).setDelayTime(0, 1000);
      };

      PlayerActor.prototype.handleEvent = function(event) {
        switch (event.type) {
          case FNT.PlayerEvents.SPAWN:
            return this.spawn();
          case FNT.PlayerEvents.NEW_POSITION:
            return this.setPosition(this.playerModel.position);
        }
      };

      PlayerActor.prototype.spawn = function() {
        this.setPosition(this.playerModel.position);
        this.addBehavior(this.spawnScaleBehavior);
        this.addBehavior(this.spawnAlphaBehavior);
        return this.setVisible(true);
      };

      return PlayerActor;

    })(FNT.CircleActor);
  });

  namespace("FNT", function(exports) {
    return exports.RingActor = (function(_super) {

      __extends(RingActor, _super);

      function RingActor() {
        RingActor.__super__.constructor.call(this);
        this;

      }

      RingActor.prototype.create = function(ring) {
        this.setDiameter(ring.diameter);
        this.setPosition(ring.position);
        this.setStrokeStyle('#0');
        this.setFillStyle('#AAA');
        this.setAlpha(0.5);
        this.ring = ring;
        return this;
      };

      return RingActor;

    })(FNT.CircleActor);
  });

  namespace("FNT", function(exports) {
    return exports.LevelContainer = (function(_super) {

      __extends(LevelContainer, _super);

      function LevelContainer() {
        LevelContainer.__super__.constructor.call(this);
        this.ringActors = [];
        this;

      }

      LevelContainer.prototype.create = function(scene, levelModel) {
        this.scene = scene;
        this.levelModel = levelModel;
        this.levelModel.addObserver(this);
        this.scene.addChild(this);
        return this;
      };

      LevelContainer.prototype.handleEvent = function(event) {
        if (event.type === FNT.LevelEvents.LOAD) {
          return this.loadLevel();
        }
      };

      LevelContainer.prototype.loadLevel = function() {
        var ringActor, ringModel, _i, _j, _len, _len1, _ref, _ref1, _results;
        _ref = this.levelModel.getRings();
        for (_i = 0, _len = _ref.length; _i < _len; _i++) {
          ringModel = _ref[_i];
          this._create(ringModel);
        }
        _ref1 = this.ringActors;
        _results = [];
        for (_j = 0, _len1 = _ref1.length; _j < _len1; _j++) {
          ringActor = _ref1[_j];
          _results.push(this._animate(ringActor));
        }
        return _results;
      };

      LevelContainer.prototype._create = function(ringModel) {
        var ringActor;
        ringActor = new FNT.RingActor().create(ringModel);
        ringActor.setVisible(false);
        this.ringActors.push(ringActor);
        return this.addChild(ringActor);
      };

      LevelContainer.prototype._animate = function(ringActor) {
        this._animateInUsingScale(ringActor, this.scene.time + Math.random() * 500, 1500, 0.1, 1);
        return ringActor.setVisible(true);
      };

      /*
           # Adds a CAAT.ScaleBehavior to the entity, used on animate in
      */


      LevelContainer.prototype._animateInUsingScale = function(actor, startTime, endTime, startScale, endScale) {
        var scaleBehavior;
        scaleBehavior = new CAAT.ScaleBehavior();
        scaleBehavior.anchor = CAAT.Actor.prototype.ANCHOR_CENTER;
        actor.scaleX = actor.scaleY = scaleBehavior.startScaleX = scaleBehavior.startScaleY = startScale;
        scaleBehavior.endScaleX = scaleBehavior.endScaleY = endScale;
        scaleBehavior.setFrameTime(startTime, startTime + endTime);
        scaleBehavior.setCycle(false);
        scaleBehavior.setInterpolator(new CAAT.Interpolator().createBounceOutInterpolator(false));
        return actor.addBehavior(scaleBehavior);
      };

      return LevelContainer;

    })(CAAT.ActorContainer);
  });

  namespace("FNT", function(exports) {
    return exports.BackgroundContainer = (function(_super) {

      __extends(BackgroundContainer, _super);

      function BackgroundContainer() {
        BackgroundContainer.__super__.constructor.call(this);
        this;

      }

      BackgroundContainer.prototype.create = function(scene, width, height) {
        this.setBounds(0, 0, width, height);
        this.setFillStyle("#555");
        scene.addChild(this);
        return this;
      };

      return BackgroundContainer;

    })(CAAT.ActorContainer);
  });

  /*
   # Game Scene Actor:
   #  Main entry point for all the Actors that constitute the scene.
   #  Responsible for creating the scene with the Director.
  */


  namespace("FNT", function(exports) {
    return exports.GameSceneActor = (function() {

      function GameSceneActor() {
        this;

      }

      /*
           # Creates the main game Scene.
           # @param director a CAAT.Director instance.
      */


      GameSceneActor.prototype.create = function(director) {
        var _this = this;
        this.director = director;
        this.gameModel = new FNT.GameModel().addObserver(this);
        this.directorScene = director.createScene();
        this.directorScene.activated = function() {
          return _this.gameModel.startGame(FNT.GameModes.quest);
        };
        this.directorScene.onRenderStart = function(deltaTime) {
          return _this.gameModel.step();
        };
        this.backgroundContainer = new FNT.BackgroundContainer().create(this.directorScene, director.width, director.height);
        this.gameModel.create();
        return this;
      };

      GameSceneActor.prototype.createLevel = function(levelModel) {
        return this.levelContainer = new FNT.LevelContainer().create(this.directorScene, levelModel).setSize(this.director.width, this.director.height).setLocation(0, 0);
      };

      GameSceneActor.prototype.createPlayer = function(player) {
        return this.playerActor = new FNT.PlayerActor().create(this.directorScene, player);
      };

      GameSceneActor.prototype.handleEvent = function(event) {
        switch (event.type) {
          case FNT.GameModelEvents.ADDED_PLAYER:
            return this.createPlayer(event.data);
          case FNT.GameModelEvents.CREATE_LEVEL:
            return this.createLevel(event.data);
          default:
            return console.log("UNKNOWN EVENT TYPE! " + event.type);
        }
      };

      return GameSceneActor;

    })();
  });

  /* Encapsulates the state of Keyboard input
  */


  namespace("FNT", function(exports) {
    return exports.Keyboard = (function() {

      function Keyboard() {
        this;

      }

      Keyboard.prototype.JUMP = false;

      Keyboard.prototype.LEFT = false;

      Keyboard.prototype.RIGHT = false;

      Keyboard.prototype.currentState = false;

      Keyboard.prototype.create = function(modeChangedCallback) {
        var _this = this;
        this.modeChangedCallback = modeChangedCallback;
        /*
               # Register a CAAT key listener function
        */

        CAAT.registerKeyListener(function(keyEvent) {
          return _this.checkInput(keyEvent);
        });
        return this;
      };

      Keyboard.prototype.getKeyState = function(keyEvent) {
        keyEvent.preventDefault();
        if (keyEvent.getAction() === 'down') {
          return true;
        } else {
          return false;
        }
      };

      Keyboard.prototype.checkInput = function(keyEvent) {
        var state;
        switch (keyEvent.getKeyCode()) {
          case CAAT.Keys.w:
            state = this.getKeyState(keyEvent);
            if (state !== this.currentState) {
              this.currentState = state;
              return this.modeChangedCallback(state);
            }
            break;
          case CAAT.Keys.UP:
            return this.JUMP = this.getKeyState(keyEvent);
          case CAAT.Keys.LEFT:
          case CAAT.Keys.a:
            return this.LEFT = this.getKeyState(keyEvent);
          case CAAT.Keys.RIGHT:
          case CAAT.Keys.d:
            return this.RIGHT = this.getKeyState(keyEvent);
        }
      };

      return Keyboard;

    })();
  });

  namespace("FNT", function(exports) {
    return exports.PhysicsConstants = {
      MOVE_SPEED: 200,
      JUMP_SPEED: -200
    };
  });

  /* CouplePosition Behaviour couples the position of an arbitrary entity to a particle
  */


  namespace("FNT", function(exports) {
    return exports.CouplePosition = (function(_super) {

      __extends(CouplePosition, _super);

      function CouplePosition(target) {
        this.target = target;
        CouplePosition.__super__.constructor.apply(this, arguments);
      }

      CouplePosition.prototype.apply = function(p, dt, index) {
        return this.target.setPosition(p.pos);
      };

      return CouplePosition;

    })(Behaviour);
  });

  /* This Behaviour handles Collisions with the FNT.LevelModel
  */


  namespace("FNT", function(exports) {
    return exports.LevelCollision = (function(_super) {

      __extends(LevelCollision, _super);

      function LevelCollision(levelModel, useMass, callback) {
        this.levelModel = levelModel;
        this.useMass = useMass != null ? useMass : true;
        this.callback = callback != null ? callback : null;
        this._delta = new Vector();
        LevelCollision.__super__.constructor.apply(this, arguments);
      }

      LevelCollision.prototype.setActive = function(isActive) {
        this.isActive = isActive;
      };

      LevelCollision.prototype.apply = function(p, dt, index) {
        var dist, inner_perimeter, outer_perimeter, overlap, ring, _i, _len, _ref, _results;
        if (!this.isActive) {
          return;
        }
        _ref = this.levelModel.getRings();
        _results = [];
        for (_i = 0, _len = _ref.length; _i < _len; _i++) {
          ring = _ref[_i];
          this._delta.copy(p.pos).sub(ring.position);
          dist = this._delta.mag();
          outer_perimeter = ring.radius + p.radius;
          inner_perimeter = ring.radius - p.radius;
          if ((inner_perimeter < dist && dist < outer_perimeter)) {
            if (dist > ring.radius) {
              overlap = outer_perimeter - dist;
            } else {
              overlap = inner_perimeter - dist;
            }
            p.pos.add(this._delta.norm().scale(overlap));
            _results.push(typeof this.callback === "function" ? this.callback(p, o, overlap) : void 0);
          } else {
            _results.push(void 0);
          }
        }
        return _results;
      };

      return LevelCollision;

    })(Behaviour);
  });

  /* This behaviour attaches the particle to the first Ring it encounters and 'glides' it around the Ring
  */


  namespace("FNT", function(exports) {
    return exports.RingRiding = (function(_super) {

      __extends(RingRiding, _super);

      function RingRiding(levelModel, useMass, callback) {
        this.levelModel = levelModel;
        this.useMass = useMass != null ? useMass : true;
        this.callback = callback != null ? callback : null;
        this._delta = new Vector();
        this._ring_to_p = new Vector();
        this._delta_pos = new Vector();
        this.OVERLAP = 4;
        RingRiding.__super__.constructor.apply(this, arguments);
        this;

      }

      RingRiding.prototype.setActive = function(isActive) {
        this.isActive = isActive;
        return this.ring = null;
      };

      RingRiding.prototype.apply = function(p, dt, index) {
        var beef, component_perpendicular_to_tangent, currentOverlap, dist, offset, old_dist, _ref, _ref1, _ref2;
        if (!this.isActive) {
          return;
        }
        if ((_ref = this.ring) == null) {
          this.ring = this.findAttachableRing(p);
        }
        if (!(this.ring != null)) {
          return;
        }
        dist = this.distanceBetween(p, this.ring);
        old_dist = new Vector();
        old_dist.copy(p.old).dist(this.ring.position);
        if ((old_dist < (_ref1 = this.ring.radius) && _ref1 < dist) || (dist < (_ref2 = this.ring.radius) && _ref2 < old_dist)) {
          beef = true;
          console.log("CROSSING OVER!");
        }
        if (dist < this.ring.radius) {
          currentOverlap = dist + p.radius - this.ring.radius;
          if (currentOverlap > 7) {
            console.log("Big overlap: " + currentOverlap + " " + beef);
          }
          offset = this.OVERLAP - currentOverlap;
          p.pos.add(this._delta.norm().scale(offset));
        } else {
          currentOverlap = this.ring.radius + p.radius - dist;
          if (currentOverlap > 7) {
            console.log("Big overlap: " + currentOverlap + " " + beef);
          }
          offset = currentOverlap - this.OVERLAP;
          p.pos.add(this._delta.norm().scale(offset));
        }
        this._ring_to_p.copy(p.pos).sub(this.ring.position).norm();
        this._delta_pos.copy(p.pos).sub(p.old.pos);
        component_perpendicular_to_tangent = Vector.project(this._ring_to_p, this._delta_pos);
        if (component_perpendicular_to_tangent.mag() > 2) {
          console.log("MAKING A BIG ADJUSTMENT");
        }
        return p.old.pos.add(component_perpendicular_to_tangent);
      };

      RingRiding.prototype.findAttachableRing = function(p) {
        var r, _i, _len, _ref;
        _ref = this.levelModel.getRings();
        for (_i = 0, _len = _ref.length; _i < _len; _i++) {
          r = _ref[_i];
          if (this.overlapsWithRing(p, r)) {
            p.acc.clear();
            this.ring = r;
            return this.ring;
          }
        }
        return null;
      };

      RingRiding.prototype.overlapsWithRing = function(p, ring) {
        var dist, inner_perimeter, outer_perimeter;
        dist = this.distanceBetween(p, ring);
        outer_perimeter = ring.radius + p.radius;
        inner_perimeter = ring.radius - p.radius;
        return (inner_perimeter < dist && dist < outer_perimeter);
      };

      RingRiding.prototype.distanceBetween = function(a, b) {
        this._delta.copy(a.pos).sub(b.position);
        return this._delta.mag();
      };

      return RingRiding;

    })(Behaviour);
  });

  /* The InputControlled Behaviour applies user input to the player's particle
  */


  namespace("FNT", function(exports) {
    return exports.InputControlled = (function(_super) {

      __extends(InputControlled, _super);

      function InputControlled() {
        InputControlled.__super__.constructor.apply(this, arguments);
        this;

      }

      InputControlled.prototype.create = function(keyboard) {
        this.keyboard = keyboard;
        return this;
      };

      InputControlled.prototype.apply = function(p, dt, index) {
        if (this.keyboard.JUMP) {
          p.acc.add(new Vector(0, FNT.PhysicsConstants.JUMP_SPEED));
        }
        if (this.keyboard.LEFT) {
          p.acc.add(new Vector(-1 * FNT.PhysicsConstants.MOVE_SPEED, 0));
        }
        if (this.keyboard.RIGHT) {
          return p.acc.add(new Vector(FNT.PhysicsConstants.MOVE_SPEED, 0));
        }
      };

      return InputControlled;

    })(Behaviour);
  });

  /* This class models a Frenetic Player's interaction with the physics system
  */


  namespace("FNT", function(exports) {
    return exports.PlayerParticle = (function(_super) {

      __extends(PlayerParticle, _super);

      function PlayerParticle() {
        PlayerParticle.__super__.constructor.call(this);
        this;

      }

      PlayerParticle.prototype.create = function(playerModel) {
        var _this = this;
        this.playerModel = playerModel;
        this.couplePosition = new FNT.CouplePosition(this.playerModel);
        this.keyboard = new FNT.Keyboard().create(function(inAlternateState) {
          return _this.onStateChanged(inAlternateState);
        });
        this.setRadius(this.playerModel.radius);
        this.inputControlled = new FNT.InputControlled().create(this.keyboard);
        this.playerModel.addObserver(this);
        return this;
      };

      PlayerParticle.prototype.onStateChanged = function(inAlternateState) {
        this.ringRiding.setActive(inAlternateState);
        return this.levelCollision.setActive(!inAlternateState);
      };

      PlayerParticle.prototype.handleEvent = function(event) {
        switch (event.type) {
          case FNT.PlayerEvents.SPAWN:
            return this.spawn();
        }
      };

      PlayerParticle.prototype.spawn = function() {
        this.moveTo(new Vector(this.playerModel.position.x, this.playerModel.position.y));
        this.levelCollision = new FNT.LevelCollision(this.playerModel.level);
        this.ringRiding = new FNT.RingRiding(this.playerModel.level);
        this.behaviours.push(this.ringRiding);
        this.behaviours.push(this.inputControlled);
        this.behaviours.push(this.levelCollision);
        this.behaviours.push(this.couplePosition);
        this.ringRiding.setActive(false);
        return this.levelCollision.setActive(true);
      };

      return PlayerParticle;

    })(Particle);
  });

  /* Controller responsible for physics
  */


  namespace("FNT", function(exports) {
    return exports.PhysicsController = (function() {

      function PhysicsController() {
        this;

      }

      PhysicsController.prototype.create = function(gameModel) {
        this.gameModel = gameModel;
        this.physics = new Physics(new Verlet());
        this.gravity = new ConstantForce(new Vector(0.0, 150.0));
        this.physics.behaviours.push(this.gravity);
        this.gameModel.addObserver(this);
        return this;
      };

      PhysicsController.prototype.step = function() {
        return this.physics.step();
      };

      PhysicsController.prototype.applyInput = function(inputState) {
        return this.input.state = inputState;
      };

      PhysicsController.prototype.handleEvent = function(event) {
        switch (event.type) {
          case FNT.GameModelEvents.CREATE_LEVEL:
            return this.levelModel = event.data;
          case FNT.GameModelEvents.ADDED_PLAYER:
            return this.initPlayerPhysics(event.data);
        }
      };

      PhysicsController.prototype.initPlayerPhysics = function(playerModel) {
        this.player = new FNT.PlayerParticle().create(playerModel);
        return this.physics.particles.push(this.player);
      };

      return PhysicsController;

    })();
  });

  /*
   # Main Entry Point
  */


  __FNT__createLoadingScene = function(director) {
    var ladingActor, ladingImg, oActor, oImg, scene;
    ladingImg = director.getImage('lading');
    oImg = director.getImage('rueda');
    scene = director.createScene();
    scene.addChild(new CAAT.Actor().setBackgroundImage(director.getImage('splash')));
    scene.addChild(ladingActor = new CAAT.Actor().setBackgroundImage(ladingImg).setLocation(director.width - ladingImg.width - 10, director.height - ladingImg.height - 30));
    scene.addChild(oActor = new CAAT.Actor().setBackgroundImage(oImg).setLocation(ladingActor.x + 20, ladingActor.y + 10).addBehavior(new CAAT.RotateBehavior().setValues(0, 2 * Math.PI).setFrameTime(0, 1000).setCycle(true)));
    scene.loadedImage = function(count, images) {
      if (count === images.length) {
        return __end_loading(director, images);
      }
    };
    return scene;
  };

  __end_loading = function(director, images) {
    var gameScene;
    director.emptyScenes();
    director.setImagesCache(images);
    gameScene = new FNT.GameSceneActor().create(director);
    return director.easeIn(0, CAAT.Scene.prototype.EASE_TRANSLATE, 1000, false, CAAT.Actor.prototype.ANCHOR_TOP, new CAAT.Interpolator().createExponentialInOutInterpolator(5, false));
  };

  createCanvas = function() {
    if (window.innerWidth > window.innerHeight) {
      return new CAAT.Director().initialize(1024, 1024).setClear(false);
    }
    alert("DOING SOMETHING UNEXPECTED!");
    return new CAAT.Director().initialize(500, 750).setClear(false);
  };

  __frenetic_init = function() {
    var director, prefix;
    CAAT.DEBUG = 1;
    director = createCanvas();
    prefix = typeof __RESOURCE_URL !== "undefined" && __RESOURCE_URL !== null ? __RESOURCE_URL : '';
    new CAAT.ImagePreloader().loadImages([
      {
        id: 'splash',
        url: prefix + 'splash/splash.jpg'
      }, {
        id: 'lading',
        url: prefix + 'splash/lading.png'
      }, {
        id: 'rueda',
        url: prefix + 'splash/rueda.png'
      }
    ], function(counter, images) {
      var loading_scene;
      if (counter === images.length) {
        director.setImagesCache(images);
        loading_scene = __FNT__createLoadingScene(director);
        return new CAAT.ImagePreloader().loadImages([], function(counter, images) {
          if (counter === images.length) {
            director.addAudio("music", prefix + "res/sound/music.mp3");
          }
          return loading_scene.loadedImage(counter, images);
        });
      }
    });
    return CAAT.loop(60);
  };

  window.addEventListener('load', __frenetic_init, false);

}).call(this);
