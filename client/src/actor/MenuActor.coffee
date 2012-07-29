
namespace "FNT", (exports) ->

  class exports.MenuActorFactory
    @build: (scene, gameModel) ->
      return new FNT.MenuActor().create(scene, gameModel)

  class exports.MenuActor extends FNT.CircleActor
    constructor: ->
      super()
      @
      
    create : (scene, @gameModel) ->
      @setDiameter(400)
      @setPosition(new CAAT.Point(100, 100))
      
      @setFillStyle(FNT.Color.BACKGROUND)
      @setLineWidth(2)
      @setStrokeStyle(FNT.Color.BLACK)
      
      
      scene.addChild(@)
      
      @_createTitleText()
      
      @newGameButton = FNT.ButtonFactory.build(@, 50, "New Game", => @_newGameClicked())
      @newGameButton.setPosition(new CAAT.Point(250, 230))
      @aboutButton = FNT.ButtonFactory.build(@, 30, "Help!", => alert("HELP CLICKED!"))
      @aboutButton.setPosition(new CAAT.Point(340, 220))
      
      scene.enableInputList(1)
      scene.addActorToInputList( @newGameButton, 0, 0 )
      scene.addActorToInputList( @aboutButton, 0, 0 )
      
      @
      
    _newGameClicked: ->
      @gameModel.startGame()
      
    _createTitleText: ->
      text = new CAAT.TextActor().
          setFont("40px sans-serif").
          setText("Infinite Loop").
          setTextFillStyle("black").
          cacheAsBitmap()
      text.setLocation(120, 120)
          
      @addChild(text)
    
      
