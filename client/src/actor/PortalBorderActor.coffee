
namespace "FNT", (exports) ->
  class exports.PortalBorderActor extends FNT.CircleActor
    constructor: ->
      super()
      @
      
    create: (diameter, position) ->
      @setDiameter(diameter)
      @setPosition(position)
  
      @setFillStyle('gold')
      @setAlpha(1)
  
      @
