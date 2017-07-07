//
//  Math.swift
//  MeltedIce
//
//  Created by Raphaël Calabro on 06/07/2015.
//  Copyright (c) 2015 Raphaël Calabro. All rights reserved.
//

import GLKit

public func smoothStep(_ from: GLfloat, to: GLfloat, value: GLfloat) -> GLfloat {
	return pow(sin(GLfloat.pi / 2 * min(max(value - from, 0) / to, 1)), 2)
}
    
public func smoothStep(_ from: TimeInterval, to: TimeInterval, value: TimeInterval) -> GLfloat {
    return GLfloat(pow(sin(TimeInterval(TimeInterval.pi / 2) * min(max(value - from, 0) / to, 1)), 2))
}
    
public func square(_ value: GLfloat) -> GLfloat {
    return value * value
}
	
public func toRadian(_ degree: GLfloat) -> GLfloat {
    return degree * GLfloat.pi / 180
}

public func toDegree(_ radian: GLfloat) -> GLfloat {
    return radian * 180 / GLfloat.pi
}
    
public func mod(_ value: Int, by modulo: Int) -> Int {
    return ((value % modulo) + modulo) % modulo
}

public func nearestUpperPowerOfTwoFor(_ value: Int) -> Int {
    var pot = 0
    while true {
        let power = Int(pow(2, Float(pot)))
        let surface = power * power
        
        if surface >= value {
            return power
        }
        pot += 1
    }
}

extension GLfloat {
    
    public var selfOrZeroIfNegligible: GLfloat {
        get {
            return abs(self) >= 0.1 ? self : 0
        }
    }
    
    public func differenceWith(_ angle: GLfloat) -> GLfloat {
        let difference = angle - self
        let π = GLfloat.pi
        
        if difference < -π {
            return difference + π * 2
        } else if difference > π {
            return difference - π * 2
        } else {
            return difference
        }
    }
    
}
