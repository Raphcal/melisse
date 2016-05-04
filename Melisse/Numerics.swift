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
    
    init(_: Int)
    init(_: GLuint)
}

protocol Signed {
    prefix func -(lhs: Self) -> Self
}

protocol FloatingPoint {
    func *(lhs: Self, rhs: GLfloat) -> Self
    func /(lhs: Self, rhs: GLfloat) -> Self
    
    init(_: GLfloat)
}

protocol Integer {
}

extension GLfloat : Numeric, Signed, FloatingPoint {
}

extension GLshort : Numeric, Signed, Integer {
}

extension GLubyte : Numeric, Integer {
}
