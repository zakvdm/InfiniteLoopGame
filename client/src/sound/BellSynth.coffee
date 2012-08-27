
namespace "FNT", (exports) ->

  class Bells
    @LITTLE_BELL_GAIN = 0.15
    @BIG_BELL_GAIN = 0.35
    @LITTLE_BELL_TIME = 0.5
    @BIG_BELL_TIME = 1.0
  
  class Bell extends AudioletGroup
    constructor: (audiolet, frequency, sustainLevel, time, gain) ->
      super(audiolet, 0, 1) # 0 inputs, 1 outputs
      
      sine = new Sine(audiolet, frequency)
      triangle = new Triangle(audiolet, frequency * 1.4)
      @envelope = new ADSREnvelope(audiolet,
                                    0, # Gate
                                    0.1, # Attack
                                    0.1, # Decay
                                    sustainLevel, # Sustain
                                    time) # Release
      
      modulator = new MulAdd(audiolet, frequency, frequency)
      triangle.connect(modulator)
      modulator.connect(sine) # sine's frequency = (output of triangle) * f + f
      
      out = new Gain(audiolet)
      sine.connect(out)
      @envelope.connect(out, 0, 1)
      
      out.gain.setValue(gain)
      out.connect(@outputs[0])
      
      @
      
    start: ->
      @envelope.gate.setValue(1)
    
    stop: ->
      @envelope.gate.setValue(0)

  class exports.BellSynth extends AudioletGroup
    
    constructor: (@audiolet, @levelSequence, @frequency = 440) ->
      super(audiolet, 0, 1) # 0 inputs, 1 outputs
      
      @levelSequence.addObserver(this)
      
      @ticks = 0
      @SUSTAIN_TIME = 20
      
      ###
       Now let's initialize the effects.
       Note that the regular oscillator is twice the frequency,
       and our modulating oscillator is 1.4x that.
      ###
      @_littleBell = new Bell(@audiolet, @frequency, Bells.LITTLE_BELL_GAIN, Bells.LITTLE_BELL_TIME, Bells.LITTLE_BELL_GAIN)
      @_bigBell = new Bell(@audiolet, @frequency * 2, Bells.BIG_BELL_GAIN, Bells.BIG_BELL_TIME, Bells.BIG_BELL_GAIN)
      
      out = new Add(@audiolet)
      @_littleBell.connect(out)
      @_bigBell.connect(out)
      
      reverb = new Reverb(@audiolet) #1.0, 0.2, 0.999
      
      out.connect(reverb)

      reverb.connect(@outputs[0])
      
    handleEvent: (event) ->
      switch event.data
        when FNT.LevelSequenceStates.PLAYING
          @_playBell(@_littleBell)
        when FNT.LevelSequenceStates.ADVANCING
          @_playBell(@_bigBell)
          
    update: ->
      @ticks += 1
      
      if @ticks >= @SUSTAIN_TIME
        @ticks = 0
        @_littleBell.stop()
        @_bigBell.stop()
        
    _playBell: (bell) ->
      @ticks = 0
      bell.start()
