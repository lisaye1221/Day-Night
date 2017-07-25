
//
//  GameScene.swift
//  Day and Night
//
//  Created by Lisa on 7/24/17.
//  Copyright © 2017 Lisa Ye. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    let fixedDelta: CFTimeInterval = 1.0 / 60.0
    var score: CFTimeInterval = 0
    
    var egg: SKSpriteNode!
    var eggReference: SKReferenceNode!
    var scoreLabel: SKLabelNode!
    var jumpButton: MSButtonNode!
    
    var playerOnGround: Bool = true
    
    
    
    override func didMove(to view: SKView) {
        
        egg = childNode(withName: "//egg") as! SKSpriteNode
        eggReference = childNode(withName: "eggReference") as! SKReferenceNode
        scoreLabel = childNode(withName: "scoreLabel") as! SKLabelNode
        jumpButton = childNode(withName: "jumpButton") as! MSButtonNode
        
        physicsWorld.contactDelegate = self
        
        
        jumpButton.selectedHandler = {
            if self.playerOnGround {
                self.egg.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 28))
                self.playerOnGround = false
            }
        }
        
        
        
    }//closing brackets for didMove function
    
    
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        
        
    }
    
    
    
    func didBegin(_ contact: SKPhysicsContact) {
        if contact.bodyA.categoryBitMask == 1 && contact.bodyB.categoryBitMask == 2 ||
            contact.bodyA.categoryBitMask == 2 && contact.bodyB.categoryBitMask == 1 {
            //contact.bodyB.node?.removeFromParent()  //removes the node that is bodyB
            playerOnGround = true
        }
        
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        
        score += fixedDelta
        scoreLabel.text = "\(Int(score))"
        
        //        /* Grab player's vertical velocity */
        //        let velocityY = egg.physicsBody?.velocity.dy ?? 0
        //
        //        /* Check and cap vertical velocity */
        //        if velocityY > 25 {
        //            egg.physicsBody?.velocity.dy = 25
        //
        //        }
        
    }
    
    
}//Closing brackets for the gamescene class
