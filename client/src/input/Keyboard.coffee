### Encapsulates the state of Keyboard input ###

namespace "FNT", (exports) ->

  class exports.Keyboard
    constructor: () ->
      @
      
    JUMP:         false
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
        when CAAT.Keys.w
          state = @getKeyState(keyEvent) # We are in the alternate state as long as the key is pressed
          if state != @currentState
            @currentState = state
            @modeChangedCallback(state)
          
        when CAAT.Keys.UP
          @JUMP = @getKeyState(keyEvent)
          
        when CAAT.Keys.LEFT, CAAT.Keys.a
          @LEFT = @getKeyState(keyEvent)
          
        when CAAT.Keys.RIGHT, CAAT.Keys.d
          @RIGHT = @getKeyState(keyEvent)
