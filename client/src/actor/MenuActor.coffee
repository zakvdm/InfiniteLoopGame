
namespace "FNT", (exports) ->

  class exports.MenuActorFactory
    @build: (scene, gameModel) ->
      return new FNT.MenuActor().create(scene, gameModel)
      
  MenuState =  # Positions are top-left
    SHY:      new CAAT.Point(-260, -260)
    OUTGOING: new CAAT.Point(-80, -80)

  class exports.MenuActor extends FNT.CircleActor
    constructor: ->
      super()
      
      @
      
    create : (@scene, @gameModel) ->
      @setDiameter(400)
      
      @setFillStyle(FNT.Color.BACKGROUND)
      @setLineWidth(2)
      @setStrokeStyle(FNT.Color.BLACK)
      
      @scene.addChild(@)
      
      @_createTitleText()
      
      @newGameButton = FNT.ButtonFactory.build(@, 50, "New Game", => @_newGameClicked())
      @newGameButton.setPosition(new CAAT.Point(250, 230))
      @aboutButton = FNT.ButtonFactory.build(@, 30, "Help!", => alert("HELP CLICKED!"))
      @aboutButton.setPosition(new CAAT.Point(340, 220))
      
      @scene.enableInputList(1)
      @scene.addActorToInputList( @, 0, 0 )
      @scene.addActorToInputList( @newGameButton, 0, 0 )
      @scene.addActorToInputList( @aboutButton, 0, 0 )

      @_prepareBehaviors()
      
      @_animateIn()
      
      @
     
      
    mouseDown: (mouseEvent) ->
      @_swapState()

    _prepareBehaviors: -> 
      @path = new CAAT.LinearPath()
      @pathBehavior = new CAAT.PathBehavior().
          setPath(@path).
          setInterpolator(new CAAT.Interpolator().createExponentialOutInterpolator(4, false))
          
      @addBehavior(@pathBehavior)
      
    _setState: (state, animationTime = FNT.Time.ONE_SECOND) ->
      @state = state
      
      @path.setInitialPosition(@x, @y)
      @path.setFinalPosition(@state.x, @state.y)
      @pathBehavior.setFrameTime(@scene.time, animationTime)
      
    _swapState: ->
      @_setState(if @state == MenuState.SHY then MenuState.OUTGOING else MenuState.SHY)
      
    _animateIn: ->
      @setPosition(new CAAT.Point(-500, -500))
      @_setState(MenuState.OUTGOING, FNT.Time.FOUR_SECONDS)
      
      
    _newGameClicked: ->
      @_setState(MenuState.SHY)
      @gameModel.startGame()
      
    _createTitleText: ->
      text = new CAAT.TextActor().
          setFont("#{FNT.Game.FONT_SIZE} #{FNT.Game.FONT}").
          setText("Infinite Loop").
          setTextFillStyle("black").
          cacheAsBitmap()
      text.setLocation(100, 100)
          
      @addChild(text)
    
      
