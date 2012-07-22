namespace "FNT", (exports) ->

  # PLAYER EVENTS
  exports.PlayerEvents =
    SPAWN:           "player_event_spawn"
    NEW_POSITION:    "player_event_new_position"

  class exports.PlayerModel extends FNT.ObservableModel  
    constructor: ->
      super()
      @
    
    # PROPERTIES:
    radius:            12
    color:             "#F00"
    
    create: ->
      @position = new CAAT.Point(0, 0)
      @diameter = @radius * 2
      
      @
      
    setPosition: (pos) ->
      @position.set(pos.x, pos.y)
      @notifyObservers(FNT.PlayerEvents.NEW_POSITION, @)
    
    ### Spawn in the given LevelModel at the given spawnLocation ### 
    spawn: (@level, spawnLocation) ->
      @position.x = spawnLocation.x
      @position.y = spawnLocation.y
      
      @notifyObservers(FNT.PlayerEvents.SPAWN, @)
    
