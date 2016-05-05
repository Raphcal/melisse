//
//  Hitbox.swift
//  MeltedIce
//
//  Created by Raphaël Calabro on 29/06/2015.
//  Copyright (c) 2015 Raphaël Calabro. All rights reserved.
//

import GLKit

protocol Hitbox {
    
    associatedtype Coordinate : Numeric
    
    var x: Coordinate { get set }
    var y: Coordinate { get set }
    
    var width: Coordinate { get set }
    var height: Coordinate { get set }
    
    var top: Coordinate { get set }
    var bottom: Coordinate { get set }
    var left: Coordinate { get set }
    var right: Coordinate { get set }
    
    func collidesWith(point: Point<Coordinate>) -> Bool
    func collidesWith<Other where Other : Hitbox, Self.Coordinate == Other.Coordinate>(other: Other) -> Bool
    
}

extension Hitbox {
    
    func collidesWith(point: Point<Coordinate>) -> Bool {
        return point.x >= self.left && point.x < self.right &&
            point.y >= self.top && point.y < self.bottom
    }
    
    func collidesWith<Other where Other : Hitbox, Other.Coordinate == Self.Coordinate>(other: Other) -> Bool {
        return (x - other.x).absolute <= (width + other.width).half
            && (y - other.y).absolute <= (height + other.height).half
    }
    
}

struct SpriteHitbox : OffsettedRectangular, Hitbox {
    
    var sprite: Sprite
    var offset: Point<GLfloat>
    var size: Size<GLfloat>
    
    var center: Point {
        get { sprite.center }
        set { sprite.center = newValue }
    }
    
}

struct RotatedHitbox<Coordinate, InnerHitbox where Coordinate : Numeric, InnerHitbox : Hitbox, InnerHitbox.Coordinate == RotatedHitbox.Coordinate> : Hitbox {
    
    var hitbox: InnerHitbox
    
    var x: Coordinate
    var y: Coordinate
    
    var width: Coordinate
    var height: Coordinate
    
    var top: Coordinate
    var bottom: Coordinate
    var left: Coordinate
    var right: Coordinate
    
    mutating func rotate(rotation: GLfloat, with pivot: Point<Coordinate>) {
        let left = hitbox.left
        let top = hitbox.top
        let rectangle = Rectangle(left: left, top: top, width: hitbox.right - left, height: hitbox.bottom - top)
        
        let rotatedRectangle = rectangle.rotate(rotation, withPivot: pivot).enclosingRectangle()
        
        self.x = rotatedRectangle.x
        self.y = rotatedRectangle.y
        self.width = rotatedRectangle.width
        self.height = rotatedRectangle.height
        self.top = rotatedRectangle.top
        self.bottom = rotatedRectangle.bottom
        self.left = rotatedRectangle.left
        self.right = rotatedRectangle.right
    }
    
    mutating func restore() {
        self.x = hitbox.x
        self.y = hitbox.y
        self.width = hitbox.width
        self.height = hitbox.height
        self.top = hitbox.top
        self.bottom = hitbox.bottom
        self.left = hitbox.left
        self.right = hitbox.right
    }
    
}
