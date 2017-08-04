//
//  DayEnemy.swift
//  Day and Night
//
//  Created by Lisa on 8/4/17.
//  Copyright © 2017 Lisa Ye. All rights reserved.
//

import SpriteKit

public class DayEnemy: SKSpriteNode {

    override init(texture: SKTexture?, color: UIColor, size: CGSize) {
        super.init(texture: texture, color: color, size:size)
        
        
        if dayTime {
            //daytime = enemy
            self.physicsBody?.categoryBitMask = 8
        }
        else {
            //night time = friend
            self.physicsBody?.categoryBitMask = 16
        }
        
        
        
    }
    
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
