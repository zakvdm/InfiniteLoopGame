### Encapsulates the state of Keyboard input ###

namespace "FNT", (exports) ->

  class exports.Keyboard
    constructor: () ->
      @
      
    JUMP:         false
    LEFT:         false
    RIGHT:        false
      
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
        when CAAT.Keys.v
          inAlternateState = @getKeyState(keyEvent) # We are in the alternate state as long as the key is pressed
          @modeChangedCallback(inAlternateState)
          
        when CAAT.Keys.UP, CAAT.Keys.w
          @JUMP = @getKeyState(keyEvent)
          
        when CAAT.Keys.LEFT, CAAT.Keys.a
          @LEFT = @getKeyState(keyEvent)
          
        when CAAT.Keys.RIGHT, CAAT.Keys.d
          @RIGHT = @getKeyState(keyEvent)
