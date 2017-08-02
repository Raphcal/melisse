//
//  Numerics.swift
//  Melisse
//
//  Created by Raphaël Calabro on 04/05/2016.
//  Copyright © 2016 Raphaël Calabro. All rights reserved.
//

import GLKit

public protocol Numeric : Hashable {
    static func +(lhs: Self, rhs: Self) -> Self
    static func -(lhs: Self, rhs: Self) -> Self
    static func *(lhs: Self, rhs: Self) -> Self
    static func /(lhs: Self, rhs: Self) -> Self
    
    static func +=(lhs: inout Self, rhs: Self)
    static func -=(lhs: inout Self, rhs: Self)
    static func *=(lhs: inout Self, rhs: Self)
    static func /=(lhs: inout Self, rhs: Self)
    
    static func >(lhs: Self, rhs: Self) -> Bool
    static func >=(lhs: Self, rhs: Self) -> Bool
    static func <(lhs: Self, rhs: Self) -> Bool
    static func <=(lhs: Self, rhs: Self) -> Bool
    static func ==(lhs: Self, rhs: Self) -> Bool
    static func !=(lhs: Self, rhs: Self) -> Bool
    
    var half: Self { get }
    var absolute: Self { get }
    
    init(_: Int)
    init(_: GLuint)
    init(_: GLshort)
    init(_: GLfloat)
    
    static func min(_ a: Self, _ b: Self, _ c: Self, _ d: Self) -> Self
    static func max(_ a: Self, _ b: Self, _ c: Self, _ d: Self) -> Self
}

public protocol Signed {
    prefix static func -(lhs: Self) -> Self
}

public protocol FloatingPoint: ExpressibleByFloatLiteral {
    static func *(lhs: Self, rhs: GLfloat) -> Self
    static func /(lhs: Self, rhs: GLfloat) -> Self
    
    var squareRoot: Self { get }
    var cosinus: Self { get }
    var sinus: Self { get }
    var floored: Self { get }
    
    static func atan2(_ lhs: Self, _ rhs: Self) -> Self
    static func distance(_ x1: Self, y1: Self, x2: Self, y2: Self) -> Self
}

public protocol Integer: ExpressibleByIntegerLiteral {
}

extension GLfloat : Numeric, Signed, FloatingPoint {
    
    public var half: GLfloat {
        return self / 2
    }
    
    public var absolute: GLfloat {
        return abs(self)
    }
    
    public var squareRoot: GLfloat {
        return sqrt(self)
    }
    
    public var cosinus: GLfloat {
        return cos(self)
    }
    
    public var sinus: GLfloat {
        return sin(self)
    }
    
    public var floored: GLfloat {
        return floor(self)
    }
    
    public static func atan2(_ lhs: GLfloat, _ rhs: GLfloat) -> GLfloat {
        return Darwin.atan2(lhs, rhs)
    }
    
    public static func distance(_ x1: GLfloat, y1: GLfloat, x2: GLfloat, y2: GLfloat) -> GLfloat {
        return simd.distance(float2(x1, y1), float2(x2, y2))
    }
    
    public static func min(_ a: GLfloat, _ b: GLfloat, _ c: GLfloat, _ d: GLfloat) -> GLfloat {
        return Swift.min(a, b, c, d)
    }
    
    public static func max(_ a: GLfloat, _ b: GLfloat, _ c: GLfloat, _ d: GLfloat) -> GLfloat {
        return Swift.max(a, b, c, d)
    }
    
}

public func %(left: GLfloat, right: GLfloat) -> GLfloat {
    let division = left / right
    return (division - floor(division)) * right
}

extension GLshort : Numeric, Integer, Signed {
    
    public var half: GLshort {
        return self / 2
    }
    
    public var absolute: GLshort {
        return abs(self)
    }
    
    public static func min(_ a: GLshort, _ b: GLshort, _ c: GLshort, _ d: GLshort) -> GLshort {
        return Swift.min(a, b, c, d)
    }
    
    public static func max(_ a: GLshort, _ b: GLshort, _ c: GLshort, _ d: GLshort) -> GLshort {
        return Swift.max(a, b, c, d)
    }
    
}

extension GLubyte : Numeric, Integer {
    
    public var half: GLubyte {
        return self / 2
    }
    
    public var absolute: GLubyte {
        return self
    }
    
    public static func min(_ a: GLubyte, _ b: GLubyte, _ c: GLubyte, _ d: GLubyte) -> GLubyte {
        return Swift.min(a, b, c, d)
    }
    
    public static func max(_ a: GLubyte, _ b: GLubyte, _ c: GLubyte, _ d: GLubyte) -> GLubyte {
        return Swift.max(a, b, c, d)
    }
    
}

extension Int : Numeric, Integer, Signed {
    
    /// Tableau des chiffres du nombre.
    public var digits: [Int] {
        get {
            if self <= 0 {
                return [0]
            }
            
            var result = [Int]()
            
            var number = self
            while number > 0 {
                result.append(number % 10)
                number /= 10
            }
            
            return result
        }
    }
    
    public var half: Int {
        return self / 2
    }
    
    public var absolute: Int {
        return abs(self)
    }
    
    public static func min(_ a: Int, _ b: Int, _ c: Int, _ d: Int) -> Int {
        return Swift.min(a, b, c, d)
    }
    
    public static func max(_ a: Int, _ b: Int, _ c: Int, _ d: Int) -> Int {
        return Swift.max(a, b, c, d)
    }
    
}
