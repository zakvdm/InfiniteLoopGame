
namespace "FNT", (exports) ->

  # RING STATES
  exports.RingStates =
    NORMAL:           "ring_state_normal"
    ORBITED:          "ring_state_orbited"
    PASSABLE:         "ring_state_passable"
    
  class exports.RingModelFactory
    @build: (ringData) ->
      ringModel = new FNT.RingModel().create(ringData)
      
      # COMPONENTS:
      stateMachine = new FNT.StateMachine(ringModel)
      ringModel.state = stateMachine
      
      return ringModel

  # LEVEL MODEL
  class exports.RingModel extends FNT.ObservableModel
    constructor: ->
      @position = new CAAT.Point(0, 0)
      super()
      @
      
    create: (ringData) ->
      @position = new CAAT.Point(ringData.x, ringData.y)
      @diameter = ringData.diameter
      @radius = @diameter / 2
      
      @
