
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
      
    startTimer: (currentTime) ->
      @emptyBehaviorList()
      
      @alphaBehavior.setFrameTime( currentTime + @_startTime, @_duration)
      @addBehavior(@alphaBehavior)
      
    setTimingInfo: (start, duration) ->
      @setAlpha(0)
      @alphaBehavior = new CAAT.AlphaBehavior().
        setValues(0,1).
        setInterpolator(new CAAT.Interpolator().createExponentialOutInterpolator(6, true))
        
      @_startTime = start
      @_duration = duration
