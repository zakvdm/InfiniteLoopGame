
namespace "FNT", (exports) ->

  class exports.ButtonFactory
    @build: (parent) ->
      return new FNT.Button().create(parent)

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
    
    setPosition: (point) ->
      #@textActor.setLocation(point.x, point.y)
      super(point)
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

