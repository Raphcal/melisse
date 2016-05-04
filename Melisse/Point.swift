//
//  Spot.swift
//  MeltedIce
//
//  Created by Raphaël Calabro on 28/06/2015.
//  Copyright (c) 2015 Raphaël Calabro. All rights reserved.
//

import GLKit

struct Spot {
    
    var x: GLfloat
    var y: GLfloat
    
    init() {
        self.x = 0
        self.y = 0
    }
    
    init(x: GLfloat, y: GLfloat) {
        self.x = x
        self.y = y
    }
    
    init(point: Spot) {
        self.x = point.x
        self.y = point.y
    }
    
    init(bottomOfSquare square: Square) {
        self.x = square.x
        self.y = square.bottom
    }
    
}

func * (left: Spot, right: GLfloat) -> Spot {
    return Spot(x: left.x * right, y: left.y * right)
}

func * (left: Spot, right: Spot) -> Spot {
    return Spot(x: left.x * right.x, y: left.y * right.y)
}

func + (left: Spot, right: Spot) -> Spot {
    return Spot(x: left.x + right.x, y: left.y + right.y)
}

func - (left: Spot, right: Spot) -> Spot {
    return Spot(x: left.x - right.x, y: left.y - right.y)
}

prefix func -(point: Spot) -> Spot {
    return Spot(x: -point.x, y: -point.y)
}

func += (inout left: Spot, right: Spot) {
    left.x += right.x
    left.y += right.y
}

func += (inout left: Sprite, right: Spot) {
    left.x += right.x
    left.y += right.y
}
