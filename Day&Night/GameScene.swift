//
//  GameScene.swift
//  Day&Night
//
//  Created by Lisa on 7/23/17.
//  Copyright © 2017 Lisa Ye. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene , SKPhysicsContactDelegate {
    
    var scoreLabel: SKLabelNode!
    
    var timePoints: CFTimeInterval = 0
    
    let fixedDelta: CFTimeInterval = 1.0 / 60.0
    

    
    
    override func didMove(to view: SKView) {
        
        scoreLabel = childNode(withName: "scoreLabel") as! SKLabelNode
        
        physicsWorld.contactDelegate = self
        
        
        
        
    }
    
    

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
     
        
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        
        timePoints += fixedDelta
        scoreLabel.text = "\(Int(timePoints))"
    }
 
    
}
