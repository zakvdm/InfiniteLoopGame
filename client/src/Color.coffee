
namespace "FNT", (exports) ->
  
  class exports.Color
    @scheme: "Paleta"
    
    @_get: (index) ->
      return @[@scheme][index]
      
    @OddLots:
      BUTTON:  "#EDD4A8" # BEIGE
      BUTTON_DOWN:  "#D4C472" # YELLOW
      BACKGROUND:  "#5C565E" # PURPLE
      3:  "#718F85" # GREEN
      4:  "#BA8A70" # TILE
      
    @Lake:
      BUTTON:  "#D6DB86" # LIME GREEN
      BUTTON_DOWN:  "#B7CC9F" # OTHER GREEN
      BACKGROUND:  "#90C2C4" # BLUE
      3:  "#D1DBCC" # GREY
      4:  "#B8DEE3" # LIGHT BLUE
      
    @Paleta:
      3:       "#006699" # BLUE
      4:            "#DB952E" # ORANGE
      BUTTON_DOWN:  "#F2F03F" # YELLOW
      BUTTON:            "#F93A34" # RED
      BACKGROUND:            "#E5E5E5" # GREY
      
    @BUTTON:        @_get("BUTTON")
    @BUTTON_DOWN:   @_get("BUTTON_DOWN")
    @MEDIUM:        @_get(3)
    @MEDIUM_DULL:   @_get(4)
    @BACKGROUND:    @_get("BACKGROUND")
    
    @BLACK:        "black"
    @FONT:         "#444"
