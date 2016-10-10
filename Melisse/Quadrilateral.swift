//
//  Quadrilateral.swift
//  Melisse
//
//  Created by Raphaël Calabro on 04/05/2016.
//  Copyright © 2016 Raphaël Calabro. All rights reserved.
//

import Foundation

public struct Quadrilateral<Coordinate> : Equatable where Coordinate : Numeric {
    
    public var topLeft: Point<Coordinate>
    public var topRight: Point<Coordinate>
    public var bottomLeft: Point<Coordinate>
    public var bottomRight: Point<Coordinate>
    
    public var left: Coordinate {
        return Coordinate.min(topLeft.x, topRight.x, bottomLeft.x, bottomRight.x)
    }
    
    public var right: Coordinate {
        return Coordinate.max(topLeft.x, topRight.x, bottomLeft.x, bottomRight.x)
    }
    
    public var top: Coordinate {
        return Coordinate.min(topLeft.y, topRight.y, bottomLeft.y, bottomRight.y)
    }
    
    public var bottom: Coordinate {
        return Coordinate.max(topLeft.y, topRight.y, bottomLeft.y, bottomRight.y)
    }
    
    public init(rectangle: Rectangle<Coordinate>) {
        self.topLeft = Point(x: rectangle.left, y: rectangle.top)
        self.topRight = Point(x: rectangle.right, y: rectangle.top)
        self.bottomLeft = Point(x: rectangle.left, y: rectangle.bottom)
        self.bottomRight = Point(x: rectangle.right, y: rectangle.bottom)
    }
    
    public init(vertices: [Point<Coordinate>]) {
        self.topLeft = vertices[0]
        self.topRight = vertices[1]
        self.bottomLeft = vertices[2]
        self.bottomRight = vertices[3]
    }
    
    public init(topLeft: Point<Coordinate>, topRight: Point<Coordinate>, bottomLeft: Point<Coordinate>, bottomRight: Point<Coordinate>) {
        self.topLeft = topLeft
        self.topRight = topRight
        self.bottomLeft = bottomLeft
        self.bottomRight = bottomRight
    }
    
    public func enclosingRectangle() -> Rectangle<Coordinate> {
        return Rectangle(left: left, top: top, width: right - left, height: bottom - top)
    }
    
}

public func ==<Coordinate>(left: Quadrilateral<Coordinate>, right: Quadrilateral<Coordinate>) -> Bool where Coordinate : Numeric {
    return left.topLeft == right.topLeft
        && left.topRight == right.topRight
        && left.bottomLeft == right.bottomLeft
        && left.bottomRight == right.bottomRight
}

public func +<Coordinate>(left: Quadrilateral<Coordinate>, right: Point<Coordinate>) -> Quadrilateral<Coordinate> where Coordinate : Numeric {
    return Quadrilateral(topLeft: left.topLeft + right, topRight: left.topRight + right, bottomLeft: left.bottomLeft + right, bottomRight: left.bottomRight + right)
}
