//
//  Quadrilateral.swift
//  Melisse
//
//  Created by Raphaël Calabro on 04/05/2016.
//  Copyright © 2016 Raphaël Calabro. All rights reserved.
//

import Foundation

struct Quadrilateral<Coordinate where Coordinate : Numeric> {
    
    var topLeft: Point<Coordinate>
    var topRight: Point<Coordinate>
    var bottomLeft: Point<Coordinate>
    var bottomRight: Point<Coordinate>
    
    var left: Coordinate {
        return Coordinate.min(topLeft.x, topRight.x, bottomLeft.x, bottomRight.x)
    }
    
    var right: Coordinate {
        return Coordinate.max(topLeft.x, topRight.x, bottomLeft.x, bottomRight.x)
    }
    
    var top: Coordinate {
        return Coordinate.min(topLeft.y, topRight.y, bottomLeft.y, bottomRight.y)
    }
    
    var bottom: Coordinate {
        return Coordinate.max(topLeft.y, topRight.y, bottomLeft.y, bottomRight.y)
    }
    
    init(rectangle: Rectangle<Coordinate>) {
        self.topLeft = Point(x: rectangle.left, y: rectangle.top)
        self.topRight = Point(x: rectangle.right, y: rectangle.top)
        self.bottomLeft = Point(x: rectangle.left, y: rectangle.bottom)
        self.bottomRight = Point(x: rectangle.right, y: rectangle.bottom)
    }
    
    init(vertices: [Point<Coordinate>]) {
        self.topLeft = vertices[0]
        self.topRight = vertices[1]
        self.bottomLeft = vertices[2]
        self.bottomRight = vertices[3]
    }
    
    init(topLeft: Point<Coordinate>, topRight: Point<Coordinate>, bottomLeft: Point<Coordinate>, bottomRight: Point<Coordinate>) {
        self.topLeft = topLeft
        self.topRight = topRight
        self.bottomLeft = bottomLeft
        self.bottomRight = bottomRight
    }
    
    func enclosingRectangle() -> Rectangle<Coordinate> {
        return Rectangle(left: left, top: top, width: right - left, height: bottom - top)
    }
    
}

func +<Coordinate where Coordinate : Numeric>(left: Quadrilateral<Coordinate>, right: Point<Coordinate>) -> Quadrilateral<Coordinate> {
    return Quadrilateral(topLeft: left.topLeft + right, topRight: left.topRight + right, bottomLeft: left.bottomLeft + right, bottomRight: left.bottomRight + right)
}
