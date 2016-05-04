//
//  Square.swift
//  Melisse
//
//  Created by Raphaël Calabro on 04/05/2016.
//  Copyright © 2016 Raphaël Calabro. All rights reserved.
//

import GLKit

struct Square {
    
    var center: Point
    var size: Size
    
    var x: GLfloat {
        get { center.x }
    }
    
    var y: GLfloat {
        get { center.y }
    }
    
    var width: GLfloat {
        get { size.width }
    }
    
    var height: GLfloat {
        get { size.height }
    }
    
    var top: GLfloat {
        get {
            return y - height / 2
        }
    }
    
    var bottom: GLfloat {
        get {
            return y + height / 2
        }
    }
    
    var left: GLfloat {
        get {
            return x - width / 2
        }
    }
    
    var right: GLfloat {
        get {
            return x + width / 2
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
    
    init(x: GLfloat, y: GLfloat, width: GLfloat, height: GLfloat) {
        self.center = Point(x: x, y: y)
        self.size = Size(width: width, height: height)
    }
    
    init(left: GLfloat, top: GLfloat, width: GLfloat, height: GLfloat) {
        self.center = Point(x: left + width / 2, y: top + height / 2)
        self.size = Size(width: width, height: height)
    }
    
    init(top: GLfloat, bottom: GLfloat, left: GLfloat, right: GLfloat) {
        self.center = Point(x: left + width / 2, y: top + height / 2)
        self.size = Size(width: right - left, height: bottom - top)
    }
    
    func rotate(rotation: GLfloat) -> Quadrilateral {
        return rotate(rotation, withPivot: center)
    }
    
    func rotate(rotation: GLfloat, withPivot pivot: Point) -> Quadrilateral {
        var vertices = [Point]()
        let reference = float2(pivot.x, pivot.y)
        for vertex in [float2(left, top), float2(right, top), float2(left, bottom), float2(right, bottom)] {
            let length = distance(vertex, reference)
            let angle : GLfloat = atan2(vertex.y - reference.y, vertex.x - reference.x)
            vertices.append(Point(x: pivot.x + cos(angle + rotation) * length, y: pivot.y + sin(angle + rotation) * length))
        }
        return Quadrilateral(vertices: vertices)
    }
    
}
