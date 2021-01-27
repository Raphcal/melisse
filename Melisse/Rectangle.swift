//
//  Rectangle.swift
//  Melisse
//
//  Created by Raphaël Calabro on 04/05/2016.
//  Copyright © 2016 Raphaël Calabro. All rights reserved.
//

import GLKit

public protocol Rectangular {
    
    associatedtype Coordinate : Numeric
    
    var center: Point<Coordinate> { get }
    var size: Size<Coordinate> { get }
    
}

public extension Rectangular {
    
    var x: Coordinate {
        get { return center.x }
    }
    
    var y: Coordinate {
        get { return center.y }
    }
    
    var width: Coordinate {
        get { return size.width }
    }
    
    var height: Coordinate {
        get { return size.height }
    }
    
    var top: Coordinate {
        get { return center.y - size.height.half }
    }
    
    var bottom: Coordinate {
        get { return center.y + size.height.half }
    }
    
    var left: Coordinate {
        get { return center.x - size.width.half }
    }
    
    var right: Coordinate {
        get { return center.x + size.width.half }
    }
    
}

public protocol MovableRectangle : Rectangular {
    
    var center: Point<Coordinate> { get set }
    var size: Size<Coordinate> { get }
    
}

public extension MovableRectangle {
    
    var topLeft: Point<Coordinate> {
        get { return Point(x: left, y: top) }
        set { center = Point(x: newValue.x + size.width.half, y: newValue.y + size.height.half) }
    }
    
    var x: Coordinate {
        get { return center.x }
        set { center.x = newValue }
    }
    
    var y: Coordinate {
        get { return center.y }
        set { center.y = newValue }
    }
    
    var top: Coordinate {
        get { return center.y - size.height.half }
        set { center.y = newValue + size.height.half }
    }
    
    var bottom: Coordinate {
        get { return center.y + size.height.half }
        set { center.y = newValue - size.height.half }
    }
    
    var left: Coordinate {
        get { return center.x - size.width.half }
        set { center.x = newValue + size.width.half }
    }
    
    var right: Coordinate {
        get { return center.x + size.width.half }
        set { center.x = newValue - size.width.half }
    }
    
}

public protocol ResizableRectangle : Rectangular {
    
    var center: Point<Coordinate> { get }
    var size: Size<Coordinate> { get set }
    
}

public extension ResizableRectangle {
    
    var width: Coordinate {
        get { return size.width }
        set { size.width = newValue }
    }
    
    var height: Coordinate {
        get { return size.height }
        set { size.height = newValue }
    }
    
}

public struct Rectangle<Coordinate> : MovableRectangle, ResizableRectangle, Equatable, Hashable where Coordinate : Numeric {

    public var center: Point<Coordinate>
    public var size: Size<Coordinate>

    public init(center: Point<Coordinate> = Point(), size: Size<Coordinate> = Size()) {
        self.center = center
        self.size = size
    }

    public init(other: Rectangle<Coordinate>) {
        self.center = other.center
        self.size = other.size
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

    public func hash(into hasher: inout Hasher) {
        hasher.combine(center)
        hasher.combine(size)
    }

}

public func ==<Coordinate>(left: Rectangle<Coordinate>, right: Rectangle<Coordinate>) -> Bool {
    return left.center == right.center && left.size == right.size
}

public func *<Coordinate>(left: Rectangle<Coordinate>, right: Coordinate) -> Rectangle<Coordinate> {
    return Rectangle(center: left.center * right, size: left.size * right)
}

public extension Rectangular where Coordinate : FloatingPoint {
    
    func rotate(_ rotation: Coordinate) -> Quadrilateral<Coordinate> {
        return rotate(rotation, withPivot: center)
    }
    
    func rotate(_ rotation: Coordinate, withPivot pivot: Point<Coordinate>) -> Quadrilateral<Coordinate> {
        var vertices = [Point<Coordinate>]()
        for vertex in [Point<Coordinate>(x: left, y: top), Point<Coordinate>(x: right, y: top), Point<Coordinate>(x: left, y: bottom), Point<Coordinate>(x: right, y: bottom)] {
            let length = vertex.distanceTo(pivot)
            let angle = vertex.angleTo(pivot)
            vertices.append(Point(x: pivot.x + (angle + rotation).cosinus * length, y: pivot.y + (angle + rotation).sinus * length))
        }
        return Quadrilateral<Coordinate>(vertices: vertices)
    }
    
    func floored() -> Rectangle<Coordinate> {
        return Rectangle(center: center.floored(), size: size.floored())
    }
    
}
