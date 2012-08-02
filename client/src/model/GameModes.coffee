
namespace "FNT", (exports) ->
  
  exports.GameModes =
      # QUEST MODE
      quest:
        name:   "quest"
        levelData: [
           {
               spawnLocation : {x: 500, y: 630}
               exit: {x: 300, y: 500}
               ringData: [
                            {x: 500, y: 350, diameter: 650},]
               texts: [
                            {text: "this is you", x: 480, y: 630, start: 0, duration: FNT.Time.THREE_SECONDS, size: 18}
                            {text: "this is where you want to go", x: 250, y: 420, start: FNT.Time.ONE_SECOND, duration: FNT.Time.THREE_SECONDS, size: 18}
                            {text: "use 'A' and 'D' to move left and right", x: 250, y: 200, start: FNT.Time.TWO_SECONDS, duration: FNT.Time.TEN_SECONDS, size: 18}
                            {text: "hold 'J' to attach to a ring", x: 300, y: 300, start: FNT.Time.FOUR_SECONDS, duration: FNT.Time.TEN_SECONDS, size: 18}
                            {text: "when you release 'J', you get a little boost", x: 400, y: 340, start: FNT.Time.FIVE_SECONDS, duration: FNT.Time.TEN_SECONDS, size: 18}]
           },
           {
               spawnLocation : {x: FNT.Game.MIDDLE.x , y: FNT.Game.MIDDLE.y - 275},
               exit: {x: FNT.Game.MIDDLE.x, y: FNT.Game.MIDDLE.y + 280},
               ringData : [
                            {x: FNT.Game.MIDDLE.x, y: FNT.Game.MIDDLE.y, diameter: 500}, ],
               texts: [
                            {text: "press 'R' to retry the current level", x: FNT.Game.MIDDLE.x - 100, y: FNT.Game.MIDDLE.y - 10, start: FNT.Time.ONE_SECOND, duration: FNT.Time.FOUR_SECONDS, size: 18}
                            {text: "HINT: Hold on tight (press 'J')", x: FNT.Game.MIDDLE.x - 100, y: FNT.Game.MIDDLE.y - 10, start: FNT.Time.TEN_SECONDS, duration: FNT.Time.TEN_SECONDS, size: 18} ]
           }, 
           {
               spawnLocation : {x: 250, y: 300},
               exit: {x: 850, y: 750},
               ringData : [
                            {x: 300, y: 500, diameter: 570},
                            {x: 700, y: 500, diameter: 570}, ],
               texts: [
                            {text: "HINT: While you're clamped onto a ring, you pass through all other rings!", x: 590, y: 495, start: FNT.Time.ONE_SECOND, duration: FNT.Time.TEN_SECONDS, size: 14} ]
           }, 
           {
               spawnLocation : {x: 512, y: 800},
               exit: {x: 300, y: 300},
               ringData : [
                            {x: 500, y: 500, diameter: 1000},
                            {x: 500, y: 500, diameter: 300},
                            {x: 150, y: 150, diameter: 100}],
           },
           {
               spawnLocation : {x: 80, y: 200},
               exit: {x: 950, y: 800},
               ringData : [  
                            {x: 100, y: 800, diameter: 150}
                            {x: 600, y: 800, diameter: 150}],
           },
           {
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
        
        
      
