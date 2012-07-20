# PLAYER EVENTS
PlayerEvents =
    SPAWN:    "player_event_spawn"

class PlayerModel extends FNT.ObservableModel  
  constructor: ->
    super()
    @
  
  # PROPERTIES:
  diameter:          25
  color:             "#F00"
  
  create: ->
    @position = new CAAT.Point(0, 0)
    @
    
  spawn: (spawnLocation) ->
    @position.x = spawnLocation.x
    @position.y = spawnLocation.y
    
    @notifyObservers(FNT.PlayerEvents.SPAWN, @)
  
    
namespace "FNT", (exports) ->
  exports.PlayerEvents = PlayerEvents
  exports.PlayerModel = PlayerModel
