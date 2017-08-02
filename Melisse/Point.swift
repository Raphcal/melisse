//
//  Point.swift
//  MeltedIce
//
//  Created by Raphaël Calabro on 28/06/2015.
//  Copyright (c) 2015 Raphaël Calabro. All rights reserved.
//

import GLKit

public struct Point<Coordinate> : Equatable, Hashable where Coordinate : Numeric {
    
    public var x: Coordinate
    public var y: Coordinate
    
    public var description: String {
        get {
            return "point[\(x)x\(y)]"
        }
    }
    
    public var hashValue: Int {
        return x.hashValue * 43 + y.hashValue * 17
    }
    
    public init() {
        self.x = Coordinate(0)
        self.y = Coordinate(0)
    }
    
    public init(x: Coordinate, y: Coordinate) {
        self.x = x
        self.y = y
    }
    
    public init(point: Point) {
        self.x = point.x
        self.y = point.y
    }
    
    public init(bottomOfRectangle rectangle: Rectangle<Coordinate>) {
        self.x = rectangle.x
        self.y = rectangle.bottom
    }
    
}

public extension Point where Coordinate : FloatingPoint {
    
    func distanceTo(_ other: Point<Coordinate>) -> Coordinate {
        return Coordinate.distance(x, y1: y, x2: other.x, y2: other.y)
    }
    
    func angleTo(_ other: Point<Coordinate>) -> Coordinate {
        return Coordinate.atan2(y - other.y, x - other.x)
    }
    
    func floored() -> Point<Coordinate> {
        return Point(x: x.floored, y: y.floored)
    }
    
    func point(distance: Coordinate, angle: Coordinate) -> Point<Coordinate> {
        return Point(x: x + angle.cosinus * distance, y: y + angle.sinus * distance)
    }
    
}

// MARK: - Opérations entre instances de Point

public func ==<Coordinate>(left: Point<Coordinate>, right: Point<Coordinate>) -> Bool {
    return left.x == right.x && left.y == right.y
}

public func !=<Coordinate>(left: Point<Coordinate>, right: Point<Coordinate>) -> Bool {
    return left.x != right.x || left.y != right.y
}

public func *<Coordinate>(left: Point<Coordinate>, right: Coordinate) -> Point<Coordinate> {
    return Point(x: left.x * right, y: left.y * right)
}

public func *<Coordinate>(left: Point<Coordinate>, right: Point<Coordinate>) -> Point<Coordinate> {
    return Point(x: left.x * right.x, y: left.y * right.y)
}

public func +<Coordinate>(left: Point<Coordinate>, right: Point<Coordinate>) -> Point<Coordinate> {
    return Point(x: left.x + right.x, y: left.y + right.y)
}

public func -<Coordinate>(left: Point<Coordinate>, right: Point<Coordinate>) -> Point<Coordinate> {
    return Point(x: left.x - right.x, y: left.y - right.y)
}

public prefix func -<Coordinate>(point: Point<Coordinate>) -> Point<Coordinate> where Coordinate: Signed {
    return Point(x: -point.x, y: -point.y)
}

public func +=<Coordinate>(left: inout Point<Coordinate>, right: Point<Coordinate>) {
    left.x += right.x
    left.y += right.y
}

public func -=<Coordinate>(left: inout Point<Coordinate>, right: Point<Coordinate>) {
    left.x -= right.x
    left.y -= right.y
}

public func *=<Coordinate>(left: inout Point<Coordinate>, right: Point<Coordinate>) {
    left.x *= right.x
    left.y *= right.y
}

public func /=<Coordinate>(left: inout Point<Coordinate>, right: Point<Coordinate>) {
    left.x /= right.x
    left.y /= right.y
}

// MARK: - Opérations entre Point et une coordonnée

public func +<Coordinate>(left: Point<Coordinate>, right: Coordinate) -> Point<Coordinate> {
    return Point(x: left.x + right, y: left.y + right)
}

public func -<Coordinate>(left: Point<Coordinate>, right: Coordinate) -> Point<Coordinate> {
    return Point(x: left.x - right, y: left.y - right)
}

public func -<Coordinate>(left: Coordinate, right: Point<Coordinate>) -> Point<Coordinate> {
    return Point(x: left - right.x, y: left - right.y)
}

public func +=<Coordinate>(left: inout Point<Coordinate>, right: Coordinate) {
    left.x += right
    left.y += right
}

public func -=<Coordinate>(left: inout Point<Coordinate>, right: Coordinate) {
    left.x -= right
    left.y -= right
}

public func *=<Coordinate>(left: inout Point<Coordinate>, right: Coordinate) {
    left.x *= right
    left.y *= right
}

public func /=<Coordinate>(left: inout Point<Coordinate>, right: Coordinate) {
    left.x /= right
    left.y /= right
}

// MARK: Opérations spécifiques

public func %(left: Point<GLfloat>, right: Point<Int>) -> Point<GLfloat> {
    return Point(x: left.x % right.x, y: left.y % right.y)
}
