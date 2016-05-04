//
//  Quadrilateral.swift
//  Melisse
//
//  Created by Raphaël Calabro on 04/05/2016.
//  Copyright © 2016 Raphaël Calabro. All rights reserved.
//

import Foundation

struct Quadrilateral {
    
    var topLeft: Point
    var topRight: Point
    var bottomLeft: Point
    var bottomRight: Point
    
    var left: GLfloat {
        return min(topLeft.x, topRight.x, bottomLeft.x, bottomRight.x)
    }
    
    var right: GLfloat {
        return max(topLeft.x, topRight.x, bottomLeft.x, bottomRight.x)
    }
    
    var top: GLfloat {
        return min(topLeft.y, topRight.y, bottomLeft.y, bottomRight.y)
    }
    
    var bottom: GLfloat {
        return max(topLeft.y, topRight.y, bottomLeft.y, bottomRight.y)
    }
    
    init(square: Square) {
        self.topLeft = Point(x: square.left, y: square.top)
        self.topRight = Point(x: square.right, y: square.top)
        self.bottomLeft = Point(x: square.left, y: square.bottom)
        self.bottomRight = Point(x: square.right, y: square.bottom)
    }
    
    init(vertices: [Point]) {
        self.topLeft = vertices[0]
        self.topRight = vertices[1]
        self.bottomLeft = vertices[2]
        self.bottomRight = vertices[3]
    }
    
    init(topLeft: Point, topRight: Point, bottomLeft: Point, bottomRight: Point) {
        self.topLeft = topLeft
        self.topRight = topRight
        self.bottomLeft = bottomLeft
        self.bottomRight = bottomRight
    }
    
    func enclosingSquare() -> Square {
        return Square(left: left, top: top, width: right - left, height: bottom - top)
    }
    
}

func +(left: Quadrilateral, right: Point) -> Quadrilateral {
    return Quadrilateral(topLeft: left.topLeft + right, topRight: left.topRight + right, bottomLeft: left.bottomLeft + right, bottomRight: left.bottomRight + right)
}
