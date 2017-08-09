//
//  Size.swift
//  Melisse
//
//  Created by Raphaël Calabro on 04/05/2016.
//  Copyright © 2016 Raphaël Calabro. All rights reserved.
//

import Foundation

public struct Size<Coordinate> : Equatable, Hashable where Coordinate : Numeric {
    
    public var width: Coordinate
    public var height: Coordinate
    
    public var description: String {
        get {
            return "size[\(width)x\(height)]"
        }
    }
    
    public var hashValue: Int {
        return width.hashValue &* 47 &+ height.hashValue &* 23
    }
    
    public init() {
        self.width = Coordinate(0)
        self.height = Coordinate(0)
    }
    
    public init(width: Coordinate, height: Coordinate) {
        self.width = width
        self.height = height
    }
    
}

public extension Size where Coordinate : FloatingPoint {
    
    func floored() -> Size<Coordinate> {
        return Size(width: width.floored, height: height.floored)
    }
    
}

public func ==<Coordinate>(left: Size<Coordinate>, right: Size<Coordinate>) -> Bool {
    return left.width == right.width && left.height == right.height
}

public func +<Coordinate>(left: Size<Coordinate>, right: Coordinate) -> Size<Coordinate> {
    return Size(width: left.width + right, height: left.height + right)
}

public func -<Coordinate>(left: Size<Coordinate>, right: Coordinate) -> Size<Coordinate> {
    return Size(width: left.width - right, height: left.height - right)
}

public func *<Coordinate>(left: Size<Coordinate>, right: Coordinate) -> Size<Coordinate> {
    return Size(width: left.width * right, height: left.height * right)
}

public func /<Coordinate>(left: Size<Coordinate>, right: Coordinate) -> Size<Coordinate> {
    return Size(width: left.width / right, height: left.height / right)
}
