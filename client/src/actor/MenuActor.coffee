
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
      
      @newGameButton = FNT.ButtonFactory.build(@).
          setDiameter(80).
          setText("New Game").
          setOnClick(=> @_newGameClicked()).
          setPosition(new CAAT.Point(300, 200))
      @aboutButton = FNT.ButtonFactory.build(@).
          setDiameter(30).
          setText("Help!").
          setOnClick(=> alert("HELP CLICKED!")).
          setPosition(new CAAT.Point(200, 280))
      
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
      @textActor = FNT.TextFactory.build(@, FNT.Game.NAME, 38)
      @textActor.setLocation(100, 100)
    
      
