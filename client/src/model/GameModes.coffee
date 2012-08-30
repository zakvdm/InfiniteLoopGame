
namespace "FNT", (exports) ->
  
  exports.GameModes =
      # QUEST MODE
      quest:
        name:   "quest"
        levelData: [
           {
               ringAlpha: 0.8
               spawnLocation: {x: 500, y: 630}
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
               ringAlpha: 0.8
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
               spawnLocation : {x: 80, y: 550},
               exit: {x: 600, y: 700},
               ringData : [
                            {x: 300, y: 400, diameter: 570}
                            {x: 500, y: 600, diameter: 300}]
               portals: [
                            {type: FNT.Portals.RESPAWN, x: 300, y: 700, diameter: 100}
                            {type: FNT.Portals.RESPAWN, x: 650, y: 200, diameter: 200}
                            {type: FNT.Portals.RESPAWN, x: 900, y: 500, diameter: 400}]
               texts: [
                            {text: "black holes", x: 200, y: 495, start: FNT.Time.ONE_SECOND, duration: FNT.Time.TEN_SECONDS, size: 30} ]
           }, 
           {
               spawnLocation : {x: FNT.Game.MIDDLE.x, y: FNT.Game.HEIGHT - 100},
               exit: {x: 420, y: 100},
               ringData : [
                            {x: FNT.Game.MIDDLE.x, y: FNT.Game.MIDDLE.y, diameter: FNT.Game.HEIGHT},
                            {x: FNT.Game.MIDDLE.x, y: FNT.Game.MIDDLE.y, diameter: 200}, ],
               texts: [
                            {text: "seesaw", x: FNT.Game.MIDDLE.x - 50, y: FNT.Game.MIDDLE.y - 50, start: FNT.Time.ONE_SECOND, duration: FNT.Time.FIVE_SECONDS, size: 24} ]
           },
           {
               spawnLocation : {x: 100, y: FNT.Game.MIDDLE.y + 100},
               exit: {x: 1240, y: FNT.Game.MIDDLE.y},
               ringData : [
                            {x: 150, y: FNT.Game.MIDDLE.y, diameter: 250},
                            {x: 350, y: FNT.Game.MIDDLE.y, diameter: 250},
                            {x: 550, y: FNT.Game.MIDDLE.y, diameter: 250},
                            {x: 750, y: FNT.Game.MIDDLE.y, diameter: 250},
                            {x: 950, y: FNT.Game.MIDDLE.y, diameter: 250},
                            {x: 1150, y: FNT.Game.MIDDLE.y, diameter: 250}, ],
               portals: [
                            {type: FNT.Portals.RESPAWN, x: 350, y: FNT.Game.MIDDLE.y + 100, diameter: 50},
                            {type: FNT.Portals.RESPAWN, x: 750, y: FNT.Game.MIDDLE.y + 100, diameter: 50},
                            {type: FNT.Portals.RESPAWN, x: 1150, y: FNT.Game.MIDDLE.y + 100, diameter: 50}, ]
               texts: [
                            {text: "rings", x: FNT.Game.MIDDLE.x - 100, y: FNT.Game.MIDDLE.y - 50, start: FNT.Time.ONE_SECOND, duration: FNT.Time.FIVE_SECONDS, size: 24} ]
           },
           {
               spawnLocation : {x: 80, y: 200},
               exit: {x: 1100, y: FNT.Game.MIDDLE.y + 100},
               ringData : [  
                            {x: 120, y: FNT.Game.MIDDLE.y + 100, diameter: 150}
                            {x: 600, y: FNT.Game.MIDDLE.y + 100, diameter: 150}],
               texts: [
                            {text: "press 'R' to retry the current level", x: FNT.Game.MIDDLE.x + 100, y: FNT.Game.MIDDLE.y - 50, start: FNT.Time.TEN_SECONDS, duration: FNT.Time.FOUR_SECONDS, size: 18}
                            {text: "monkeybars", x: 540, y: FNT.Game.MIDDLE.y + 80, start: FNT.Time.ONE_SECOND, duration: FNT.Time.FIVE_SECONDS, size: 24} ]
           },
           {
               ringAlpha: 0.3
               spawnLocation : {x: FNT.Game.MIDDLE.x, y: FNT.Game.MIDDLE.y},
               exit: {x: 100, y: 400},
               ringData : [  
                            {x: FNT.Game.MIDDLE.x, y: FNT.Game.MIDDLE.y, diameter: 100}
                            {x: FNT.Game.MIDDLE.x + 50, y: FNT.Game.MIDDLE.y - 50, diameter: 190}
                            {x: FNT.Game.MIDDLE.x, y: FNT.Game.MIDDLE.y - 100, diameter: 400}
                            {x: FNT.Game.MIDDLE.x - 10, y: FNT.Game.MIDDLE.y + 60, diameter: 600}
                            {x: FNT.Game.MIDDLE.x + 50, y: FNT.Game.MIDDLE.y - 120, diameter: 900} ],
               texts: [
                            {text: "escape", x: FNT.Game.MIDDLE.x + 50, y: FNT.Game.MIDDLE.y - 50, start: FNT.Time.ONE_SECOND, duration: FNT.Time.FIVE_SECONDS, size: 20} ]
           },
           {
               spawnLocation :    {x: 312, y: 200},
               exit: {x: 1050, y: 500},
               ringData : [  
                            {x: 500, y: 400, diameter: 700},
                            {x: 250, y: 150, diameter: 150},
                            {x: 300, y: 500, diameter: 200},
                            {x: 512, y: 412, diameter: 100},
                            {x: 1050, y: 500, diameter: 320},
                            {x: 1200, y: 580, diameter: 120},
                            {x: 700, y: 250, diameter: 200},
                            {x: 850, y: 250, diameter: 200}],
               texts: [
                            {text: "goto", x: FNT.Game.MIDDLE.x + 50, y: FNT.Game.MIDDLE.y - 50, start: FNT.Time.ONE_SECOND, duration: FNT.Time.FIVE_SECONDS, size: 28} ]
           },
        ]
      # RACE MODE
      race: 
        name:   'race'
        
      # PWN MODE
      pwn:
        name:   'pwn'
        
        
      
