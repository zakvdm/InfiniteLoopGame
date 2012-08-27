
namespace "FNT", (exports) ->
  
  class exports.Color
    @scheme: "Paleta"
    
    @WHITE:        "white"
    @BLACK:        "black"
    @GRAY:         "#AAA"
    @LIGHT_GRAY:   "#CCC"
    @DARK_GRAY:    "#555"
    
    @FONT:         "#333"
    
    @_get: (index) ->
      return @[@scheme][index]
      
    @OddLots:
      1:           "#EDD4A8" # BEIGE
      2:           "#D4C472" # YELLOW
      3:           "#718F85" # GREEN
      4:           "#BA8A70" # TILE
      BACKGROUND:  "#5C565E" # PURPLE
      
    @Lake:
      1:           "#D6DB86" # LIME GREEN
      2:           "#B7CC9F" # OTHER GREEN
      3:           "#D1DBCC" # GREY
      4:           "#B8DEE3" # LIGHT BLUE
      BACKGROUND:  "#90C2C4" # BLUE
      
    @Paleta:
      1:           "#F93A34" # RED
      2:           "#F2F03F" # YELLOW
      3:           "#006699" # BLUE
      4:           "#DB952E" # ORANGE
      BACKGROUND:  "#E5E5E5" # GREY
      
    @PLAYER:        @_get(1)
    @BUTTON:        @_get(1)
    @BUTTON_DOWN:   @_get(2)
    @TOGGLE_ON:     @_get(2)
    @TOGGLE_OFF:    @GRAY
    @PORTAL:        @WHITE
    
    @MEDIUM:        @_get(3)
    @MEDIUM_DULL:   @_get(4)
    @BACKGROUND:    @_get("BACKGROUND")
    
