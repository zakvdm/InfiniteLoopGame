
namespace "FNT", (exports) ->
  
  class Hummer extends AudioletGroup
    @NORMAL_FREQUENCY = 40
    @ORBIT_FREQUENCY = 50
    @MAXIMUM_SPEED = 6
    @GAIN_DELTA = 0.1
    @FREQUENCY_DELTA = 3
    @ORBIT_GAIN_FACTOR = 0.5
  
    constructor: (audiolet, gainLevel) ->
      # Additive synth - one oscillator at frequency, one at twice frequency
      super(audiolet, 0, 1) # 0 inputs, 1 outputs
      
      @FREQUENCY_MODULATION = 3
      @raw_speed = 0
      
      # Oscillate frequency between 20hz and 40hz every second
      sine = new Sine(@audiolet, 1) # 1hz LFO frequency
      @frequencyModulator = new Multiply(@audiolet, @FREQUENCY_MODULATION) # Scale -1 to 1 -> -FREQUENCY_MODULATION to FREQUENCY_MODULATION
      
      sine.connect(@frequencyModulator)

      @frequencyNode = new Add(audiolet, Hummer.NORMAL_FREQUENCY)
      @frequencyModulator.connect(@frequencyNode)
      
      frequencyMul = new Multiply(audiolet, 2)

      osc1 = new Sine(audiolet)
      osc2 = new Sine(audiolet)

      # Connect frequency parameter to oscillators' frequency inputs
      @frequencyNode.connect(osc1);
      @frequencyNode.connect(frequencyMul);
      frequencyMul.connect(osc2);
      
      out = new Add(audiolet)
      osc1.connect(out, 0, 0)
      osc2.connect(out, 0, 1)
      
      @gain = new Gain(audiolet, gainLevel)
      @envelope = new ADSREnvelope(audiolet,
                                    0, # Gate
                                    0.3, # Attack
                                    0.1, # Decay
                                    0.4, # Sustain
                                    0.3) # Release
      out.connect(@gain)
      @envelope.connect(@gain, 0, 1);

      @gain.connect(@outputs[0])
      
    start: ->
      @envelope.gate.setValue(1)
    stop: ->
      @envelope.gate.setValue(0)


  class exports.PlayerSynth extends AudioletGroup
    
    constructor: (audiolet) ->
      # Additive synth - one oscillator at frequency, one at twice frequency
      super(audiolet, 0, 1) # 0 inputs, 1 outputs
      
      @_orbitHummer = new Hummer(@audiolet)
      @_inputHummer = new Hummer(@audiolet)
      
      out = new Add(@audiolet)
      @_orbitHummer.connect(out)
      @_inputHummer.connect(out)
      
      reverb = new Reverb(@audiolet) #1.0, 0.2, 0.999
      
      out.connect(reverb)

      reverb.connect(@outputs[0])
      
      @lastPlayerState = FNT.PlayerStates.DEAD
      
    setFrequencyModulation: (frequencyModulation) ->
      @_orbitHummer.setFrequencyModulation(frequencyModulation)
      @_inputHummer.setFrequencyModulation(frequencyModulation)
    
    update: (player) ->
      if player.state.get() == @lastPlayerState then return
      
      @lastPlayerState = player.state.get()
      
      if @lastPlayerState == FNT.PlayerStates.ORBITING
        @_orbitHummer.start()
      else
        @_orbitHummer.stop()


  class exports.PlayerSynth2 extends AudioletGroup
  
    @NORMAL_FREQUENCY = 40
    @ORBIT_FREQUENCY = 50
    @MAXIMUM_SPEED = 6
    @GAIN_DELTA = 0.1
    @FREQUENCY_DELTA = 3
    @ORBIT_GAIN_FACTOR = 0.5
  
  
    constructor: (audiolet) ->
      # Additive synth - one oscillator at frequency, one at twice frequency
      super(audiolet, 0, 1) # 0 inputs, 1 outputs
      
      @FREQUENCY_MODULATION = 3
      @raw_speed = 0
      
      # Oscillate frequency between 20hz and 40hz every second
      sine = new Sine(@audiolet, 1) # 1hz LFO frequency
      @frequencyModulator = new Multiply(@audiolet, @FREQUENCY_MODULATION) # Scale -1 to 1 -> -FREQUENCY_MODULATION to FREQUENCY_MODULATION
      
      sine.connect(@frequencyModulator)

      @frequencyNode = new Add(audiolet, FNT.PlayerSynth.NORMAL_FREQUENCY)
      @frequencyModulator.connect(@frequencyNode)
      
      frequencyMul = new Multiply(audiolet, 2)

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
      @envelope = new ADSREnvelope(audiolet,
                                    0, # Gate
                                    0.3, # Attack
                                    0.1, # Decay
                                    0.4, # Sustain
                                    0.3) # Release
      out.connect(@gain)
      @envelope.connect(@gain, 0, 1);

      @gain.connect(@outputs[0])
      
      @lastPlayerState = FNT.PlayerStates.DEAD
      
      
    setFrequencyModulation: (frequencyModulation) ->
      @FREQUENCY_MODULATION = frequencyModulation
      @frequencyModulator.value.setValue(frequencyModulation)
    
    update: (player) ->
      if player.state.get() == @lastPlayerState then return
      
      @lastPlayerState = player.state.get()
      
      if @lastPlayerState == FNT.PlayerStates.ORBITING
        @envelope.gate.setValue(1)
      else
        @envelope.gate.setValue(0)
      
      
    update_old: (player) ->
      delta_speed = Math.abs(player.speed - @raw_speed)
      @raw_speed = player.speed
      
      speed = Math.min(@raw_speed, FNT.PlayerSynth.MAXIMUM_SPEED)
      
      @gainTarget = Math.min(0.2, delta_speed) * 5
      
      switch player.state.get()
        when FNT.PlayerStates.NORMAL
          #@gainTarget = speed / FNT.PlayerSynth.MAXIMUM_SPEED
          @frequencyTarget = FNT.PlayerSynth.NORMAL_FREQUENCY + (speed * 2)
        when FNT.PlayerStates.ORBITING
          #@gainTarget = (speed * FNT.PlayerSynth.ORBIT_GAIN_FACTOR) / (FNT.PlayerSynth.MAXIMUM_SPEED * 2)
          @gainTarget = @gainTarget * FNT.PlayerSynth.ORBIT_GAIN_FACTOR
          @frequencyTarget = FNT.PlayerSynth.ORBIT_FREQUENCY + speed
        else
          @gainTarget = 0
          @frequencyTarget = 0
          
      #@gainTarget = @gainTarget * gain_factor
          
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
      

