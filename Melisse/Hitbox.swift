//
//  Hitbox.swift
//  MeltedIce
//
//  Created by Raphaël Calabro on 29/06/2015.
//  Copyright (c) 2015 Raphaël Calabro. All rights reserved.
//

import GLKit

protocol Hitbox {
    
    var frame: Rectangle<GLfloat> { get set }
    var offset: Point<GLfloat> { get }
    
    func collidesWith(point: Point<GLfloat>) -> Bool
    func collidesWith(other: Hitbox) -> Bool
    
}

extension Hitbox {
    
    func collidesWith(point: Point<GLfloat>) -> Bool {
        return point.x >= frame.left && point.x < frame.right &&
            point.y >= frame.top && point.y < frame.bottom
    }
    
    func collidesWith(other: Hitbox) -> Bool {
        return (frame.x - other.frame.x).absolute <= (frame.width + other.frame.width).half
            && (frame.y - other.frame.y).absolute <= (frame.height + other.frame.height).half
    }
    
}

struct SpriteHitbox : Hitbox {
    
    var sprite: Sprite
    var frame: Rectangle<GLfloat>
    
    var offset: Point<GLfloat> {
        get {
            return sprite.center
        }
    }
    
}

/*
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
*/