//
//  Numerics.swift
//  Melisse
//
//  Created by Raphaël Calabro on 04/05/2016.
//  Copyright © 2016 Raphaël Calabro. All rights reserved.
//

import GLKit

public protocol Numeric {
    func +(lhs: Self, rhs: Self) -> Self
    func -(lhs: Self, rhs: Self) -> Self
    func *(lhs: Self, rhs: Self) -> Self
    func /(lhs: Self, rhs: Self) -> Self
    
    func +=(inout lhs: Self, rhs: Self)
    
    func >(lhs: Self, rhs: Self) -> Bool
    func >=(lhs: Self, rhs: Self) -> Bool
    func <(lhs: Self, rhs: Self) -> Bool
    func <=(lhs: Self, rhs: Self) -> Bool
    func ==(lhs: Self, rhs: Self) -> Bool
    
    var half: Self { get }
    var absolute: Self { get }
    
    init(_: Int)
    init(_: GLuint)
    init(_: GLshort)
    init(_: GLfloat)
    
    static func min(a: Self, _ b: Self, _ c: Self, _ d: Self) -> Self
    static func max(a: Self, _ b: Self, _ c: Self, _ d: Self) -> Self
}

public protocol Signed {
    prefix func -(lhs: Self) -> Self
}

public protocol FloatingPoint {
    func *(lhs: Self, rhs: GLfloat) -> Self
    func /(lhs: Self, rhs: GLfloat) -> Self
    
    var squareRoot: Self { get }
    var cosinus: Self { get }
    var sinus: Self { get }
    
    static func atan2(lhs: Self, _ rhs: Self) -> Self
    static func distance(x1: Self, y1: Self, x2: Self, y2: Self) -> Self
}

public protocol Integer {
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
    
    public static func atan2(lhs: GLfloat, _ rhs: GLfloat) -> GLfloat {
        return Darwin.atan2(lhs, rhs)
    }
    
    public static func distance(x1: GLfloat, y1: GLfloat, x2: GLfloat, y2: GLfloat) -> GLfloat {
        return simd.distance(float2(x1, y1), float2(x2, y2))
    }
    
    public static func min(a: GLfloat, _ b: GLfloat, _ c: GLfloat, _ d: GLfloat) -> GLfloat {
        return Swift.min(a, b, c, d)
    }
    
    public static func max(a: GLfloat, _ b: GLfloat, _ c: GLfloat, _ d: GLfloat) -> GLfloat {
        return Swift.max(a, b, c, d)
    }
    
}

public func %(left: GLfloat, right: GLfloat) -> GLfloat {
    let division = left / right
    return (division - floor(division)) * right
}

extension GLshort : Numeric, Signed, Integer {
    
    public var half: GLshort {
        return self / 2
    }
    
    public var absolute: GLshort {
        return abs(self)
    }
    
    public static func min(a: GLshort, _ b: GLshort, _ c: GLshort, _ d: GLshort) -> GLshort {
        return Swift.min(a, b, c, d)
    }
    
    public static func max(a: GLshort, _ b: GLshort, _ c: GLshort, _ d: GLshort) -> GLshort {
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
    
    public static func min(a: GLubyte, _ b: GLubyte, _ c: GLubyte, _ d: GLubyte) -> GLubyte {
        return Swift.min(a, b, c, d)
    }
    
    public static func max(a: GLubyte, _ b: GLubyte, _ c: GLubyte, _ d: GLubyte) -> GLubyte {
        return Swift.max(a, b, c, d)
    }
    
}

/// Ajout d'une fonction permettant d'accéder aux chiffres d'un entier.
public extension Int {
    
    /// Tableau des chiffres du nombre.
    var digits: [Int] {
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
    
}
