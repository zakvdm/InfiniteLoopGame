
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
      
      @rings = []
      
      for ring in levelData.ringData
        @rings.push new FNT.RingModel().create(ring)
      
    getRings: -> @rings
    
    resetAllRings: ->
      for ring in @rings
        ring.setOrbited(false)
    