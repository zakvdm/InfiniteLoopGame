namespace "FNT", (exports) ->
  
  exports.PhysicsConstants =
    # GLOBAL:
    GRAVITY:                     new Vector(0, 250.0)
    
    # NORMAL MOVEMENT:
    MOVE_SPEED:                  200
    JUMP_SPEED:                 -200
    
    # AIR CONTROL:
    AIR_MOVE_SPEED:              60
    
    # ORBITING:
    ORBIT_SPEED:                 280
    ORBIT_ATTACH_THRESHOLD:      4
    INITIAL_ORBIT_OFFSET:        FNT.PlayerConstants.RADIUS / 2
    MINIMUM_INNER_ORBIT_OFFSET:  FNT.PlayerConstants.RADIUS / 2
    MINIMUM_OUTER_ORBIT_OFFSET:  FNT.PlayerConstants.RADIUS / 2
    ORBIT_CHANGE_PER_SECOND:     FNT.PlayerConstants.RADIUS / 2
   
    # PORTAL:
    PORTAL_RADIUS:               40
