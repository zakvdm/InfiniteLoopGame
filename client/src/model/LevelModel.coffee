
namespace "FNT", (exports) ->

  class exports.LevelFactory
    @build: (levelData) ->
      level = new FNT.LevelModel()
      
      level.load(levelData)
      
      return level
      
  # LEVEL MODEL
  class exports.LevelModel extends FNT.ObservableModel
    constructor: ->
      super()
      @
      
    load: (levelData) ->
      @spawnLocation = levelData.spawnLocation
      @exit = levelData.exit
      @texts = levelData.texts # All the little bits of text shown for this level (tutorials, level name, etc.)
      
      @rings = []
      
      
      @rings.push(FNT.RingModelFactory.build(ring)) for ring in levelData.ringData
        
      
    getRings: -> @rings
    
    getTexts: -> @texts
    
    setOrbited: (orbitedRing) ->
      for ring in @rings
        if ring == orbitedRing
          orbitedRing.state.set(FNT.RingStates.ORBITED)
        else
          ring.state.set(FNT.RingStates.PASSABLE)
      
    
    resetAllRings: ->
      for ring in @rings
        ring.state.set(FNT.RingStates.NORMAL)
    