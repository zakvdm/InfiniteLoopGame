
namespace "FNT", (exports) ->

  class exports.InfoPanelFactory
    @build: (scene) ->
      return new FNT.InfoPanel().create(scene)
      
  class exports.InfoPanel extends FNT.Panel
    constructor: ->
      @infoState = {} # Positions are top-left
      @infoState[FNT.PanelState.SHY] =      new CAAT.Point(FNT.Game.WIDTH, FNT.Game.HEIGHT)
      @infoState[FNT.PanelState.OUTGOING] = new CAAT.Point(FNT.Game.WIDTH - 350, FNT.Game.HEIGHT - 320)

      super()
      
      @
      
    create : (@scene) ->
      super(@scene)
      
      @setDiameter(300)
      
      @
      
    _getPositionForState: (state) ->
      return @infoState[state]
      
    _getInitialPosition: ->
      return new CAAT.Point(FNT.Game.WIDTH + 500, FNT.Game.HEIGHT + 500)
      
    _createText: ->
      @textActor = FNT.TextFactory.build(@, FNT.Game.NAME, 38)
      @textActor.setLocation(100, 100)
    