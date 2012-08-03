
namespace "FNT", (exports) ->
  class exports.PortalActor extends FNT.CircleActor
    constructor: ->
      super()
      @
      
    create: (parent, diameter, position, color = FNT.Color.PORTAL) ->
      @setDiameter(diameter)
      @setPosition(position)
  
      @setFillStyle(color)
      @setAlpha(1)
  
      parent.addChild(@)
      
      @

