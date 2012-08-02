

namespace "FNT", (exports) ->
  
  class exports.Game
    @WIDTH:      1280
    @HEIGHT:     800
    
    @MIDDLE:     new Vector(@WIDTH / 2, @HEIGHT / 2)
    
    @FONT:       "sans-serif" # This is the fallback font (a different font will be pre-loaded before the game starts (and this value will be changed))
