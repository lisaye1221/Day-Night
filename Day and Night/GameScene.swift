
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
    
    //time related variable
    let fixedDelta: CFTimeInterval = 1.0 / 60.0
    var score: CFTimeInterval = 0 //score of player
    var spawnTimer: CFTimeInterval = 0
    var obstacleSpawnTimer: CFTimeInterval = 0
    let scrollSpeed: CGFloat = 250
    
    var obstacleTravelSpeed: CGFloat = 250
    var npcTravelSpeed: CGFloat = 280
    var obstacleDensity = 1.4
    var npcDensity = 1.8 //time inbetween a new enemy(lower = more enemy)
    
    var karmaBar: SKSpriteNode!
    var karmaValue: CGFloat = 1.0 {
        didSet{
            
            if karmaValue > 1.0 {
                karmaValue = 1.0
            }
            else if karmaValue < 0 {
                karmaValue = 0
            }
            else {
                karmaBar.xScale = karmaValue * 3
            }
            
        }
    }
    
    
    var playerOnGround: Bool = true //a variable that checks if player is on the ground
    
    var egg: SKSpriteNode!
    var scoreLabel: SKLabelNode!
    var jumpButton: MSButtonNode!
    var shootButton: MSButtonNode!
    var restartButton: MSButtonNode!
    var scrollLayer: SKNode!
    
    var bulletHitEnemy = false
    var bulletHitFriend = false
    var playerTouchFriend = false
    var npcjump = false
    
    var npcsArray: SKNode!
    var npcScrollLayer: SKNode!
    var obstacleScrollLayer: SKNode!
    var cloudScrollLayer: SKNode!
    
    var obstacleArray: SKNode!
    var obstacleSource: SKNode!
    
    //states
    var gameState: GameState = .gameActive
    var worldState: WorldState = .day
    
    //temp
    var cone: SKSpriteNode!
    
    //++++++++++++++++++++++++VARIABLES ABOVE++++++++++++++++++++++++++++++++
    
    override func didMove(to view: SKView) {
        
        egg = self.childNode(withName: "//egg") as! SKSpriteNode
        scoreLabel = childNode(withName: "scoreLabel") as! SKLabelNode
        jumpButton = childNode(withName: "jumpButton") as! MSButtonNode
        shootButton = childNode(withName: "shootButton") as! MSButtonNode
        restartButton = childNode(withName: "restartButton") as! MSButtonNode
        scrollLayer = childNode(withName: "scrollLayer")
        npcsArray = childNode(withName: "npcsArray")
        npcScrollLayer = childNode(withName: "npcScrollLayer")
        obstacleScrollLayer = childNode(withName: "obstacleScrollLayer")
        obstacleArray = childNode(withName: "obstacleArray")
        obstacleSource = childNode(withName: "obstacle")
        cloudScrollLayer = childNode(withName: "cloudScrollLayer")
        
        karmaBar = childNode(withName: "karmaBar") as! SKSpriteNode
        cone = childNode(withName: "//cone") as! SKSpriteNode
        
        
        physicsWorld.contactDelegate = self //set up physics
        
        /* Hide restart button */
        restartButton.state = .MSButtonNodeStateHidden
        
        jumpButton.selectedHandler = { [unowned self] in
            
            if self.gameState != .gameActive {return}
            
            if self.playerOnGround {
                self.egg.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 23))//apply vertical impulse as jumping
                let eggPosition = self.egg.convert(self.egg.position, to: self)
                
                self.npcjump = true
                self.playerOnGround = false //deactivate this button until contact sets this to true
            }
        }
        
        shootButton.selectedHandler = { [unowned self] in
            
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
        
        restartButton.selectedHandler = { [unowned self] in
            
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
            if groundPosition.x <= (-ground.size.width + 5)  {
                
                /* Reposition ground sprite to the second starting position */
                let newPosition = CGPoint(x: (self.size.width * 2)  , y: groundPosition.y)
                
                /* Convert new node position back to scroll layer space */
                ground.position = self.convert(newPosition, to: scrollLayer)
            }
        }
    }
    
    func scrollBackground() {
        cloudScrollLayer.position.x -= scrollSpeed * CGFloat(fixedDelta)
        
        /* Loop through scroll layer nodes */
        for cloud in cloudScrollLayer.children as! [SKSpriteNode] {
            
            /* Get ground node position, convert node position to scene space, ground is child of scrollLayer but not necess a child of scene so gotta convert */
            let cloudPosition = cloudScrollLayer.convert(cloud.position, to: self)
            
            /* Check if ground sprite has left the scene */
            if cloudPosition.x <= (-cloud.size.width + 5)  {
                
                /* Reposition ground sprite to the second starting position */
                let newPosition = CGPoint(x: (self.size.width * 5)  , y: cloudPosition.y)
                
                /* Convert new node position back to scroll layer space */
                cloud.position = self.convert(newPosition, to: cloudScrollLayer)
            }
        }
        
    }
    
    
    func spawnNpc() {
        
        //maybe make this function spawnNPC, if it's just enemies, it might be weird when implementing the switching
        //when it's time to bring in all the enemies, and want to spawn random species, use random number to generate a random index in the array
        
        //scroll npcLayer so it moves across
        npcScrollLayer.position.x -= npcTravelSpeed * CGFloat(fixedDelta)
        npcScrollLayer.position.y = 0
        
        var npcList = [SKSpriteNode]()
        
                for childReference in npcsArray.children {
                    for childSKNode in childReference.children {
                        for child in childSKNode.children {
                    npcList.append(child as! SKSpriteNode)
                        }
                    }
                }
        
//        for child in npcsArray.children {
//            npcList.append(child)
//        }
        
        /* Loop through obstacle layer nodes*/
        for npc in npcScrollLayer.children as! [SKNode]{
            
            /* Get obstacle node postion, convert node position to scene space */
            let npcPosition = npcScrollLayer.convert(npc.position, to: self)
            
            /* Check if obstacle has left the scene */
            if npcPosition.x <= -100 {
                
                /* Remove obstacle node from obstacle layer */
                npc.removeFromParent()
            }
        }
        
        if spawnTimer >= npcDensity {
            
            let randomNpcIndex = randomInteger(min: 0, max: npcList.count) 
            
            let newEnemy = npcList[randomNpcIndex].copy() as! SKSpriteNode //newEnemy is the first child
            
            npcScrollLayer.addChild(newEnemy) //adds new enemy
            
//            let eggPosition = self.egg.convert(self.egg.position, to: self)
            let randomPosition = CGPoint(x: 800 , y: 80)
            newEnemy.position = self.convert(randomPosition, to: npcScrollLayer)
            
            
            // Reset spawn timer
            spawnTimer = 0
            
        }
    }
    
    func spawnObstacle() {
        
        obstacleScrollLayer.position.x -= obstacleTravelSpeed * CGFloat(fixedDelta)
        
        /* Loop through obstacle layer nodes*/
        for obstacle in obstacleScrollLayer.children as! [SKNode] {
            
            /* Get obstacle node postion, convert node position to scene space */
            let obstaclePosition = obstacleScrollLayer.convert(obstacle.position, to: self)
            
            /* Check if obstacle has left the scene */
            if obstaclePosition.x <= -100 {
                // 26 is one half the width of an obstacle
                
                /* Remove obstacle node from obstacle layer */
                obstacle.removeFromParent()
                
                
            }
            
            
        }
        
        var obstacleList = [SKNode]()
        
        for obstacle in obstacleArray.children {
                obstacleList.append(obstacle)
        }
        
        if obstacleSpawnTimer > obstacleDensity {
            
     let randomObstacleIndex = randomInteger(min: 0, max: obstacleList.count)
            
            /* Create a new obstacle by copying the source obstacle*/
            
            let newObstacle = obstacleList[randomObstacleIndex].copy() as! SKNode
            
           let obstaclePosition = obstacleScrollLayer.convert(newObstacle.position, to: self)
            
            obstacleScrollLayer.addChild(newObstacle)
            
            /* Generate new obstacle position, start just outside screen and with a random y value*/
            let randomPosition = CGPoint(x: 750, y: obstaclePosition.y)
            
            /* Convert new node position back to obstacle layer space */
            newObstacle.position = self.convert(randomPosition, to: obstacleScrollLayer)
            
           
            
            // Reset spawn timer
            obstacleSpawnTimer = 0
            
        }
        
        
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
        
        //when enemy bumps into obstacle
        if contactA.categoryBitMask == 8 && contactB.categoryBitMask == 32 {
            
            contactB.node?.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
            
            contactA.node?.physicsBody?.velocity.dx = 15
        }
        else if contactA.categoryBitMask == 32 && contactB.categoryBitMask == 8 {
            
            contactA.node?.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
            
            contactB.node?.physicsBody?.velocity.dx = 15
            
        }
        
        //when bullet hits friend
        if contactA.categoryBitMask == 4 && contactB.categoryBitMask == 16 || contactA.categoryBitMask == 16 && contactB.categoryBitMask == 4 {
            
            contact.bodyA.node?.removeFromParent()
            contact.bodyB.node?.removeFromParent()
            bulletHitFriend = true
        }
        
        //when player contacts enemy
        if contactA.categoryBitMask == 1 && contactB.categoryBitMask == 16 {
            
            contact.bodyB.node?.removeFromParent()
            playerTouchFriend = true
        }
        else if contactA.categoryBitMask == 16 && contactB.categoryBitMask == 1 {
            
            contact.bodyA.node?.removeFromParent()
            playerTouchFriend = true
            
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
        obstacleSpawnTimer += fixedDelta
        
        scrollWorld()
        scrollBackground()
        spawnNpc()
        spawnObstacle()
        
        if bulletHitEnemy {
            score += 5
            bulletHitEnemy = false
        }
        
        if bulletHitFriend {
            karmaValue -= 0.3
            karmaBar.run(SKAction.colorize(with: UIColor.red, colorBlendFactor: 1, duration: 0.18)) {
                self.karmaBar.run(SKAction.colorize(with: UIColor.white, colorBlendFactor: 1, duration: 0.1))
            }
            bulletHitFriend = false
        }
        
        if playerTouchFriend {
            karmaValue += 0.05
            karmaBar.run(SKAction.colorize(with: UIColor.green, colorBlendFactor: 1, duration: 0.18)) {
                self.karmaBar.run(SKAction.colorize(with: UIColor.white, colorBlendFactor: 1, duration: 0.1))
            }
            playerTouchFriend = false
        }
        
        if npcjump { //makes npc jumps at a random height if player jumps
            let randomJumpHeight = randomInteger(min: 6, max: 18)
            for npc in self.npcScrollLayer.children {
                npc.physicsBody?.applyImpulse(CGVector(dx: 0, dy: randomJumpHeight))
            }
            npcjump = false
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
