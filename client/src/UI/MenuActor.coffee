
namespace "FNT", (exports) ->

  class exports.MenuActorFactory
    @build: (scene, gameModel, menuPanel, infoPanel) ->
      return new FNT.MenuActor().create(scene, gameModel, menuPanel, infoPanel)
      
  class exports.MenuActor
    create : (@scene, @gameModel, @menuPanel, @infoPanel) ->
      
      @menuPanel.newGameButton.setOnClick(=> @_newGameClicked())
      @menuPanel.toggleSoundButton.setOnToggle((toggled) => @_toggleSound(toggled))
      @menuPanel.aboutButton.setOnClick(=> alert("HELP CLICKED!"))
      
      @menuPanel.mouseDown = (mouseEvent) => @_mouseDown(mouseEvent)
      @infoPanel.mouseDown = (mouseEvent) => @_mouseDown(mouseEvent)
      
      @scene.enableInputList(1)
      @scene.addActorToInputList( @menuPanel, 0, 0 )
      @scene.addActorToInputList( @infoPanel, 0, 0 )
      @scene.addActorToInputList( @menuPanel.newGameButton, 0, 0 )
      @scene.addActorToInputList( @menuPanel.toggleSoundButton, 0, 0 )
      @scene.addActorToInputList( @menuPanel.aboutButton, 0, 0 )

      @menuPanel.animateIn()
      @infoPanel.animateIn()
      
      @state = FNT.PanelState.OUTGOING
      
      @
      
    _mouseDown: (mouseEvent) ->
      @_swapState()

    _swapState: ->
      @state = if @state == FNT.PanelState.SHY then FNT.PanelState.OUTGOING else FNT.PanelState.SHY
      @menuPanel.setState(@state)
      @infoPanel.setState(@state)
      
    _newGameClicked: ->
      @state = FNT.PanelState.SHY
      @menuPanel.setState(@state)
      @infoPanel.setState(@state)
      
      @gameModel.startGame()
    
    _toggleSound: (soundOn) ->
      @gameModel.toggleSound(soundOn)
    
      
