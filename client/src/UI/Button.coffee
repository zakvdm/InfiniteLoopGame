
namespace "FNT", (exports) ->

  class exports.ButtonFactory
    @build: (parent) ->
      return new FNT.Button().create(parent)
      
    @buildToggleButton: (parent) ->
      return new FNT.ToggleButton().create(parent)

  class exports.Button extends FNT.CircleActor
    constructor: ->
      super()
      @
      
    create : (parent) ->
      @setLineWidth(2)
      @setStrokeStyle('#0')
      @setFillStyle(FNT.Color.BUTTON)
      
      parent.addChild(@)
      
      @
    
    setText: (text) ->
      @textActor = FNT.TextFactory.build(@, text, 14)
      @textActor.setLocation((@width - @textActor.textWidth) / 2, @height + 1)
      @
    
    setOnClick: (@onClick) ->
      @

    mouseEnter: (mouseEvent) ->
      @setFillStyle(FNT.Color.BUTTON_DOWN)

    mouseExit : (mouseEvent) ->
      @setFillStyle(FNT.Color.BUTTON)
      
    mouseDown : (mouseEvent) ->
      @onClick?(mouseEvent)

  class exports.ToggleButton extends FNT.Button
    
    create: (parent) ->
      super(parent)
      
      @toggleTextOff = FNT.TextFactory.build(@, FNT.Strings.TOGGLE_OFF_STATE, 16)
      @toggleTextOn = FNT.TextFactory.build(@, FNT.Strings.TOGGLE_ON_STATE, 16)
      
      @setToggledState(false)
      
      @setOnClick(@toggleClickHandler)
      
    setDiameter: (diameter) ->
      super(diameter)
      offx = (@width - @toggleTextOff.textWidth) / 2
      onx = (@width - @toggleTextOn.textWidth) / 2
      y = (@height / 2) - (@toggleTextOff.textHeight / 2) # same for on and off
      @toggleTextOff.setLocation(offx, y)
      @toggleTextOn.setLocation(onx, y)
      @
      
    setToggledState: (state) ->
      @toggled = state
      
      @toggleTextOn.setVisible(state)
      @toggleTextOff.setVisible(not state)
      
      if @toggled
        @setFillStyle(FNT.Color.TOGGLE_ON)
      else
        @setFillStyle(FNT.Color.TOGGLE_OFF)
      
    toggleClickHandler: ->
      @setToggledState(not @toggled)
      @onToggle?(@toggled)
      
    setOnToggle: (@onToggle) ->
      @
      
    mouseEnter: (mouseEvent) ->
      # do nothing
    mouseExit: (mouseEvent) ->
      # do nothing
      
