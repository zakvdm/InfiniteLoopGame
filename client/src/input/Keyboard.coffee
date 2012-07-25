### Encapsulates the state of Keyboard input ###

namespace "FNT", (exports) ->

  exports.KeyUp = "FNT_KEY_UP_EVENT"
  exports.KeyDown = "FNT_KEY_DOWN_EVENT"
  
  exports.Keys =
    ORBIT:           "FNT_KEYS_ORBIT"
    RESET:           "FNT_KEYS_RESET"
    NEXT_LEVEL:      "FNT_KEYS_NEXT_LEVEL"
    PREVIOUS_LEVEL:  "FNT_KEYS_PREVIOUS_LEVEL"
    
  class exports.Key
    constructor: ->
      @state = FNT.KeyUp
      @keyDownListeners = []
      @keyUpListeners = []
      @
      
    addListener: (keyEvent, callback) ->
      switch keyEvent
        when FNT.KeyUp
          @keyUpListeners.push(callback)
        when FNT.KeyDown
          @keyDownListeners.push(callback)
        else alert("WEIRD STUFF HAPPENING!")
      
    notifyListeners: ->
      listeners = if @state is FNT.KeyDown then @keyDownListeners else @keyUpListeners
      for callback in listeners
        callback()
      
    
  
  class exports.Keyboard
    constructor: ->
      @currentState = {}
      for key in FNT.Keys
        @currentState[key] = FNT.KeyUp
        
      @_keyMap = {}
      @_keyMap[CAAT.Keys.j]          = @ORBIT
      @_keyMap[CAAT.Keys.r]          = @RESET
      @_keyMap[CAAT.Keys.n]          = @NEXT_LEVEL
      @_keyMap[CAAT.Keys.p]          = @PREVIOUS_LEVEL
      
      @
      
    ORBIT:                 new FNT.Key()
    RESET:                 new FNT.Key()
    NEXT_LEVEL:            new FNT.Key()
    PREVIOUS_LEVEL:        new FNT.Key()
      
    UP:           false
    DOWN:         false
    LEFT:         false
    RIGHT:        false
    
    listeners:   {}
    
    currentState:
      ORBIT:             false
      RESET:             false
      NEXT_LEVEL:        false
      PREVIOUS_LEVEL:    false
      
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
      if keyEvent.getAction() is 'down' then FNT.KeyDown else FNT.KeyUp
    
    handleKeyEvent: (keyEvent) ->
      key = @keyMap[keyEvent.getKeyCode()]
      state = @getKeyState(keyEvent)
      if state != @currentState[key]
        @currentState[key] = state
        @notifyListeners(key, state)
      
    _handleKeyEvent: (keyEvent) ->
      key = @_keyMap[keyEvent.getKeyCode()]
      newState = @getKeyState(keyEvent)
      if newState != key.state
        key.state = newState
        key.notifyListeners()
      
      
    checkInput: (keyEvent) ->
      switch keyEvent.getKeyCode()
        when CAAT.Keys.UP, CAAT.Keys.w
          @UP = @getKeyState(keyEvent) == FNT.KeyDown
          
        when CAAT.Keys.DOWN, CAAT.Keys.s
          @DOWN = @getKeyState(keyEvent) == FNT.KeyDown
          
        when CAAT.Keys.LEFT, CAAT.Keys.a
          @LEFT = @getKeyState(keyEvent) == FNT.KeyDown
          
        when CAAT.Keys.RIGHT, CAAT.Keys.d
          @RIGHT = @getKeyState(keyEvent) == FNT.KeyDown
          
        #else @handleKeyEvent(keyEvent)
      
      if keyEvent.getKeyCode() of @_keyMap
        @_handleKeyEvent(keyEvent)
        
