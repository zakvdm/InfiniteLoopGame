namespace "FNT", (exports) ->
  
  exports.PhysicsConstants =
    # NORMAL MOVEMENT:
    MOVE_SPEED:              200
    JUMP_SPEED:             -200
    # AIR CONTROL:
    AIR_MOVE_SPEED:          60
    # ORBITTING:
    ORBIT_SPEED:             100
    ORBIT_OFFSET:            6 # Distance from 'perfect' orbit (should always be less than Player.radius if you want actual overlap!)
    ORBIT_CHANGE_THRESHOLD:  500 # If there is an acceleration towards the other orbit (inside to outside, or vice versa) of magnitude greater than this value, then the orbit with change

