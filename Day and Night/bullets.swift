//
//  bullets.swift
//  Day and Night
//
//  Created by Lisa on 7/25/17.
//  Copyright © 2017 Lisa Ye. All rights reserved.
//

import SpriteKit

class Bullet: SKSpriteNode {
    
    init() {
        //Make a texture from an image, a color, and size
        let texture = SKTexture(imageNamed: "eggBullet")
        let color = UIColor.yellow
        let size = CGSize(width: 15, height: 15)
        
        //Call the designated initializer
        super.init(texture: texture, color: color, size: size)
        
        //set the physics properties
        physicsBody = SKPhysicsBody(rectangleOf: size) //set rectangular physics body
        self.physicsBody?.affectedByGravity = false //no gravity so it doesn't fall down
        self.physicsBody?.isDynamic = true //want the bullet to move
        self.physicsBody?.categoryBitMask = 4
        self.physicsBody?.contactTestBitMask = 24
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
