//
//  Hitbox.swift
//  MeltedIce
//
//  Created by Raphaël Calabro on 29/06/2015.
//  Copyright (c) 2015 Raphaël Calabro. All rights reserved.
//

import GLKit

public protocol Hitbox {
    
    var frame: Rectangle<GLfloat> { get }
    
    func collidesWith(point: Point<GLfloat>) -> Bool
    func collidesWith(other: Hitbox) -> Bool
    
}

public extension Hitbox {
    
    var topHalfHitbox: StaticHitbox {
        get {
            return StaticHitbox(frame: Rectangle(left: frame.left, top: frame.top, width: frame.width, height: frame.height / 2))
        }
    }
    
    func collidesWith(point: Point<GLfloat>) -> Bool {
        return point.x >= frame.left && point.x < frame.right &&
            point.y >= frame.top && point.y < frame.bottom
    }
    
    func collidesWith(rectangle: Rectangle<GLfloat>) -> Bool {
        return collidesWith(StaticHitbox(frame: rectangle))
    }
    
    func collidesWith(other: Hitbox) -> Bool {
        return (frame.x - other.frame.x).absolute <= (frame.width + other.frame.width).half
            && (frame.y - other.frame.y).absolute <= (frame.height + other.frame.height).half
    }
    
}

public struct StaticHitbox : Hitbox {
    
    public var frame: Rectangle<GLfloat>
    
    public init(frame: Rectangle<GLfloat> = Rectangle()) {
        self.frame = frame
    }
    
}

public struct SimpleSpriteHitbox : Hitbox {
    
    public var sprite: Sprite
    
    public var frame: Rectangle<GLfloat> {
        get {
            return sprite.frame
        }
    }
    
    public init(sprite: Sprite = Sprite()) {
        self.sprite = sprite
    }
    
}

public struct SpriteHitbox : Hitbox {
    
    public var sprite: Sprite
    public var frame: Rectangle<GLfloat> {
        get {
            let animationFrameHitbox = sprite.animation.frame.hitbox
            let offsetX = (animationFrameHitbox.x - sprite.frame.width.half) * sprite.direction.value
            let offsetY = animationFrameHitbox.y - sprite.frame.height.half
            return Rectangle(x: sprite.frame.x + offsetX, y: sprite.frame.y + offsetY, width: animationFrameHitbox.width, height: animationFrameHitbox.height)
        }
    }
    
}

public class RotatedHitbox : Hitbox {
    
    public var hitbox: Hitbox
    public var frame: Rectangle<GLfloat>
    
    public init(hitbox: Hitbox) {
        self.hitbox = hitbox
        self.frame = hitbox.frame
    }
    
    public func rotate(rotation: GLfloat, withPivot pivot: Point<GLfloat>) {
        self.frame = hitbox.frame.rotate(rotation, withPivot: pivot).enclosingRectangle()
    }
    
    public func cancelRotation() {
        self.frame = hitbox.frame
    }
    
}
