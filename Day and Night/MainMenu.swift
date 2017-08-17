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
    
    override func didMove(to view: SKView) {
        //set up scene here
        
        //UI connection
        startButton = self.childNode(withName: "startButton") as! MSButtonNode
        tutorialButton = self.childNode(withName: "tutorialButton") as! MSButtonNode
        highscoreButton = self.childNode(withName: "highscoreButton") as! MSButtonNode
        let backgroundSound = SKAudioNode(fileNamed: "main menu music")
        self.addChild(backgroundSound)
        
       let buttonClickSound = SKAudioNode(fileNamed: "button")
        
        //Allow the button to run when tapped
        startButton.selectedHandler = { [unowned self] in
            self.addChild(buttonClickSound)
            self.loadGame()
        }
        
        tutorialButton.selectedHandler = { [unowned self] in
            self.addChild(buttonClickSound)
            self.startTutorial()
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
        scene.scaleMode = .aspectFill
        
        //Show debug
        skView.showsDrawCount = true
        skView.showsFPS = true
        
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
        scene.scaleMode = .aspectFill
        
        //Show debug
        skView.showsDrawCount = true
        skView.showsFPS = true
        
        // 4) Start game scene
        skView.presentScene(scene)
        
    }
    
    func highScore() {
        
    }
    
    
    
    
    
}//CLOSING BRACKETS FOR THE CLASS DON'T TOUCH
