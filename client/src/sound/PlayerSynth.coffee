
namespace "FNT", (exports) ->

  class exports.PlayerSynth extends AudioletGroup
  
    @NORMAL_FREQUENCY = 20
    @ORBIT_FREQUENCY = 50
    @MAXIMUM_SPEED = 6
    @GAIN_DELTA = 0.1
    @FREQUENCY_DELTA = 3
    @ORBIT_GAIN_FACTOR = 0.5
  
  
    constructor: (audiolet) ->
      ###
      super(audiolet, 0, 1) # 0 inputs, 1 output
      
      sine = new Sine(audiolet, frequency)
      modulator = new Saw(audiolet, 2 * frequency)
      modulatorMulAdd = new MulAdd(audiolet, frequency / 2,
                                        frequency)
      gain = new Gain(audiolet)
      envelope = new PercussiveEnvelope(audiolet, 1, 0.2, 0.5, ( -> audiolet.scheduler.addRelative(0, @.remove.bind(@))).bind(@))

      modulator.connect(modulatorMulAdd)
      modulatorMulAdd.connect(sine)
      envelope.connect(gain, 0, 1);
      sine.connect(gain)
      gain.connect(@outputs[0])
      
      ###
      
      # Additive synth - one oscillator at frequency, one at twice frequency
      super(audiolet, 0, 1) # 0 inputs, 1 outputs
      
      @FREQUENCY_MODULATION = 3
      
      whiteNoise = new WhiteNoise(audiolet)
      @whiteNoiseScaled = new Multiply(audiolet, @FREQUENCY_MODULATION)
      # Oscillate frequency between 20hz and 40hz every second
      sine = new Sine(@audiolet, 1) # 1hz LFO frequency
      @mulAdd = new Multiply(@audiolet, @FREQUENCY_MODULATION) # Scale -1 to 1 -> -FREQUENCY_MODULATION to FREQUENCY_MODULATION
      
      sine.connect(@mulAdd)
      whiteNoise.connect(@whiteNoiseScaled)

      modulator = new Add(audiolet)
      @mulAdd.connect(modulator, 0, 0)
      @whiteNoiseScaled.connect(modulator, 0, 1)
      
      @frequencyNode = new Add(audiolet, FNT.PlayerSynth.NORMAL_FREQUENCY)
      modulator.connect(@frequencyNode)
      
      frequencyMul = new Multiply(audiolet, 4)

      osc1 = new Sine(audiolet)
      osc2 = new Sine(audiolet)

      # Connect frequency parameter to oscillators' frequency inputs
      @frequencyNode.connect(osc1);
      @frequencyNode.connect(frequencyMul);
      frequencyMul.connect(osc2);
      
      out = new Add(audiolet)
      osc1.connect(out, 0, 0)
      osc2.connect(out, 0, 1)
      
      @gain = new Gain(audiolet)
      out.connect(@gain)

      @gain.connect(@outputs[0])
      
    setFrequencyModulation: (frequencyModulation) ->
      @FREQUENCY_MODULATION = frequencyModulation
      @mulAdd.value.setValue(frequencyModulation)
      @whiteNoiseScaled.value.setValue(frequencyModulation)
    
    update: (player) ->
      speed = Math.min(player.speed, FNT.PlayerSynth.MAXIMUM_SPEED)
      
      switch player.state.get()
        when FNT.PlayerStates.NORMAL
          @gainTarget = speed / FNT.PlayerSynth.MAXIMUM_SPEED
          @frequencyTarget = FNT.PlayerSynth.NORMAL_FREQUENCY + (speed * 2)
        when FNT.PlayerStates.ORBITING
          @gainTarget = (speed * FNT.PlayerSynth.ORBIT_GAIN_FACTOR) / (FNT.PlayerSynth.MAXIMUM_SPEED * 2)
          @frequencyTarget = FNT.PlayerSynth.ORBIT_FREQUENCY + speed
        else
          @gainTarget = 0
          @frequencyTarget = 0
          
      @_step()
      
    _step: ->
      if not @frequencyTarget? or not @gainTarget? then return
      
      currentFrequency = @frequencyNode.value.getValue()
      currentGain = @gain.gain.getValue()
      delta_frequency = 0
      delta_gain = 0
      
      if currentFrequency < @frequencyTarget
        delta_frequency = Math.min(@frequencyTarget - currentFrequency, FNT.PlayerSynth.FREQUENCY_DELTA)
      else
        delta_frequency = Math.max(@frequencyTarget - currentFrequency, -1 * FNT.PlayerSynth.FREQUENCY_DELTA)
      
      if currentGain < @gainTarget
        delta_gain = Math.min(@gainTarget - currentGain, FNT.PlayerSynth.GAIN_DELTA)
      else
        delta_gain = Math.max(@gainTarget - currentGain, -1 * FNT.PlayerSynth.GAIN_DELTA)
      
      @_setFrequency(currentFrequency + delta_frequency)
      @_setGain(currentGain + delta_gain)

    _setFrequency: (freq) ->
      @frequency
      @frequencyNode.value.setValue(freq)
      
    _setGain: (gain) ->
      @gain.gain.setValue(gain)
      

