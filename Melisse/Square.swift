//
//  Square.swift
//  Melisse
//
//  Created by Raphaël Calabro on 04/05/2016.
//  Copyright © 2016 Raphaël Calabro. All rights reserved.
//

import GLKit

struct Square<Coordinate where Coordinate : Numeric> {
    
    var center: Point<Coordinate>
    var size: Size<Coordinate>
    
    var x: Coordinate {
        get { center.x }
    }
    
    var y: Coordinate {
        get { center.y }
    }
    
    var width: Coordinate {
        get { size.width }
    }
    
    var height: Coordinate {
        get { size.height }
    }
    
    var top: Coordinate {
        get {
            return y - height.half
        }
    }
    
    var bottom: Coordinate {
        get {
            return y + height.half
        }
    }
    
    var left: Coordinate {
        get {
            return x - width.half
        }
    }
    
    var right: Coordinate {
        get {
            return x + width.half
        }
    }
    
    init() {
        self.center = Point()
        self.size = Size()
    }
    
    init(square: Square) {
        self.center = square.center
        self.size = square.size
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

extension Square where Coordinate : FloatingPoint {
    
    func rotate(rotation: Coordinate) -> Quadrilateral {
        return rotate(rotation, withPivot: center)
    }
    
    func rotate(rotation: Coordinate, withPivot pivot: Point<Coordinate>) -> Quadrilateral {
        var vertices = [Point<Coordinate>]()
        let reference = Point<Coordinate>(x: pivot.x, y: pivot.y)
        for vertex in [Point<Coordinate>(x: left, y: top), Point<Coordinate>(x: right, y: top), Point<Coordinate>(x: left, y: bottom), Point<Coordinate>(x: right, y: bottom)] {
            let length = vertex.distanceTo(reference)
            let angle: GLfloat = atan2(vertex.y - reference.y, vertex.x - reference.x)
            vertices.append(Point(x: pivot.x + cos(angle + rotation) * length, y: pivot.y + sin(angle + rotation) * length))
        }
        return Quadrilateral(vertices: vertices)
    }
    
}
