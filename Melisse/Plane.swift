//
//  Plane.swift
//  MeltedIce
//
//  Created by Raphaël Calabro on 25/04/2016.
//  Copyright © 2016 Raphaël Calabro. All rights reserved.
//

import GLKit

public class Plane {
    
    let capacity: Int
    let vertexPointer: SurfaceArray<GLfloat>
    let colorPointer: SurfaceArray<GLubyte>
    
    public var count: Int = 0
    
    public var isEmpty: Bool {
        return count == 0
    }
    
    public init(capacity: Int, vertexPointer: SurfaceArray<GLfloat>? = nil, colorPointer: SurfaceArray<GLubyte>? = nil) {
        self.capacity = capacity
        let vertices = capacity * vertexesByQuad
        self.vertexPointer = vertexPointer ?? SurfaceArray(capacity: vertices, coordinates: coordinatesByVertex)
        self.colorPointer = colorPointer ?? SurfaceArray(capacity: vertices, coordinates: coordinatesByColor)
    }
    
    public func draw(at point: Point<GLfloat> = Point()) {
        if isEmpty {
            return
        }
        Draws.translateTo(point)
        Draws.drawWith(vertexPointer.memory, colorPointer: colorPointer.memory, count: GLsizei(count * vertexesByQuad))
    }
    
    public func coloredQuadrilateral() -> ColoredQuadrilateral {
        #if CHECK_CAPACITY
            if count >= capacity {
                NSLog("coloredQuadrilateral: capacité insuffisante (requis \(count + 1), capacité \(capacity))")
                abort()
            }
        #endif
        
        let vertexSurface = vertexPointer.surface(at: count)
        let colorSurface = colorPointer.surface(at: count)
        count = count + 1
        return ColoredQuadrilateral(vertexSurface: vertexSurface, colorSurface: colorSurface)
    }
    
    public func release(quadrilateral: ColoredQuadrilateral) {
        // TODO: Utiliser une reference pool ?
    }
    
}
