//
//  Hitbox.swift
//  MeltedIce
//
//  Created by Raphaël Calabro on 29/06/2015.
//  Copyright (c) 2015 Raphaël Calabro. All rights reserved.
//

import GLKit

protocol Hitbox {
    
    var frame: Rectangle<GLfloat> { get }
    
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
    var frame: Rectangle<GLfloat> {
        get {
            let animationFrameHitbox = sprite.animation.frame.hitbox
            let offsetX = (animationFrameHitbox.x - sprite.frame.width.half) * sprite.direction.value
            let offsetY = animationFrameHitbox.y - sprite.frame.height.half
            return Rectangle(x: sprite.frame.x + offsetX, y: sprite.frame.y + offsetY, width: animationFrameHitbox.width, height: animationFrameHitbox.height)
        }
    }
    
}

struct RotatedHitbox : Hitbox {
    
    var hitbox: Hitbox
    var frame: Rectangle<GLfloat>
    
    init(hitbox: Hitbox) {
        self.hitbox = hitbox
        self.frame = hitbox.frame
    }
    
    mutating func rotate(rotation: GLfloat, withPivot pivot: Point<GLfloat>) {
        self.frame = hitbox.frame.rotate(rotation, withPivot: pivot).enclosingRectangle()
    }
    
    mutating func cancelRotation() {
        self.frame = hitbox.frame
    }
    
}
