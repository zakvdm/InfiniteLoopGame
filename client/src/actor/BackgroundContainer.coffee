
class BackgroundContainer extends CAAT.ActorContainer
  constructor: ->
    super()
    @
    
  create : (scene, width, height) ->
    @setBounds 0, 0, width, height
    @setFillStyle "#555"
    
    scene.addChild this
    
    @
    
namespace "FNT", (exports) ->
  exports.BackgroundContainer = BackgroundContainer
