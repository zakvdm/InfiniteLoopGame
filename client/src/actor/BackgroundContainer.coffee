
namespace "FNT", (exports) ->

  class exports.GameUIFactory

  class exports.BackgroundContainer extends CAAT.ActorContainer
    constructor: ->
      super()
      @
      
    create : (scene, width, height) ->
      @setBounds 0, 0, width, height
      @setFillStyle "#555"
      
      scene.addChild this
      
      @
