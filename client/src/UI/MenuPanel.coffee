
namespace "FNT", (exports) ->

  class exports.MenuPanelFactory
    @build: (scene) ->
      return new FNT.MenuPanel().create(scene)
      
  class exports.MenuPanel extends FNT.Panel
    constructor: ->
      @menuState = {}  # Positions are top-left
      @menuState[FNT.PanelState.SHY] =      new CAAT.Point(-470, -450)
      @menuState[FNT.PanelState.OUTGOING] = new CAAT.Point(-80, -80)

      super()
      
      @
      
    create : (@scene) ->
      super(@scene)
      
      @setDiameter(600)
      
      @newGameButton = FNT.ButtonFactory.build(@).
          setDiameter(80).
          setText(FNT.Strings.NEW_GAME).
          setPosition(new CAAT.Point(500, 270))
      @toggleSoundButton = FNT.ButtonFactory.buildToggleButton(@).
          setDiameter(35).
          setText(FNT.Strings.TOGGLE_SOUND).
          setPosition(new CAAT.Point(300, 520))
      @aboutButton = FNT.ButtonFactory.build(@).
          setDiameter(50).
          setText(FNT.Strings.ABOUT).
          setPosition(new CAAT.Point(450, 380))

      @
     
    _getPositionForState: (state) ->
      return @menuState[state]
      
    _getInitialPosition: ->
      return new CAAT.Point(-500, -500)
      
    _createText: ->
      @textActor = FNT.TextFactory.build(@, FNT.Strings.GAME_NAME, 52)
      @textActor.setLocation(100, 100)
      
      @toggle = FNT.TextFactory.build(@, FNT.Strings.CLICK_TO_TOGGLE, 12)
      @toggle.setLocation(482, 482).setRotation(- Math.PI / 3.8)
      
