//
//  ColorQuadrilateral.swift
//  Melisse
//
//  Created by Raphaël Calabro on 10/05/2016.
//  Copyright © 2016 Raphaël Calabro. All rights reserved.
//

import GLKit

struct ColoredQuadrilateral {
    
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