
namespace "FNT", (exports) ->
  
  class Hummer extends AudioletGroup
    constructor: (audiolet, frequency = 40) ->
      # Additive synth - one oscillator at frequency, one at twice frequency
      super(audiolet, 0, 1) # 0 inputs, 1 outputs
      
      @FREQUENCY_MODULATION = 3
      @raw_speed = 0
      
      # Oscillate frequency between 20hz and 40hz every second
      sine = new Sine(@audiolet, 1) # 1hz LFO frequency
      @frequencyModulator = new Multiply(@audiolet, @FREQUENCY_MODULATION) # Scale -1 to 1 -> -FREQUENCY_MODULATION to FREQUENCY_MODULATION
      
      sine.connect(@frequencyModulator)

      @frequencyNode = new Add(audiolet, frequency)
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
      
      @stop()
      
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
      
    update: (player) ->
      if player.state.get() == @lastPlayerState then return
      
      @lastPlayerState = player.state.get()
      
      if @lastPlayerState == FNT.PlayerStates.ORBITING
        @_orbitHummer.start()
      else
        @_orbitHummer.stop()

