//
//  ColoredQuadrilateral.swift
//  Melisse
//
//  Created by Raphaël Calabro on 10/05/2016.
//  Copyright © 2016 Raphaël Calabro. All rights reserved.
//

import GLKit

public struct ColoredQuadrilateral {
    
    public var color: Color<GLubyte>? {
        didSet {
            if let color = self.color {
                colorSurface.setColor(color)
            } else {
                colorSurface.clear()
            }
        }
    }
    public var gradient: Gradient<GLubyte>? {
        didSet {
            if let gradient = self.gradient {
                colorSurface.setGradient(gradient)
            } else {
                colorSurface.clear()
            }
        }
    }
    public var quadrilateral: Quadrilateral<GLfloat>? {
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
    
    public init(vertexSurface: Surface<GLfloat>, colorSurface: Surface<GLubyte>) {
        self.vertexSurface = vertexSurface
        self.colorSurface = colorSurface
    }
    
}
