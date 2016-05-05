//
//  Rectangle.swift
//  Melisse
//
//  Created by Raphaël Calabro on 04/05/2016.
//  Copyright © 2016 Raphaël Calabro. All rights reserved.
//

import GLKit

protocol Rectangular {
    associatedtype Coordinate : Numeric
    
    var center: Point<Coordinate> { get set }
    var size: Size<Coordinate> { get set }
    
    var x: Coordinate { get set }
    
    var y: Coordinate { get set }
    
    var width: Coordinate { get set }
    
    var height: Coordinate { get set }
    
    var top: Coordinate { get set }
    
    var bottom: Coordinate { get set }
    
    var left: Coordinate { get set }
    
    var right: Coordinate { get set }
    
}

extension Rectangular {
    
    var x: Coordinate {
        get { center.x }
        set { center.x = newValue }
    }
    
    var y: Coordinate {
        get { center.y }
        set { center.y = newValue }
    }
    
    var width: Coordinate {
        get { size.width }
        set { size.width = newValue }
    }
    
    var height: Coordinate {
        get { size.height }
        set { size.height = newValue }
    }
    
    var top: Coordinate {
        get { return center.y - height.half }
        set { center.y = newValue + height.half }
    }
    
    var bottom: Coordinate {
        get { return center.y + height.half }
        set { center.y = newValue - height.half }
    }
    
    var left: Coordinate {
        get { return center.x - width.half }
        set { center.x = newValue + width.half }
    }
    
    var right: Coordinate {
        get { return center.x + width.half }
        set { center.x = newValue - width.half }
    }
    
}

struct Rectangle<Coordinate where Coordinate : Numeric> : Rectangular {
    
    var center: Point<Coordinate>
    var size: Size<Coordinate>
    
    init() {
        self.center = Point()
        self.size = Size()
    }
    
    init(rectangle: Rectangle) {
        self.center = rectangle.center
        self.size = rectangle.size
    }
    
    init(x: Coordinate, y: Coordinate, width: Coordinate, height: Coordinate) {
        self.center = Point(x: x, y: y)
        self.size = Size(width: width, height: height)
    }
    
    init(left: Coordinate, top: Coordinate, width: Coordinate, height: Coordinate) {
        self.center = Point(x: left + width.half, y: top + height.half)
        self.size = Size(width: width, height: height)
    }
    
    init(top: Coordinate, bottom: Coordinate, left: Coordinate, right: Coordinate) {
        self.center = Point(x: (left + right).half, y: (top + bottom).half)
        self.size = Size(width: right - left, height: bottom - top)
    }

}

extension Rectangle where Coordinate : FloatingPoint {
    
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
