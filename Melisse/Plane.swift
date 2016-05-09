//
//  Plane.swift
//  MeltedIce
//
//  Created by Raphaël Calabro on 25/04/2016.
//  Copyright © 2016 Raphaël Calabro. All rights reserved.
//

import GLKit

class Plane {
    
    let capacity: Int
    let vertexPointer: SurfaceArray<GLfloat>
    let colorPointer: SurfaceArray<GLubyte>
    
    var count: Int = 0
    
    init(capacity: Int) {
        self.capacity = capacity
        let vertices = capacity * vertexesByQuad
        self.vertexPointer = SurfaceArray(capacity: vertices, coordinates: coordinatesByVertex)
        self.colorPointer = SurfaceArray(capacity: vertices, coordinates: coordinatesByColor)
    }
    
    func draw(at point: Point<GLfloat> = Point()) {
        Draws.translateTo(point)
        Draws.drawWithVertexPointer(vertexPointer.memory, colorPointer: colorPointer.memory, count: GLsizei(count * vertexesByQuad))
    }
    
    func coloredQuadrilateral() -> ColoredQuadrilateral {
        #if CHECK_CAPACITY
            if count >= capacity {
                NSLog("coloredQuadrilateral: capacité insuffisante (requis \(count + 1), capacité \(capacity))")
                abort()
            }
        #endif
        let vertexSurface = Surface(memory: vertexPointer.memory, reference: Int(count), coordinates: coordinatesByVertex)
        let colorSurface = Surface(memory: colorPointer.memory, reference: Int(count), coordinates: coordinatesByColor)
        count = count + 1
        return ColoredQuadrilateral(vertexSurface: vertexSurface, colorSurface: colorSurface)
    }
    
}

class ColoredQuadrilateral {
    
    var color: Color<GLubyte>? {
        didSet {
            if let color = self.color {
                colorSurface.setColor(color)
            } else {
                colorSurface.clear()
            }
        }
    }
    var quadrilateral: Quadrilateral<GLfloat>? {
        didSet {
            if let quadrilateral = self.quadrilateral {
                vertexSurface.setQuadWith(quadrilateral)
            } else {
                vertexSurface.clear()
            }
        }
    }
    
    let vertexSurface: Surface<GLfloat>
    let colorSurface: Surface<GLubyte>
    
    init(vertexSurface: Surface<GLfloat>, colorSurface: Surface<GLubyte>) {
        self.vertexSurface = vertexSurface
        self.colorSurface = colorSurface
    }
    
}