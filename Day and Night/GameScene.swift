//
//  GameScene.swift
//  Day and Night
//
//  Created by Lisa on 7/24/17.
//  Copyright © 2017 Lisa Ye. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    let fixedDelta: CFTimeInterval = 1.0 / 60.0
    var score: CFTimeInterval = 0
    
    var scoreLabel: SKLabelNode!
    
    override func didMove(to view: SKView) {
        
        scoreLabel = childNode(withName: "scoreLabel") as! SKLabelNode
      
    }
    
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
  
        
        }
        
    
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        
        score += fixedDelta
        scoreLabel.text = "\(Int(score))"
        
    }
        
        
}//Closing brackets
