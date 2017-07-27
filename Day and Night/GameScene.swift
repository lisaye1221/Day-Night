
//
//  GameScene.swift
//  Day and Night
//
//  Created by Lisa on 7/24/17.
//  Copyright © 2017 Lisa Ye. All rights reserved.


import SpriteKit
import GameplayKit


enum GameState {
    case gameActive, gameOver
}

enum WorldState {
    case day, night
}


class GameScene: SKScene, SKPhysicsContactDelegate {
    
    let fixedDelta: CFTimeInterval = 1.0 / 60.0
    var score: CFTimeInterval = 0 //score of player
    var spawnTimer: CFTimeInterval = 0
    let scrollSpeed: CGFloat = 90
    var obstacleTravelSpeed: CGFloat = 150
    var npcTravelSpeed: CGFloat = 300
    
    var playerOnGround: Bool = true //a variable that checks if player is on the ground
    
    var egg: SKSpriteNode!
    var scoreLabel: SKLabelNode!
    var jumpButton: MSButtonNode!
    var shootButton: MSButtonNode!
    var restartButton: MSButtonNode!
    var scrollLayer: SKNode!
    
    var bulletHitEnemy = false
    
    var enemiesArray: SKNode!
    var enemyScrollLayer: SKNode!
    var obstacleScrollLayer: SKNode!
    
    //states
    var gameState: GameState = .gameActive
    var worldState: WorldState = .day
    
    //++++++++++++++++++++++++VARIABLES ABOVE++++++++++++++++++++++++++++++++
    
