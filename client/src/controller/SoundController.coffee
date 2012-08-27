
namespace "FNT", (exports) ->

  class exports.SoundController
 
    create: (@gameModel, @keyboard, @VOLUME = 1) ->
      @gameModel.addObserver(this)
      
      @soundInitialized = false
      
      @
      
    initializeSound: ->
      @audiolet = new Audiolet()

      @playerSynth = new FNT.PlayerSynth(@audiolet)
      @bellSynth = new FNT.BellSynth(@audiolet, @gameModel.levelSequence)
      
      out = new Add(@audiolet)
      @playerSynth.connect(out, 0, 0)
      @bellSynth.connect(out, 0, 1)
      
      @gain = new Gain(@audiolet)
      out.connect(@gain)

      @gain.connect(@audiolet.output)
  
      @soundInitialized = true
      
      @
      
    toggleSound: (soundOn) ->
      if soundOn
        if @soundInitialized
          @audiolet.output.device.play()
        else
          @initializeSound()
      else
        @audiolet.output.device.pause()
        
      
    handleEvent: (event) ->
      switch event.type
        when FNT.GameEvents.TOGGLE_SOUND
          @toggleSound(event.data)
      
    setVolume: (vol) ->
      @VOLUME = vol
      @gain.gain.setValue(@VOLUME)
      

    step: ->
      @playerSynth.update(@gameModel.player)
      @bellSynth.update()
      
