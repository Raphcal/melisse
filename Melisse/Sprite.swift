//
//  Sprite.swift
//  MeltedIce
//
//  Created by Raphaël Calabro on 28/06/2015.
//  Copyright (c) 2015 Raphaël Calabro. All rights reserved.
//

import GLKit

class Sprite {
    
    let definition: SpriteDefinition
    
    var frame: Rectangle<GLfloat> {
        didSet {
            vertexSurface.setQuadWith(frame)
        }
    }
    var direction: Direction = .Right
    
    let factory: SpriteFactory
    
    let reference: Int
    let vertexSurface: Surface<GLfloat>
    let texCoordSurface: Surface<GLshort>
    
    var removed: Bool = false
    
    var hitbox: Hitbox
    var motion: Motion = NoMotion.instance
    
    var currentAnimation: AnimationName?
    var animation: Animation = NoAnimation.instance
    
    var variables = [String : GLfloat]()
    var objects = [String : AnyObject]()
    
    init() {
        frame = Rectangle()
        vertexSurface = Surface(memory: UnsafeMutablePointer.alloc(0), cursor: 0, coordinates: 0)
        texCoordSurface = Surface(memory: UnsafeMutablePointer.alloc(0), cursor: 0, coordinates: 0)
        
    }
    
    // MARK: Gestion des mises à jour
    
    func updateWith(timeSinceLastUpdate: NSTimeInterval) {
        motion.updateWithTimeSinceLastUpdate(timeSinceLastUpdate, sprite: self)
        animation.updateWithTimeSinceLastUpdate(timeSinceLastUpdate)
        animation.draw(self)
    }
    
    func isLookingTowardPoint(point: Point<GLfloat>) -> Bool {
        return direction.isSameValue(point.x - frame.x)
    }
    
    // MARK: Méthodes de suppression du sprite
    
    func destroy() {
        self.removed = true
        
        if definition.animations[.Disappear]?.frames.count > 0 {
            setAnimation(.Disappear, onEnd: { self.factory.removeSprite(self) })
            self.motion = NoMotion.instance
        } else {
            factory.removeSprite(self)
        }
    }
    
    func explode(definition: Int) {
        self.removed = true
        
        let explosion = factory.sprite(definition)
        explosion.center = self.center
        explosion.motion = NoMotion.instance
        explosion.setAnimation(.Stand, onEnd: { self.factory.removeSprite(explosion) })
        
        factory.removeSprite(self)
    }
    
    // MARK: Gestion des animations
    
    func setAnimation(name: AnimationName) {
        setAnimation(name, force: false)
    }
    
    func setAnimation(name: AnimationName, force: Bool) {
        if name != currentAnimation || force, let nextAnimation = definition.animations[name]?.toAnimation() {
            self.animation = animation.transitionToNextAnimation(nextAnimation)
            self.currentAnimation = name
        }
    }
    
    func setAnimation(name: AnimationName, onEnd: () -> Void) {
        if let nextAnimation = definition.animations[name]?.toAnimation(onEnd) {
            self.animation = animation.transitionToNextAnimation(nextAnimation)
            self.currentAnimation = name
        }
    }
    
    func setBlinkingWithDuration(duration: NSTimeInterval) {
        self.animation = BlinkingAnimation(animation: animation, blinkRate: 0.2, duration: duration) { (animation) -> Void in
            self.animation = animation
        }
    }
    
    func setBlinkingWithRate(blinkRate: NSTimeInterval) {
        self.animation = BlinkingAnimation(animation: animation, blinkRate: blinkRate)
    }
    
    func setBlinking(blinking: Bool) {
        if blinking {
            if !(animation is BlinkingAnimation) {
                let blinkingAnimation = BlinkingAnimation(animation: animation)
                self.animation = blinkingAnimation
            }
        } else {
            if let blinkingAnimation = self.animation as? BlinkingAnimation {
                self.animation = blinkingAnimation.animation
            }
        }
    }
    
    // MARK: Accès aux variables
    
    func variable(name: String, defaultValue: GLfloat = 0) -> GLfloat {
        if let value = self.variables[name] {
            return value
        } else {
            return defaultValue
        }
    }
    
    func intVariable(name: String, defaultValue: Int = 0) -> Int {
        if let value = self.variables[name] {
            return Int(value)
        } else {
            return defaultValue
        }
    }
    
}

func +=(inout left: GLfloat?, right: GLfloat) {
    if let l = left {
        left = l + right
    } else {
        left = right
    }
}

func +=(inout left: Int?, right: Int) {
    if let l = left {
        left = l + right
    } else {
        left = right
    }
}