    override func didMove(to view: SKView) {
        
        egg = self.childNode(withName: "//egg") as! SKSpriteNode
        scoreLabel = childNode(withName: "scoreLabel") as! SKLabelNode
        jumpButton = childNode(withName: "jumpButton") as! MSButtonNode
        shootButton = childNode(withName: "shootButton") as! MSButtonNode
        restartButton = childNode(withName: "restartButton") as! MSButtonNode
        scrollLayer = childNode(withName: "scrollLayer")
        enemiesArray = childNode(withName: "enemiesArray")
        enemyScrollLayer = childNode(withName: "enemyScrollLayer")
        obstacleScrollLayer = childNode(withName: "obstacleScrollLayer")
        
        
        
        physicsWorld.contactDelegate = self //set up physics
        
        /* Hide restart button */
        restartButton.state = .MSButtonNodeStateHidden
        
        jumpButton.selectedHandler = {
            
            if self.gameState != .gameActive {return}
            
            if self.playerOnGround {
                self.egg.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 30))//apply vertical impulse as jumping
                let eggPosition = self.egg.convert(self.egg.position, to: self)
                
                print(eggPosition.y)
                
                self.playerOnGround = false //deactivate this button until contact sets this to true
            }
        }
        
        shootButton.selectedHandler = {
            
            if self.gameState != .gameActive {return}
            
            //make a bullet when button is touched
            let eggBullet = Bullet()
            
            //add the bullet to the screen
            self.addChild(eggBullet)
            
            let eggPosition = self.egg.convert(self.egg.position, to: self)
            
            //Move the bullet to in front of the egg
            eggBullet.position.x = eggPosition.x + 15
            eggBullet.position.y = eggPosition.y - 2
            
            //ensure the player's y velocity doesn't affect the bullet's y velocity(so the bullet doesn't go diagonally up when playe jumps)
            if self.playerOnGround == false {
                eggBullet.physicsBody?.velocity.dy = 0
            }
            
            //limit the bullet height
            if eggBullet.position.y > 160 {
                eggBullet.position.y = 160
            }
            
            //impluse vector, how fast the bullet goes
            let launchImpulse = CGVector(dx: 10, dy: 0)
            
            //Apply impulse to penguin
            eggBullet.physicsBody?.applyImpulse(launchImpulse)
            
        }
        
        restartButton.selectedHandler = {
            
            /* Grab reference to our SpriteKit view */
            let skView = self.view as SKView!
            
            /* Load Game scene */
            let scene = GameScene(fileNamed:"GameScene") as GameScene!
            
            /* Ensure correct aspect mode */
            scene?.scaleMode = .aspectFill
            
            /* Restart game scene */
            skView?.presentScene(scene)
            
        }
        
        
    }//closing brackets for didMove function
    
    
    func scrollWorld() {
        /* Scroll World */
        scrollLayer.position.x -= scrollSpeed * CGFloat(fixedDelta)
        
        /* Loop through scroll layer nodes */
        for ground in scrollLayer.children as! [SKSpriteNode] {
            
            /* Get ground node position, convert node position to scene space, ground is child of scrollLayer but not necess a child of scene so gotta convert */
            let groundPosition = scrollLayer.convert(ground.position, to: self)
            
            /* Check if ground sprite has left the scene */
            if groundPosition.x <= -ground.size.width / 2 {
                
                /* Reposition ground sprite to the second starting position */
                let newPosition = CGPoint(x: (self.size.width / 2) + ground.size.width , y: groundPosition.y)
                
                /* Convert new node position back to scroll layer space */
                ground.position = self.convert(newPosition, to: scrollLayer)
            }
        }
    }
    
    
    func spawnEnemy() {
        
        //maybe make this function spawnNPC, if it's just enemies, it might be weird when implementing the switching
        //when it's time to bring in all the enemies, and want to spawn random species, use random number to generate a random index in the array
        
        //scroll enemylayer so it moves across
        enemyScrollLayer.position.x -= npcTravelSpeed * CGFloat(fixedDelta)
        enemyScrollLayer.position.y = 0
        
        var enemyList = [SKNode]()
        
//        for childReference in enemiesArray.children {
//            for childSKNode in childReference.children {
//                for child in childSKNode.children {
//            enemyList.append(child as! SKSpriteNode)
//                }
//            }
//        }
        
        for child in enemiesArray.children {
            enemyList.append(child)
        }
        
        
        var density = 0.5 //time inbetween a new enemy(lower = more enemy)
        
        if spawnTimer >= density {

            
            let newEnemy = enemyList[0].copy() as! SKNode //newEnemy is the first child
            
            enemyScrollLayer.addChild(newEnemy) //adds new enemy
            
            let eggPosition = self.egg.convert(self.egg.position, to: self)
            let randomPosition = CGPoint(x: 800 , y: 80)
            newEnemy.position = self.convert(randomPosition, to: enemyScrollLayer)
            print(newEnemy.position.y)
            
            // Reset spawn timer
            spawnTimer = 0
            
        }
    }
    
    func spawnObstacle() {
        
        obstacleScrollLayer.position.x -= obstacleTravelSpeed * CGFloat(fixedDelta)
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        
    }
    
    
    
    func didBegin(_ contact: SKPhysicsContact) {
        
        //changing between friend and enemy by changing category bit mask
        
        let contactA = contact.bodyA
        let contactB = contact.bodyB

        
        //when player hits ground
        if contactA.categoryBitMask == 1 && contactB.categoryBitMask == 2 ||
            contactA.categoryBitMask == 2 && contactB.categoryBitMask == 1 {
            //contact.bodyB.node?.removeFromParent()  //removes the node that is bodyB
            playerOnGround = true // if egg touches ground, it's on the ground
        }
        
        
        //when player touches enemy
        if contactA.categoryBitMask == 1 && contactB.categoryBitMask == 8 || contactA.categoryBitMask == 8 && contactB.categoryBitMask == 1 {
            
            if gameState != .gameActive { return }
          
            gameOver()
        }
        
        
        //when bullet hits enemy
        if contactA.categoryBitMask == 4 && contactB.categoryBitMask == 8 || contactA.categoryBitMask == 8 && contactB.categoryBitMask == 4 {
            
            contact.bodyA.node?.removeFromParent()
            contact.bodyB.node?.removeFromParent()
            
            bulletHitEnemy = true
        }
        
        //when player hits an obstacle 
        if contactA.categoryBitMask == 1 && contactB.categoryBitMask == 32 || contactA.categoryBitMask == 32 && contactB.categoryBitMask == 1 {
            
            if gameState != .gameActive { return }
            
            gameOver()
        }
        
        //when bullet hits an obstacle
        if contactA.categoryBitMask == 4 && contactB.categoryBitMask == 32 {
            
            contactA.node?.removeFromParent()
            contactB.node?.physicsBody?.velocity.dx = 0
        }
        else if contactA.categoryBitMask == 32 && contactB.categoryBitMask == 4 {
            contactB.node?.removeFromParent()
            contactA.node?.physicsBody?.velocity.dx = 0
        }
        
        
    }//closing brackets for didBegin function
    
    
    func gameOver() {
        
        /* Change game state to game over */
        gameState = .gameOver
        
        if gameState != .gameOver {return}
        
        /* Show restart button */
        restartButton.state = .MSButtonNodeStateActive
        
        
        //loops through EVERYTHING in the scene
        enumerateChildNodes(withName: "//*", using:
            { (node, stop) -> Void in
                if let spriteNode = node as? SKSpriteNode {
                    spriteNode.removeAllActions()
                    spriteNode.physicsBody?.velocity.dx = 0
                }
        })
        
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        
        if gameState != .gameActive { return }
        
        score += fixedDelta //adds 1 to score every second
        scoreLabel.text = "\(Int(score))" //updates scoreLabel
        spawnTimer += fixedDelta
        
        scrollWorld()
        spawnEnemy()
        spawnObstacle()
        
        if bulletHitEnemy {
            score += 5
            bulletHitEnemy = false
        }
        
        enumerateChildNodes(withName: "//*", using:
            { (node, stop) -> Void in
                if let bullet = node as? SKSpriteNode {
                    let bulletPosition = bullet.convert(bullet.position, to: self)
                    if bullet.name == "bullet" && bulletPosition.x > 800{
                    bullet.removeFromParent()
                    }
                }
        })
        
        
        
    }//CLOSING BRACKETS FOR UPDATE FUNCTION
    
    
}//Closing brackets for the gamescene class
