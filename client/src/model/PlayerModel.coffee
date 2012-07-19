# PLAYER EVENTS
PlayerEvents =
    SPAWN:    "player_event_spawn"

namespace "FNT", (exports) ->
  exports.PlayerEvents = PlayerEvents
  
###
class Player
  
  
class Animal
  constructor: (@name) ->

  move: (meters) ->
    alert @name + " moved #{meters}m."

class Snake extends Animal
  move: ->
    alert "Slithering..."
    super 5

class Horse extends Animal
  move: ->
    alert "Galloping..."
    super 45



# PLAYER MODEL
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
###