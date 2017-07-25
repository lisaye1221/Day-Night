
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
    var score: CFTimeInterval = 0 //score of player
    
    var egg: SKSpriteNode!
    var eggReference: SKReferenceNode!
    var scoreLabel: SKLabelNode!
    var jumpButton: MSButtonNode!
    var shootButton: MSButtonNode!
    
    var playerOnGround: Bool = true //a variable that checks if player is on the ground
    
//++++++++++++++++++++++++VARIABLES ABOVE++++++++++++++++++++++++++++++++
    
    override func didMove(to view: SKView) {
        
        egg = childNode(withName: "//egg") as! SKSpriteNode
        eggReference = childNode(withName: "eggReference") as! SKReferenceNode
        scoreLabel = childNode(withName: "scoreLabel") as! SKLabelNode
        jumpButton = childNode(withName: "jumpButton") as! MSButtonNode
        shootButton = childNode(withName: "shootButton") as! MSButtonNode
        
        physicsWorld.contactDelegate = self //set up physics
        
        
        jumpButton.selectedHandler = {
            if self.playerOnGround {
                self.egg.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 28))//apply vertical impulse as jumping
                self.playerOnGround = false //deactivate this button until contact sets this to true
            }
        }
        
        shootButton.selectedHandler = {
            
            //make a bullet when button is touched
            let eggBullet = Bullet()
            
            //add the bullet to the screen
            self.addChild(eggBullet)
            
            //Move the bullet to in front of the egg
            eggBullet.position.x = self.eggReference.position.x + 15
            eggBullet.position.y = self.eggReference.position.y - 2
            
            //impluse vector, how fast the bullet goes
            let launchImpulse = CGVector(dx: 10, dy: 0)
            
            //Apply impulse to penguin
            eggBullet.physicsBody?.applyImpulse(launchImpulse)

        }
        
        
        
    }//closing brackets for didMove function
    
    
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        
    }
    
    
    
    func didBegin(_ contact: SKPhysicsContact) {
        if contact.bodyA.categoryBitMask == 1 && contact.bodyB.categoryBitMask == 2 ||
            contact.bodyA.categoryBitMask == 2 && contact.bodyB.categoryBitMask == 1 {
            //contact.bodyB.node?.removeFromParent()  //removes the node that is bodyB
            playerOnGround = true // if egg touches ground, it's on the ground
        }
        
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        
        score += fixedDelta //adds 1 to score every second
        scoreLabel.text = "\(Int(score))" //updates scoreLabel
        
        for placeValue in 1...8 { //shifts the label when it gets too large
            if Int(scoreLabel.text!)! == power(base: 10, power: placeValue) {
                scoreLabel.position.x += 3 / 60
            }
            
        }
        
        
    }//CLOSING BRACKETS FOR UPDATE FUNCTION
    
    
}//Closing brackets for the gamescene class
