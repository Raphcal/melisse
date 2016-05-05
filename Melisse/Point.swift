//
//  Point.swift
//  MeltedIce
//
//  Created by Raphaël Calabro on 28/06/2015.
//  Copyright (c) 2015 Raphaël Calabro. All rights reserved.
//

import GLKit

struct Point<Coordinate where Coordinate : Numeric> {
    
    var x: Coordinate
    var y: Coordinate
    
    init() {
        self.x = Coordinate(0)
        self.y = Coordinate(0)
    }
    
    init(x: Coordinate, y: Coordinate) {
        self.x = x
        self.y = y
    }
    
    init(point: Point) {
        self.x = point.x
        self.y = point.y
    }
    
    init(bottomOfRectangle rectangle: Rectangle<Coordinate>) {
        self.x = rectangle.x
        self.y = rectangle.bottom
    }
    
}

extension Point where Coordinate : FloatingPoint {
    
    func distanceTo(other: Point<Coordinate>) -> Coordinate {
        return Coordinate.distance(x, y1: y, x2: other.x, y2: other.y)
    }
    
    func angleTo(other: Point<Coordinate>) -> Coordinate {
        return Coordinate.atan2(y - other.y, x - other.x)
    }
    
}

func *<Coordinate where Coordinate: FloatingPoint>(left: Point<Coordinate>, right: GLfloat) -> Point<Coordinate> {
    return Point(x: left.x * right, y: left.y * right)
}

func *<Coordinate>(left: Point<Coordinate>, right: Point<Coordinate>) -> Point<Coordinate> {
    return Point(x: left.x * right.x, y: left.y * right.y)
}

func +<Coordinate>(left: Point<Coordinate>, right: Point<Coordinate>) -> Point<Coordinate> {
    return Point(x: left.x + right.x, y: left.y + right.y)
}

func -<Coordinate>(left: Point<Coordinate>, right: Point<Coordinate>) -> Point<Coordinate> {
    return Point(x: left.x - right.x, y: left.y - right.y)
}

prefix func -<Coordinate where Coordinate: Signed>(point: Point<Coordinate>) -> Point<Coordinate> {
    return Point(x: -point.x, y: -point.y)
}

func +=<Coordinate>(inout left: Point<Coordinate>, right: Point<Coordinate>) {
    left.x += right.x
    left.y += right.y
}
