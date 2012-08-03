
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
      
      @_texts = levelData.texts # All the little bits of text shown for this level (tutorials, level name, etc.)
      
      @_rings = []
      @_rings.push(FNT.RingModelFactory.build(ring)) for ring in levelData.ringData
        
      @_portals = []
      if levelData.portals?
        @_portals.push(FNT.PortalModelFactory.build(portal)) for portal in levelData.portals
      
    getRings: -> @_rings
    getPortals: -> @_portals
    getTexts: -> @_texts
    
    setOrbited: (orbitedRing) ->
      for ring in @_rings
        if ring == orbitedRing
          orbitedRing.state.set(FNT.RingStates.ORBITED)
        else
          ring.state.set(FNT.RingStates.PASSABLE)
      
    
    resetAllRings: ->
      for ring in @_rings
        ring.state.set(FNT.RingStates.NORMAL)
    