//
//  Numerics.swift
//  Melisse
//
//  Created by Raphaël Calabro on 04/05/2016.
//  Copyright © 2016 Raphaël Calabro. All rights reserved.
//

import Foundation

protocol Numeric {
    func +(lhs: Self, rhs: Self) -> Self
    func -(lhs: Self, rhs: Self) -> Self
    func *(lhs: Self, rhs: Self) -> Self
    func /(lhs: Self, rhs: Self) -> Self
    
    func +=(inout lhs: Self, rhs: Self)
    
    var half: Self { get }
    
    init(_: Int)
    init(_: GLuint)
}

protocol Signed {
    prefix func -(lhs: Self) -> Self
}

protocol FloatingPoint {
    func *(lhs: Self, rhs: GLfloat) -> Self
    func /(lhs: Self, rhs: GLfloat) -> Self
    
    var floatValue: GLfloat { get }
    
    init(_: GLfloat)
}

protocol Integer {
}

extension GLfloat : Numeric, Signed, FloatingPoint {
    
    var half: GLfloat {
        return self / 2
    }
    
    // FIXME: Faire mieux.
    var floatValue: GLfloat {
        return self
    }
    
}

extension GLshort : Numeric, Signed, Integer {
    
    var half: GLshort {
        return self / 2
    }
    
}

extension GLubyte : Numeric, Integer {
    
    var half: GLubyte {
        return self / 2
    }
    
}
