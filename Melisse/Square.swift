//
//  Square.swift
//  Melisse
//
//  Created by Raphaël Calabro on 04/05/2016.
//  Copyright © 2016 Raphaël Calabro. All rights reserved.
//

import Foundation

struct Square {
    
    var x: GLfloat
    var y: GLfloat
    var width: GLfloat
    var height: GLfloat
    
    var center: Spot {
        get {
            return Spot(x: x, y: y)
        }
        set {
            self.x = newValue.x
            self.y = newValue.y
        }
    }
    
    var topLeft : Spot {
        get {
            return Spot(x: x - width / 2, y: y - height / 2)
        }
        set {
            self.x = newValue.x + width / 2
            self.y = newValue.y + height / 2
        }
    }
    
    var bottomRight : Spot {
        get {
            return Spot(x: x + width / 2, y: y + height / 2)
        }
        set {
            self.x = newValue.x - width / 2
            self.y = newValue.y - height / 2
        }
    }
    
    var size : Spot {
        get {
            return Spot(x: width, y: height)
        }
        set {
            self.width = newValue.x
            self.height = newValue.y
        }
    }
    
    var top : GLfloat {
        get {
            return y - height / 2
        }
    }
    
    var bottom : GLfloat {
        get {
            return y + height / 2
        }
    }
    
    var left : GLfloat {
        get {
            return x - width / 2
        }
    }
    
    var right : GLfloat {
        get {
            return x + width / 2
        }
    }
    
    init() {
        self.x = 0
        self.y = 0
        self.width = 0
        self.height = 0
    }
    
    init(square: Square) {
        self.width = square.width
        self.height = square.height
        
        super.init(point: square)
    }
    
    init(centerX: GLfloat, centerY: GLfloat, width: GLfloat, height: GLfloat) {
        self.width = width
        self.height = height
        
        super.init(x: centerX, y: centerY)
    }
    
    init(left: GLfloat, top: GLfloat, width: GLfloat, height: GLfloat) {
        self.width = width
        self.height = height
        
        super.init(x: left + width / 2, y: top + height / 2)
    }
    
    init(top: GLfloat, bottom: GLfloat, left: GLfloat, right: GLfloat) {
        self.width = right - left
        self.height = bottom - top
        
        super.init(x: left + width / 2, y: top + height / 2)
    }
    
    /// Calcule la rotation à appliquer pour l'angle donné.
    static func rotationForAngle(angle: GLfloat, direction: Direction) -> GLfloat {
        var degree = angle * 180 / GLfloat(M_PI)
        if direction == .Left {
            degree -= 180
        }
        while degree < 0 {
            degree += 360
        }
        let step : GLfloat = 22.5
        degree = nearbyint(degree / step) * step
        return degree * GLfloat(M_PI) / 180
    }
    
    func rotate(rotation: GLfloat) -> Quadrilateral {
        return rotate(rotation, withPivot: self)
    }
    
    func rotate(rotation: GLfloat, withPivot pivot: Spot) -> Quadrilateral {
        var vertices = [Spot]()
        let reference = float2(pivot.x, pivot.y)
        for vertex in [float2(left, top), float2(right, top), float2(left, bottom), float2(right, bottom)] {
            let length = distance(vertex, reference)
            let angle : GLfloat = atan2(vertex.y - reference.y, vertex.x - reference.x)
            vertices.append(Spot(x: pivot.x + cos(angle + rotation) * length, y: pivot.y + sin(angle + rotation) * length))
        }
        return Quadrilateral(vertices: vertices)
    }
    
}