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
    let vertexPointer: SurfaceArray
    let colorPointer: SurfaceArray
    
    var count: Int = 0
    
    init(capacity: Int) {
        self.capacity = capacity
        let vertices = capacity * Surfaces.vertexesByQuad
        self.vertexPointer = SurfaceArray(capacity: vertices, coordinates: Surfaces.coordinatesByVertice)
        self.colorPointer = SurfaceArray(capacity: vertices, coordinates: Surfaces.coordinatesByColor)
    }
    
    func draw(at point: Point = Point()) {
        Draws.translateTo(point)
        Draws.drawWithVertexPointer(vertexPointer.memory, colorPointer: colorPointer.memory, count: GLsizei(count * Surfaces.vertexesByQuad))
    }
    
    func coloredQuadrilateral() -> ColoredQuadrilateral {
        #if CHECK_CAPACITY
            if count >= capacity {
                NSLog("coloredQuadrilateral: capacité insuffisante (requis \(count + 1), capacité \(capacity))")
                abort()
            }
        #endif
        let vertexSurface = Surface(memory: vertexPointer.memory, reference: Int(count), coordinates: Surfaces.coordinatesByVertice)
        let colorSurface = Surface(memory: colorPointer.memory, reference: Int(count), coordinates: Surfaces.coordinatesByColor)
        count = count + 1
        return ColoredQuadrilateral(vertexSurface: vertexSurface, colorSurface: colorSurface)
    }
    
}

class ColoredQuadrilateral {
    
    var color: Color? {
        didSet {
            if let color = self.color {
                colorSurface.setColor(color)
            } else {
                colorSurface.clear()
            }
        }
    }
    var quadrilateral: Quadrilateral? {
        didSet {
            if let quadrilateral = self.quadrilateral {
                vertexSurface.setQuadWithQuadrilateral(quadrilateral)
            } else {
                vertexSurface.clear()
            }
        }
    }
    
    let vertexSurface: Surface
    let colorSurface: Surface
    
    init(vertexSurface: Surface, colorSurface: Surface) {
        self.vertexSurface = vertexSurface
        self.colorSurface = colorSurface
    }
    
}