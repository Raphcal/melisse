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
    
    func collides(with point: Point<GLfloat>) -> Bool
    func collides(with other: Hitbox) -> Bool
    
}

public extension Hitbox {
    
    var topHalfHitbox: StaticHitbox {
        get {
            return StaticHitbox(frame: Rectangle(left: frame.left, top: frame.top, width: frame.width, height: frame.height / 2))
        }
    }
    
    var bottomHalfHitbox: StaticHitbox {
        get {
            let halfHeight = frame.height / 2
            return StaticHitbox(frame: Rectangle(left: frame.left, top: frame.top + halfHeight, width: frame.width, height: halfHeight))
        }
    }
    
    func collides(with point: Point<GLfloat>) -> Bool {
        return point.x >= frame.left && point.x < frame.right &&
            point.y >= frame.top && point.y < frame.bottom
    }
    
    func collides(with rectangle: Rectangle<GLfloat>) -> Bool {
        return collides(with: StaticHitbox(frame: rectangle))
    }
    
    func collides(with other: Hitbox) -> Bool {
        let x = (frame.x - other.frame.x).absolute <= (frame.width + other.frame.width).half
        let y = (frame.y - other.frame.y).absolute <= (frame.height + other.frame.height).half
        return x && y
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
    
    public func rotate(_ rotation: GLfloat, withPivot pivot: Point<GLfloat>) {
        self.frame = hitbox.frame.rotate(rotation, withPivot: pivot).enclosingRectangle()
    }
    
    public func cancelRotation() {
        self.frame = hitbox.frame
    }
    
}
