//
//  Rectangular.swift
//  Melisse
//
//  Created by Raphaël Calabro on 05/05/2016.
//  Copyright © 2016 Raphaël Calabro. All rights reserved.
//

import Foundation

protocol Rectangular : Coordinates, Size {
    
    associatedtype Coordinate : Numeric
    
    var top: Coordinate { get set }
    var bottom: Coordinate { get set }
    var left: Coordinate { get set }
    var right: Coordinate { get set }
    
}

extension Rectangular {
    
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
    
    init() {
        self.center = Point()
        self.size = Size()
    }
    
    init<Other where Other : Rectangular, Other.Coordinate == Self.Coordinate>(other: Other) {
        self.center = other.center
        self.size = other.size
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

extension Rectangular where Coordinate : FloatingPoint {
    
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
