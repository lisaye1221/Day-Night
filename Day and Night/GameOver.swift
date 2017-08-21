//
//  GameOver.swift
//  Day and Night
//
//  Created by Lisa on 8/17/17.
//  Copyright © 2017 Lisa Ye. All rights reserved.
//

import SpriteKit
import GameplayKit


class GameOver: SKScene {
    
    //stored values
    var highScore = UserDefaults.standard.integer(forKey: "HIGHSCORE")
    var eggshellTotal = UserDefaults.standard.integer(forKey: "EGGSHELL")
    var longestDayCount = UserDefaults.standard.integer(forKey: "LONGESTDAY")
    
    var floatingEgg: SKSpriteNode!
    var scrollLayer: SKNode!
    
    var restartButton: MSButtonNode!
    var homeButton: MSButtonNode!

    var highScoreLabel: SKLabelNode!
    var eggshellLabel: SKLabelNode!
    var totalEggshellLabel: SKLabelNode!
    var currentScoreLabel: SKLabelNode!
    var dayLabel: SKLabelNode!
    var longestDayLabel: SKLabelNode!

    let scrollSpeed: CGFloat = 100
    let fixedDelta: CFTimeInterval = 1.0 / 60.0
    
    //++++++++++++++++++++++++VARIABLES ABOVE++++++++++++++++++++++++++++++++
    
    override func didMove(to view: SKView) {
        
        floatingEgg = childNode(withName: "floatingEgg") as! SKSpriteNode
        scrollLayer = childNode(withName: "scrollLayer")
        
        restartButton = childNode(withName: "restartButton") as! MSButtonNode
        homeButton = childNode(withName: "homeButton") as! MSButtonNode
        
        eggshellLabel = childNode(withName: "eggshellLabel") as! SKLabelNode
        highScoreLabel = childNode(withName: "highScore") as! SKLabelNode
        totalEggshellLabel = childNode(withName: "totalEggshellLabel") as! SKLabelNode
        currentScoreLabel = childNode(withName: "scoreLabel") as! SKLabelNode
        dayLabel = childNode(withName: "dayLabel") as! SKLabelNode
        longestDayLabel = childNode(withName: "longestDayLabel") as! SKLabelNode
        
        currentScoreLabel.text = String(currentScore)
        highScoreLabel.text = String(highScore)
        totalEggshellLabel.text = String(eggshellTotal)
        eggshellLabel.text = String(currentEggshell)
        dayLabel.text = String(daySurvived)
        longestDayLabel.text = String(longestDayCount)
        
        let floating = SKAction(named: "floating")!
        floatingEgg.run(floating)
        
        let backgroundSound = SKAudioNode(fileNamed: "Little Boy Music Box")
        
        if musicShouldPlay {
        self.addChild(backgroundSound)
        }

        let buttonClickSound = SKAction.playSoundFileNamed("button", waitForCompletion: false)
        
        restartButton.selectedHandler = { [unowned self] in
            
            self.run(buttonClickSound)
            self.run(SKAction.wait(forDuration: 0.1)){
            
            /* Grab reference to our SpriteKit view */
            let skView = self.view as SKView!
            
            /* Load Game scene */
            let scene = GameScene(fileNamed:"GameScene") as GameScene!
            
            /* Ensure correct aspect mode */
            scene?.scaleMode = .aspectFit
            
            /* Restart game scene */
            skView?.presentScene(scene)
            }
        }
        
        homeButton.selectedHandler = {
            
            self.run(buttonClickSound)
            self.run(SKAction.wait(forDuration: 0.1)){
            
            // 1) Grab reference to our SpriteKit view
            guard let skView = self.view as SKView! else {
                print("Could not get SKview")
                return
            }
            
            // 2) Load Game scene
            guard let scene = MainMenu(fileNamed:"Main Menu") else {
                print("Could not make MainMenu, check the name is spelled correctly")
                return
            }
            
            // 3) Ensure correct aspect mode
            scene.scaleMode = .aspectFit
            
            //Show debug
            skView.showsDrawCount = false
            skView.showsFPS = false
            
            // 4) Start game scene
            skView.presentScene(scene)
            
        }
            
        }
        
    }
    
    func scrollWorld() {
        
        /* Scroll World */
        scrollLayer.position.x -= scrollSpeed * CGFloat(fixedDelta)
        
        /* Loop through scroll layer nodes */
        for ground in scrollLayer.children as! [SKSpriteNode] {
            
            /* Get ground node position, convert node position to scene space, ground is child of scrollLayer but not necess a child of scene so gotta convert */
            let groundPosition = scrollLayer.convert(ground.position, to: self)
            
            
            /* Check if ground sprite has left the scene */
            if groundPosition.x <= (-ground.size.width + 1) {
                
                /* Reposition ground sprite to the second starting position */
                let newPosition = CGPoint(x: (self.size.width * 2)  , y: groundPosition.y)
                
                /* Convert new node position back to scroll layer space */
                ground.position = self.convert(newPosition, to: scrollLayer)
            }
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        scrollWorld()
      
    }
    
    
}
