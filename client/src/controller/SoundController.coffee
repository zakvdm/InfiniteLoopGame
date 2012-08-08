
namespace "FNT", (exports) ->

  class exports.SoundController
 
    create: (@gameModel, @keyboard, @VOLUME = 1) ->
      @audiolet = new Audiolet()

      ###
      melodyA = new PSequence([262, 294, 330, 349])
      melodyB = new PSequence([349, 330, 349, 392])
      melodyC = new PSequence([440, 392, 349, 330])
      frequencyPattern = new PChoose([melodyA, melodyB, melodyC], Infinity)

      durationPattern = new PChoose([new PSequence([4, 1, 1, 2]), new PSequence([2, 2, 1, 3]), new PSequence([1, 1, 1, 1])], Infinity)

      this.audiolet.scheduler.play([frequencyPattern], durationPattern, ((frequency) ->
              playerSynth = new FNT.PlayerSynth(@audiolet, frequency)
              playerSynth.connect(@audiolet.output)).bind(@))
      
      ###
      @playerSynth = new FNT.PlayerSynth(@audiolet)
      @bellSynth = new FNT.BellSynth(@audiolet, @gameModel.levelSequence)
      
      out = new Add(@audiolet)
      @playerSynth.connect(out, 0, 0)
      @bellSynth.connect(out, 0, 1)
      
      @gain = new Gain(@audiolet)
      out.connect(@gain)

      @gain.connect(@audiolet.output)
  
      @
      
    setVolume: (vol) ->
      @VOLUME = vol
      @gain.gain.setValue(@VOLUME)
      

    step: ->
      @playerSynth.update(@gameModel.player)
      @bellSynth.update()
      
