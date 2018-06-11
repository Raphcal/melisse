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

public func square(_ point: Point<GLfloat>) -> Point<GLfloat> {
    return Point(x: point.x * point.x, y: point.y * point.y)
}
	
public func toRadian(_ degree: GLfloat) -> GLfloat {
    return degree * GLfloat.pi / 180
}

public func toDegree(_ radian: GLfloat) -> GLfloat {
    return radian * 180 / GLfloat.pi
}

public func nearestUpperPowerOfTwoFor(_ value: Int) -> Int {
    var powerOfTwo = value - 1
    powerOfTwo |= powerOfTwo >> 1
    powerOfTwo |= powerOfTwo >> 2
    powerOfTwo |= powerOfTwo >> 4
    powerOfTwo |= powerOfTwo >> 8
    powerOfTwo |= powerOfTwo >> 16
    #if CPU_TYPE_ARM64
    powerOfTwo |= powerOfTwo >> 32
    #endif
    return powerOfTwo + 1
}

public func fence<N>(_ lower: N, _ value: N, _ upper: N) -> N where N : Numeric {
    return min(max(value, lower), upper)
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

public func %(left: GLfloat, right: Int) -> GLfloat {
    return left + GLfloat(Int(-left) + Int(left) % right)
}
