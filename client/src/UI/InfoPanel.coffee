
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
      
      @setDiameter(280)
      
      @
      
    _getPositionForState: (state) ->
      return @infoState[state]
      
    _getInitialPosition: ->
      return new CAAT.Point(FNT.Game.WIDTH + 500, FNT.Game.HEIGHT + 500)
      
    _createText: ->
      left = 65
      top = 70
      gap = 10
      
      @controls = FNT.TextFactory.build(@, FNT.Strings.CONTROLS, 24).setLocation(left, top)
      left += gap
      top += @controls.textHeight + gap
      
      @leftAndRight = FNT.TextFactory.build(@, FNT.Strings.LEFT_AND_RIGHT, 18).setLocation(left, top)
      top += @leftAndRight.textHeight + gap
      
      @clamp = FNT.TextFactory.build(@, FNT.Strings.CLAMP, 16).setLocation(left, top)
      top += @clamp.textHeight + gap
      
      @retry = FNT.TextFactory.build(@, FNT.Strings.RETRY, 16).setLocation(left, top)
      
    