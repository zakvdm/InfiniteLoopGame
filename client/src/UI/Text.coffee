
namespace "FNT", (exports) ->

  class exports.TextFactory
    @build: (parent, text, size) ->
      return new FNT.Text().create(parent, text, size)

  class exports.Text extends CAAT.TextActor
    create: (parent, text, size) ->
      @setFont("#{size}px #{FNT.Game.FONT}")
      @setText(text)
      @setTextFillStyle(FNT.Color.FONT)
      @cacheAsBitmap()
      
      parent.addChild(@)
      
      @
