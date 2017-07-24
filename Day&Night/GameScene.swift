//
//  GameScene.swift
//  Day&Night
//
//  Created by Lisa on 7/23/17.
//  Copyright © 2017 Lisa Ye. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    override func didMove(to view: SKView) {
        
        physicsWorld.contactDelegate = self
        
        
    }
    
    

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
     
        
    }
    
    
    override func update(_ currentTime: TimeInterval) {

}
    
    
}
