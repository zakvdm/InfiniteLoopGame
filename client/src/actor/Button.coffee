
namespace "FNT", (exports) ->

  exports.ButtonConstants =
    NORMAL_COLOR:        "grey"
    
  class exports.ButtonFactory
    @build: (parent, diameter, text, onClick) ->
      return new FNT.Button().create(parent, diameter, text, onClick)

  class exports.Button extends FNT.CircleActor
    constructor: ->
      super()
      @
      
    create : (parent, diameter, text, @onClick) ->
      @setDiameter(diameter)
      
      @setLineWidth(2)
      @setStrokeStyle('#0')
      @setFillStyle(FNT.Color.BUTTON)
      
      parent.addChild(@)
      
      @

    mouseEnter: (mouseEvent) ->
      @setFillStyle(FNT.Color.BUTTON_DOWN)

    mouseExit : (mouseEvent) ->
      @setFillStyle(FNT.Color.BUTTON)
      
    mouseDown : (mouseEvent) ->
      @onClick?(mouseEvent)

