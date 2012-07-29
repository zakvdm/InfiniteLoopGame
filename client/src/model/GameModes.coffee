
namespace "FNT", (exports) ->
  
  exports.GameModes =
      # QUEST MODE
      quest:
        name:   "quest"
        levelData: [
           {  # LEVEL 0
               spawnLocation : {x: 500, y: 500},
               exit: {x: 300, y: 800},
               ringData : [
                            {x: 500, y: 500, diameter: 1000},],
           },
           {  # LEVEL 1
               spawnLocation : {x: 512, y: 800},
               exit: {x: 300, y: 300},
               ringData : [
                            {x: 500, y: 500, diameter: 1000},
                            {x: 500, y: 500, diameter: 300},
                            {x: 150, y: 150, diameter: 100}],
           },
           {  # LEVEL 2
               spawnLocation : {x: 80, y: 200},
               exit: {x: 950, y: 800},
               ringData : [  
                            {x: 100, y: 800, diameter: 150}
                            {x: 600, y: 800, diameter: 150}],
           },
           {  # LEVEL 3
               spawnLocation :    {x: 312, y: 200},
               exit: {x: 950, y: 100},
               ringData : [  
                            {x: 500, y: 500, diameter: 900},
                            {x: 100, y: 300, diameter: 190},
                            {x: 300, y: 600, diameter: 200},
                            {x: 512, y: 512, diameter: 100},
                            {x: 750, y: 800, diameter: 320},
                            {x: 820, y: 680, diameter: 120},
                            {x: 600, y: 300, diameter: 250},
                            {x: 800, y: 300, diameter: 250}],
           },
        ]
      # RACE MODE
      race: 
        name:   'race'
        
      # PWN MODE
      pwn:
        name:   'pwn'
        
        
      
