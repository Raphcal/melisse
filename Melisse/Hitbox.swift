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

extension Rectangle : Hitbox {
}

/// Zone de collision.
class SimpleHitbox : Hitbox {
    
    /// Référence vers l'objet représentant le centre de la hitbox.
    let center : Point
    
    /// Décalage par rapport au centre du sprite. Un centre de [0, 2] aura les coordonées sprite.x, sprite.y + 2.
    let offset : Point
    
    var x : GLfloat {
        return center.x + offset.x
    }
    
    var y : GLfloat {
        return center.y + offset.y
    }
    
    /// Largeur de la hitbox.
    var width : GLfloat
    
    /// Hauteur de la hitbox.
    var height : GLfloat
    
    var top : GLfloat {
        get {
            return center.y + offset.y - height / 2
        }
    }
    
    var bottom : GLfloat {
        get {
            return center.y + offset.y + height / 2
        }
    }
    
    var left : GLfloat {
        get {
            return center.x + offset.x - width / 2
        }
    }
    
    var right : GLfloat {
        get {
            return center.x + offset.x + width / 2
        }
    }
    
    init() {
        self.center = Point()
        self.offset = Point()
        self.width = 0
        self.height = 0
    }
    
    init(rectangle: Rectangle) {
        self.center = rectangle
        self.offset = Point()
        self.width = rectangle.width
        self.height = rectangle.height
    }
    
    init(center: Point, width: GLfloat, height: GLfloat) {
        self.center = center
        self.offset = Point()
        self.width = width
        self.height = height
    }
    
    init(center: Point, offset: Point, width: GLfloat, height: GLfloat) {
        self.center = center
        self.offset = offset
        self.width = width
        self.height = height
    }
    
}

/// Hitbox attachée à un sprite.
class SpriteHitbox : Hitbox {
    
    /// Référence vers l'objet représentant le centre de la hitbox.
    let sprite : Sprite
    
    var x : GLfloat {
        get {
            return sprite.x + offsetX
        }
    }
    
    var y : GLfloat {
        get {
            return sprite.y + offsetY
        }
    }
    
    var width : GLfloat {
        get {
            return sprite.animation.frame.hitbox.width
        }
    }
    
    var height : GLfloat {
        get {
            return sprite.animation.frame.hitbox.height
        }
    }
    
    var top : GLfloat {
        get {
            return sprite.y + offsetY - sprite.animation.frame.hitbox.height / 2
        }
    }
    
    var bottom : GLfloat {
        get {
            return sprite.y + offsetY + sprite.animation.frame.hitbox.height / 2
        }
    }
    
    var left : GLfloat {
        get {
            return sprite.x + offsetX - sprite.animation.frame.hitbox.width / 2
        }
    }
    
    var right : GLfloat {
        get {
            return sprite.x + offsetX + sprite.animation.frame.hitbox.width / 2
        }
    }
    
    private var offsetX : GLfloat {
        get {
            return (sprite.animation.frame.hitbox.x - sprite.width / 2) * sprite.direction.value
        }
    }
    
    private var offsetY : GLfloat {
        get {
            return sprite.animation.frame.hitbox.y - sprite.height / 2
        }
    }
    
    init(sprite: Sprite) {
        self.sprite = sprite
    }
    
}

/// Hitbox encapsulant une autre hitbox pour lui ajouter une propriété "rotation".
class RotatedHitbox : Hitbox {
 
    let hitbox : Hitbox
    
    var x : GLfloat = 0
    var y : GLfloat = 0
    var width : GLfloat = 0
    var height : GLfloat = 0
    
    var top : GLfloat = 0
    var bottom : GLfloat = 0
    var left : GLfloat = 0
    var right : GLfloat = 0
    
    init(hitbox: Hitbox) {
        self.hitbox = hitbox
    }
    
    func rotate(rotation: GLfloat, withPivot pivot: Point) {
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
    
    func restore() {
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