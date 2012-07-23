
namespace "FNT", (exports) ->
  
  exports.GameModes =
      # QUEST MODE
      quest:
        name:   "quest"
        levelData: [
           {  # LEVEL 0
               spawnLocation : {x: 312, y: 200},
               ringData : [  
                            {x: 512, y: 512, diameter: 900},
                            {x: 100, y: 400, diameter: 190},
                            {x: 300, y: 600, diameter: 200},
                            {x: 512, y: 512, diameter: 100},
                            {x: 750, y: 800, diameter: 420},
                            {x: 850, y: 800, diameter: 200},
                            {x: 600, y: 300, diameter: 250},
                            {x: 800, y: 300, diameter: 250}],
           },
           {  # LEVEL 1
               spawnLocation : {x: 1000, y: 512},
               exit: {x: 980, y: 480},
               ringData : [  
                            {x: 512, y: 512, diameter: 1024}],
           },
           {  # LEVEL 2
               spawnLocation : {x: 512, y: 800},
               ringData : [
                            {x: 512, y: 512, diameter: 1000},
                            {x: 100, y: 100, diameter: 100}],
           },
        ]
      # RACE MODE
      race: 
        name:   'race'
        
      # PWN MODE
      pwn:
        name:   'pwn'
        
        
      
