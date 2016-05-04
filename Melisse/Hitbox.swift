//
//  Hitbox.swift
//  MeltedIce
//
//  Created by Raphaël Calabro on 29/06/2015.
//  Copyright (c) 2015 Raphaël Calabro. All rights reserved.
//

import GLKit

protocol Hitbox : Shape {
    
    var x : GLfloat { get }
    var y : GLfloat { get }
    var width : GLfloat { get }
    var height : GLfloat { get }
    
    var top : GLfloat { get }
    var bottom : GLfloat { get }
    var left : GLfloat { get }
    var right : GLfloat { get }
    
}

extension Hitbox {
    
    func collidesWith(x: GLfloat, y: GLfloat) -> Bool {
        return x >= self.left && x < self.right &&
            y >= self.top && y < self.bottom
    }
    
    func collidesWith(point: Point) -> Bool {
        return point.x >= self.left && point.x < self.right &&
            point.y >= self.top && point.y < self.bottom
    }
    
    func collidesWith(square: Square) -> Bool {
        return collidesWith(SimpleHitbox(center: square, width: square.width, height: square.height))
    }
    
    func collidesWith(other: Hitbox) -> Bool {
        // Sinon trouver les 1ères et 2èmes plus petites coordonnées x et y et si elles appartiennent respectivement chacune à une hitbox différente, alors il y a collision.
        return abs(x - other.x) <= (width + other.width) / 2 && abs(y - other.y) <= (height + other.height) / 2
    }
    
    func collidesWith(sprite: Sprite) -> Bool {
        return collidesWith(sprite.hitbox)
    }
    
    func bottomHitbox() -> Hitbox {
        let bottom = self.bottom
        return SimpleHitbox(square: Square(top: bottom - 1, bottom: bottom, left: left, right: right))
    }
    
    func square() -> Square {
        return Square(left: left, top: top, width: width, height: height)
    }
    
}

class StaticHitbox : Hitbox {
    
    let x : GLfloat
    let y : GLfloat
    let width : GLfloat
    let height : GLfloat
    let top :  GLfloat
    let bottom :  GLfloat
    let left : GLfloat
    let right : GLfloat
    
    init(shape: Shape) {
        self.x = shape.x
        self.y = shape.y
        self.width = shape.width
        self.height = shape.height
        self.top = shape.top
        self.bottom = shape.bottom
        self.left = shape.left
        self.right = shape.right
    }
    
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
    
    init(square: Square) {
        self.center = square
        self.offset = Point()
        self.width = square.width
        self.height = square.height
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
        let square = Square(left: left, top: top, width: hitbox.right - left, height: hitbox.bottom - top)
        
        let rotatedSquare = square.rotate(rotation, withPivot: pivot).enclosingSquare()
        
        self.x = rotatedSquare.x
        self.y = rotatedSquare.y
        self.width = rotatedSquare.width
        self.height = rotatedSquare.height
        self.top = rotatedSquare.top
        self.bottom = rotatedSquare.bottom
        self.left = rotatedSquare.left
        self.right = rotatedSquare.right
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