
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
      
      for ring in levelData.ringData
        @rings.push new FNT.RingModel().create(ring)
      
    getRings: -> @rings
    
    getTexts: -> @texts
    
    resetAllRings: ->
      for ring in @rings
        ring.setOrbited(false)
    