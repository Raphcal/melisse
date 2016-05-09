//
//  Rectangle.swift
//  Melisse
//
//  Created by Raphaël Calabro on 04/05/2016.
//  Copyright © 2016 Raphaël Calabro. All rights reserved.
//

import GLKit

public struct Rectangle<Coordinate where Coordinate : Numeric> : Equatable {
    
    public var center: Point<Coordinate>
    public var size: Size<Coordinate>
    
    public var topLeft: Point<Coordinate> {
        get { return Point(x: left, y: top) }
        set { center = Point(x: topLeft.x + width.half, y: topLeft.y + height.half) }
    }
    
    public var x: Coordinate {
        get { return center.x }
        set { center.x = newValue }
    }
    
    public var y: Coordinate {
        get { return center.y }
        set { center.y = newValue }
    }
    
    public var width: Coordinate {
        get { return size.width }
        set { size.width = newValue }
    }
    
    public var height: Coordinate {
        get { return size.height }
        set { size.height = newValue }
    }
    
    public var top: Coordinate {
        get { return center.y - height.half }
        set { center.y = newValue + height.half }
    }
    
    public var bottom: Coordinate {
        get { return center.y + height.half }
        set { center.y = newValue - height.half }
    }
    
    public var left: Coordinate {
        get { return center.x - width.half }
        set { center.x = newValue + width.half }
    }
    
    public var right: Coordinate {
        get { return center.x + width.half }
        set { center.x = newValue - width.half }
    }
    
    public init() {
        self.center = Point()
        self.size = Size()
    }
    
    public init(other: Rectangle<Coordinate>) {
        self.center = other.center
        self.size = other.size
    }
    
    public init(center: Point<Coordinate>, size: Size<Coordinate>) {
        self.center = center
        self.size = size
    }
    
    public init(x: Coordinate, y: Coordinate, width: Coordinate, height: Coordinate) {
        self.center = Point(x: x, y: y)
        self.size = Size(width: width, height: height)
    }
    
    public init(left: Coordinate, top: Coordinate, width: Coordinate, height: Coordinate) {
        self.center = Point(x: left + width.half, y: top + height.half)
        self.size = Size(width: width, height: height)
    }
    
    public init(top: Coordinate, bottom: Coordinate, left: Coordinate, right: Coordinate) {
        self.center = Point(x: (left + right).half, y: (top + bottom).half)
        self.size = Size(width: right - left, height: bottom - top)
    }

}

public func ==<Coordinate>(left: Rectangle<Coordinate>, right: Rectangle<Coordinate>) -> Bool {
    return left.center == right.center && left.size == right.size
}

public extension Rectangle where Coordinate : FloatingPoint {
    
    func rotate(rotation: Coordinate) -> Quadrilateral<Coordinate> {
        return rotate(rotation, withPivot: center)
    }
    
    func rotate(rotation: Coordinate, withPivot pivot: Point<Coordinate>) -> Quadrilateral<Coordinate> {
        var vertices = [Point<Coordinate>]()
        let reference = Point<Coordinate>(x: pivot.x, y: pivot.y)
        for vertex in [Point<Coordinate>(x: left, y: top), Point<Coordinate>(x: right, y: top), Point<Coordinate>(x: left, y: bottom), Point<Coordinate>(x: right, y: bottom)] {
            let length = vertex.distanceTo(reference)
            let angle = vertex.angleTo(reference)
            vertices.append(Point(x: pivot.x + (angle + rotation).cosinus * length, y: pivot.y + (angle + rotation).sinus * length))
        }
        return Quadrilateral<Coordinate>(vertices: vertices)
    }
    
}
