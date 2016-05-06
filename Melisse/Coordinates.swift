//
//  Coordinates.swift
//  Melisse
//
//  Created by Raphaël Calabro on 06/05/2016.
//  Copyright © 2016 Raphaël Calabro. All rights reserved.
//

import Foundation

protocol Coordinates {
    
    associatedtype Coordinate : Numeric
    
    var x: Coordinate { get set }
    var y: Coordinate { get set }
    
}

extension Coordinates {
    
    init() {
        self.x = Coordinate(0)
        self.y = Coordinate(0)
    }
    
    init(x: Coordinate, y: Coordinate) {
        self.x = x
        self.y = y
    }
    
    init<Other where Other : Coordinates, Other.Coordinate == Self.Coordinate>(point: Other) {
        self.x = point.x
        self.y = point.y
    }
    
    init(bottomOfRectangle rectangle: Rectangle<Coordinate>) {
        self.x = rectangle.x
        self.y = rectangle.bottom
    }
    
}

extension Coordinates where Coordinate : FloatingPoint {
    
    func distanceTo<Other where Other : Coordinates, Other.Coordinate == Self.Coordinate>(other: Other) -> Coordinate {
        return Coordinate.distance(x, y1: y, x2: other.x, y2: other.y)
    }
    
    func angleTo<Other where Other : Coordinates, Other.Coordinate == Self.Coordinate>(other: Other) -> Coordinate {
        return Coordinate.atan2(y - other.y, x - other.x)
    }
    
}

func *<FloatingCoordinates, Value where FloatingCoordinates : Coordinates, Value : FloatingPoint, FloatingCoordinates.Coordinate == Value>(left: FloatingCoordinates, right: Value) -> FloatingCoordinates {
    return FloatingCoordinates(x: left.x * right, y: left.y * right)
}

func *<SameCoordinates where SameCoordinates : Coordinates>(left: SameCoordinates, right: SameCoordinates) -> SameCoordinates {
    return SameCoordinates(x: left.x * right.x, y: left.y * right.y)
}

func +<SameCoordinates where SameCoordinates : Coordinates>(left: SameCoordinates, right: SameCoordinates) -> SameCoordinates {
    return SameCoordinates(x: left.x + right.x, y: left.y + right.y)
}

func -<SameCoordinates where SameCoordinates : Coordinates>(left: SameCoordinates, right: SameCoordinates) -> SameCoordinates {
    return SameCoordinates(x: left.x - right.x, y: left.y - right.y)
}

prefix func -<SameCoordinates where SameCoordinates : Coordinates, SameCoordinates.Coordinate : Signed>(point: SameCoordinates) -> SameCoordinates {
    return SameCoordinates(x: -point.x, y: -point.y)
}

func +=<SameCoordinates where SameCoordinates : Coordinates, SameCoordinates.Coordinate : Signed>(inout left: SameCoordinates, right: SameCoordinates) {
    left.x += right.x
    left.y += right.y
}
