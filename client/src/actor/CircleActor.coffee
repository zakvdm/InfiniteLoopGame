###
 # Base class for circle-shaped Actors
###

class CircleActor extends CAAT.ShapeActor
  constructor: ->
    super()
    @
    
  setPosition: (point) ->
    @centerAt(point.x, point.y)
    
  setDiameter: (diameter) ->
    @setSize(diameter, diameter)
    
namespace "FNT", (exports) ->
  exports.CircleActor = CircleActor

