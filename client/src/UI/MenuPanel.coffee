
namespace "FNT", (exports) ->

  class exports.MenuPanelFactory
    @build: (scene) ->
      return new FNT.MenuPanel().create(scene)
      
  class exports.MenuPanel extends FNT.Panel
    constructor: ->
      @menuState = {}  # Positions are top-left
      @menuState[FNT.PanelState.SHY] =      new CAAT.Point(-260, -260)
      @menuState[FNT.PanelState.OUTGOING] = new CAAT.Point(-80, -80)

      super()
      
      @
      
    create : (@scene) ->
      super(@scene)
      
      @setDiameter(400)
      
      @newGameButton = FNT.ButtonFactory.build(@).
          setDiameter(80).
          setText(FNT.Strings.NEW_GAME).
          setPosition(new CAAT.Point(300, 200))
      @aboutButton = FNT.ButtonFactory.build(@).
          setDiameter(30).
          setText(FNT.Strings.ABOUT).
          setPosition(new CAAT.Point(200, 280))

      @
     
    _getPositionForState: (state) ->
      return @menuState[state]
      
    _getInitialPosition: ->
      return new CAAT.Point(-500, -500)
      
    _createText: ->
      @textActor = FNT.TextFactory.build(@, FNT.Game.NAME, 38)
      @textActor.setLocation(100, 100)
      
