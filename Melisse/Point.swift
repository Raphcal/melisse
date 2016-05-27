//
//  Point.swift
//  MeltedIce
//
//  Created by Raphaël Calabro on 28/06/2015.
//  Copyright (c) 2015 Raphaël Calabro. All rights reserved.
//

import GLKit

public struct Point<Coordinate where Coordinate : Numeric> : Equatable {
    
    public var x: Coordinate
    public var y: Coordinate
    
    public var description: String {
        get {
            return "point[\(x)x\(y)]"
        }
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

extension Point where Coordinate : FloatingPoint {
    
    func distanceTo(other: Point<Coordinate>) -> Coordinate {
        return Coordinate.distance(x, y1: y, x2: other.x, y2: other.y)
    }
    
    func angleTo(other: Point<Coordinate>) -> Coordinate {
        return Coordinate.atan2(y - other.y, x - other.x)
    }
    
}

// MARK: - Opérations entre instances de Point

public func ==<Coordinate>(left: Point<Coordinate>, right: Point<Coordinate>) -> Bool {
    return left.x == right.x && left.y == right.y
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

public prefix func -<Coordinate where Coordinate: Signed>(point: Point<Coordinate>) -> Point<Coordinate> {
    return Point(x: -point.x, y: -point.y)
}

public func +=<Coordinate>(inout left: Point<Coordinate>, right: Point<Coordinate>) {
    left.x += right.x
    left.y += right.y
}

public func -=<Coordinate>(inout left: Point<Coordinate>, right: Point<Coordinate>) {
    left.x -= right.x
    left.y -= right.y
}

// MARK: - Opérations entre Point et une coordonée

public func +<Coordinate>(left: Point<Coordinate>, right: Coordinate) -> Point<Coordinate> {
    return Point(x: left.x + right, y: left.y + right)
}

public func -<Coordinate>(left: Point<Coordinate>, right: Coordinate) -> Point<Coordinate> {
    return Point(x: left.x - right, y: left.y - right)
}

public func +=<Coordinate>(inout left: Point<Coordinate>, right: Coordinate) {
    left.x += right
    left.y += right
}

public func -=<Coordinate>(inout left: Point<Coordinate>, right: Coordinate) {
    left.x -= right
    left.y -= right
}
