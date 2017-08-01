//
//  Helper Function.swift
//  Day and Night
//
//  Created by Lisa on 7/25/17.
//  Copyright © 2017 Lisa Ye. All rights reserved.
//

import Foundation


func power(base: Int, power: Int) -> Int {
    var result = base
    for power in 1...power {
        result *= base
    }
    if base == 1 || base == 0{
        return base
    }
    if power == 0 {
        return 1
    }
    else {
        return result
    }
}

func randomInteger(min min: Int, max: Int) -> Int { //max is non-inclusive
    let randomNum = Int(arc4random_uniform(UInt32(max) - UInt32(min)) + UInt32(min))
    return randomNum
}

