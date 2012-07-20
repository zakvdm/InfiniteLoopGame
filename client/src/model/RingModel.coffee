
namespace "FNT", (exports) ->

  class exports.RingModel
    constructor: ->
      @position = new CAAT.Point(0, 0)
      @
      
    diameter:     0
  
    create: (ringData) ->
      @position = new CAAT.Point(ringData.x, ringData.y)
      @diameter = ringData.diameter
      
      @
        
