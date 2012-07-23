### Encapsulates the state of Keyboard input ###

namespace "FNT", (exports) ->

  class exports.Keyboard
    constructor: () ->
      @
      
    UP:           false
    DOWN:         false
    LEFT:         false
    RIGHT:        false
    
    currentState: false
      
    create: (@modeChangedCallback) ->
      ###
       # Register a CAAT key listener function
      ###
      CAAT.registerKeyListener((keyEvent) => @checkInput(keyEvent)) # we use the fat arrow to get access to @inputState
      
      @
      
    getKeyState: (keyEvent) ->
      keyEvent.preventDefault()
      if keyEvent.getAction() is 'down' then true else false
          
    checkInput: (keyEvent) ->
      switch keyEvent.getKeyCode()
        when CAAT.Keys.j
          state = @getKeyState(keyEvent) # We are in the alternate state as long as the key is pressed
          if state != @currentState
            @currentState = state
            @modeChangedCallback(state)
          
        when CAAT.Keys.UP, CAAT.Keys.w
          @UP = @getKeyState(keyEvent)
          
        when CAAT.Keys.DOWN, CAAT.Keys.s
          @DOWN = @getKeyState(keyEvent)
          
        when CAAT.Keys.LEFT, CAAT.Keys.a
          @LEFT = @getKeyState(keyEvent)
          
        when CAAT.Keys.RIGHT, CAAT.Keys.d
          @RIGHT = @getKeyState(keyEvent)
