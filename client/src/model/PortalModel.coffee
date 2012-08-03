namespace "FNT", (exports) ->

  class exports.PortalModelFactory
    @build: (portalData) ->
      portalModel = new FNT.PortalModel().create(portalData)
      
      return portalModel

  # PORTAL MODEL
  class exports.PortalModel
      
    create: (portalData) ->
      @position = new CAAT.Point(portalData.x, portalData.y)
      @diameter = portalData.diameter
      @radius = @diameter / 2
      
      @type = portalData.type
      
      @
      
