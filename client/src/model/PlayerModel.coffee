namespace "FNT", (exports) ->

  exports.PlayerConstants =
    RADIUS:  10
  
  # PLAYER EVENTS
  exports.PlayerEvents =
    STATE_CHANGE:    "player_event_state_change"
    SPAWN:           "player_event_spawn"
    NEW_POSITION:    "player_event_new_position"
    
  # PLAYER STATES
  exports.PlayerStates =
    NORMAL:           "player_state_normal"
    ORBITING:         "player_state_orbiting"
    DEAD:             "player_state_dead"
    
  class exports.PlayerFactory
    @build: ->
      player = new FNT.PlayerModel().create()
      
      # COMPONENTS:
      stateMachine = new FNT.StateMachine(player)
      player.state = stateMachine
      
      return player

  class exports.PlayerModel extends FNT.ObservableModel  
    constructor: ->
      super()
      @
    
    create: ->
      @position = new CAAT.Point(0, 0)
      @diameter = FNT.PlayerConstants.RADIUS * 2
      
      @
      
    setPosition: (pos) ->
      @position.set(pos.x, pos.y)
      @notifyObservers(FNT.PlayerEvents.NEW_POSITION, @)
      
    ### Spawn in the given LevelModel at the given spawnLocation ### 
    spawn: (spawnLocation) ->
      @position.x = spawnLocation.x
      @position.y = spawnLocation.y
      
      @notifyObservers(FNT.PlayerEvents.SPAWN, @)
      
      @state.set(FNT.PlayerStates.NORMAL)
    
