//
//  Point.swift
//  MeltedIce
//
//  Created by Raphaël Calabro on 28/06/2015.
//  Copyright (c) 2015 Raphaël Calabro. All rights reserved.
//

import GLKit

struct Point {
    
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
    
    init(point: Point) {
        self.x = point.x
        self.y = point.y
    }
    
    init(bottomOfSquare square: Square) {
        self.x = square.x
        self.y = square.bottom
    }
    
}

func * (left: Point, right: GLfloat) -> Point {
    return Point(x: left.x * right, y: left.y * right)
}

func * (left: Point, right: Point) -> Point {
    return Point(x: left.x * right.x, y: left.y * right.y)
}

func + (left: Point, right: Point) -> Point {
    return Point(x: left.x + right.x, y: left.y + right.y)
}

func - (left: Point, right: Point) -> Point {
    return Point(x: left.x - right.x, y: left.y - right.y)
}

prefix func -(point: Point) -> Point {
    return Point(x: -point.x, y: -point.y)
}

func += (inout left: Point, right: Point) {
    left.x += right.x
    left.y += right.y
}

func += (inout left: Sprite, right: Point) {
    left.x += right.x
    left.y += right.y
}
