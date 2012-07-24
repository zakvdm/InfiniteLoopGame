### Encapsulates the state of Keyboard input ###

namespace "FNT", (exports) ->

  exports.KeyUp = "FNT_KEY_UP_EVENT"
  exports.KeyDown = "FNT_KEY_DOWN_EVENT"
  
  exports.Keys =
    ORBIT:   "FNT_KEYS_ORBIT"
    RESET:   "FNT_KEYS_RESET"
  
  class exports.Keyboard
    constructor: () ->
      @
      
    UP:           false
    DOWN:         false
    LEFT:         false
    RIGHT:        false
    
    listeners:   {}
    
    currentState:
      ORBIT:
        false
      RESET:
        false
      
    create: ->
      ###
       # Register a CAAT key listener function
      ###
      CAAT.registerKeyListener((keyEvent) => @checkInput(keyEvent)) # we use the fat arrow to get access to @inputState
      
      @
      
    addListener: (key, keyEvent, callback) ->
      if not @listeners[key]?
        @listeners[key] = {}
        @listeners[key][FNT.KeyUp] = []
        @listeners[key][FNT.KeyDown] = []
          
      @listeners[key][keyEvent].push(callback)
     
    notifyListeners: (key, keyEvent) ->
      for callback in @listeners[key][keyEvent]
        callback()
      
    getKeyState: (keyEvent) ->
      keyEvent.preventDefault()
      if keyEvent.getAction() is 'down' then true else false
      
    toKeyEvent: (keyDownAction) ->
      if keyDownAction then FNT.KeyDown else FNT.KeyUp
          
    checkInput: (keyEvent) ->
      switch keyEvent.getKeyCode()
        when CAAT.Keys.j
          state = @getKeyState(keyEvent)
          if state != @currentState.ORBIT
            @currentState.ORBIT = state
            @notifyListeners(FNT.Keys.ORBIT, @toKeyEvent(state))
          
        when CAAT.Keys.r
          state = @getKeyState(keyEvent)
          if state != @currentState.RESET
            @currentState.RESET = state
            @notifyListeners(FNT.Keys.RESET, @toKeyEvent(state))
          
        when CAAT.Keys.UP, CAAT.Keys.w
          @UP = @getKeyState(keyEvent)
          
        when CAAT.Keys.DOWN, CAAT.Keys.s
          @DOWN = @getKeyState(keyEvent)
          
        when CAAT.Keys.LEFT, CAAT.Keys.a
          @LEFT = @getKeyState(keyEvent)
          
        when CAAT.Keys.RIGHT, CAAT.Keys.d
          @RIGHT = @getKeyState(keyEvent)
