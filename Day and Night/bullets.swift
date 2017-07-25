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
        physicsBody?.affectedByGravity = false
        physicsBody?.categoryBitMask = 4
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
