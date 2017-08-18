//
//  MainMenu.swift
//  Day and Night
//
//  Created by Lisa on 8/14/17.
//  Copyright © 2017 Lisa Ye. All rights reserved.
//

import SpriteKit
import GameplayKit

class MainMenu: SKScene {
    
    //UI Connection
    var startButton: MSButtonNode!
    var tutorialButton: MSButtonNode!
    var highscoreButton: MSButtonNode!
    
    var showCredits: MSButtonNode!
    var creditsScreen: SKSpriteNode!
    var closeButton: MSButtonNode!
    
    override func didMove(to view: SKView) {
        //set up scene here
        
        //UI connection
        startButton = self.childNode(withName: "startButton") as! MSButtonNode
        tutorialButton = self.childNode(withName: "tutorialButton") as! MSButtonNode
        highscoreButton = self.childNode(withName: "highscoreButton") as! MSButtonNode
        closeButton = childNode(withName: "closeButton") as! MSButtonNode
        let backgroundSound = SKAudioNode(fileNamed: "main menu music")
        self.addChild(backgroundSound)
        
        showCredits = childNode(withName: "showCredits") as! MSButtonNode
        creditsScreen = childNode(withName: "creditsScreen") as! SKSpriteNode
        creditsScreen.alpha = 0
        closeButton.alpha = 0
        
       let buttonClickSound = SKAction.playSoundFileNamed("button", waitForCompletion: false)
        
        //Allow the button to run when tapped
        
        showCredits.selectedHandler = {
            self.run(buttonClickSound)
            self.run(SKAction.wait(forDuration: 0.1)) {
                self.creditsScreen.alpha = 1
                self.closeButton.alpha = 1
            }
        }
        
        closeButton.selectedHandler = {
            self.run(buttonClickSound)
            self.run(SKAction.wait(forDuration: 0.1)) {
                self.creditsScreen.alpha = 0
                self.closeButton.alpha = 0
            }
        }
        
        startButton.selectedHandler = { [unowned self] in
            self.run(buttonClickSound)
            self.run(SKAction.wait(forDuration: 0.1)) {
            self.loadGame()
            }
            
        }
        
        tutorialButton.selectedHandler = { [unowned self] in
            self.run(buttonClickSound)
            self.run(SKAction.wait(forDuration: 0.1)) {
            self.startTutorial()
            }
        }
        
    }

    
    
    func loadGame() {
        
        // 1) Grab reference to our SpriteKit view
        guard let skView = self.view as SKView! else {
            print("Could not get SKview")
            return
        }
        
        // 2) Load Game scene
        guard let scene = GameScene(fileNamed:"GameScene") else {
            print("Could not make GameScene, check the name is spelled correctly")
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
    
    func startTutorial() {
        // 1) Grab reference to our SpriteKit view
        guard let skView = self.view as SKView! else {
            print("Could not get SKview")
            return
        }
        
        // 2) Load Game scene
        guard let scene = Tutorial(fileNamed:"Tutorial") else {
            print("Could not make GameScene, check the name is spelled correctly")
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
    
    func highScore() {
        
    }
    
    
    
    
    
}//CLOSING BRACKETS FOR THE CLASS DON'T TOUCH
