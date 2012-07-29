###
 # Base class for circle-shaped Actors
###

namespace "FNT", (exports) ->

  class exports.CircleActor extends CAAT.ShapeActor
    constructor: ->
      super()
      @
      
    setPosition: (point) ->
      @centerAt(point.x, point.y)
      @
      
    setDiameter: (diameter) ->
      @setSize(diameter, diameter)
      @
