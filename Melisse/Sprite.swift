//
//  Sprite.swift
//  MeltedIce
//
//  Created by Raphaël Calabro on 28/06/2015.
//  Copyright (c) 2015 Raphaël Calabro. All rights reserved.
//

import GLKit

public class Sprite {
    
    let definition: SpriteDefinition
    var type: SpriteType = DefaultSpriteType.Decoration
    
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
    var motion: Motion = NoMotion()
    
    var currentAnimation: AnimationName?
    var animation: Animation = NoAnimation.instance
    
    var variables = [String : GLfloat]()
    var objects = [String : AnyObject]()
    
    init() {
        definition = SpriteDefinition()
        frame = Rectangle()
        factory = SpriteFactory()
        reference = -1
        vertexSurface = Surface(memory: UnsafeMutablePointer.alloc(0), cursor: 0, coordinates: 0, vertexesByQuad: vertexesByQuad)
        texCoordSurface = Surface(memory: UnsafeMutablePointer.alloc(0), cursor: 0, coordinates: 0, vertexesByQuad: vertexesByQuad)
        hitbox = SimpleHitbox()
    }
    
    // MARK: Gestion des mises à jour
    
    func updateWith(timeSinceLastUpdate: NSTimeInterval) {
        motion.updateWith(timeSinceLastUpdate, sprite: self)
        animation.updateWith(timeSinceLastUpdate)
        animation.draw(self)
    }
    
    func isLookingToward(point: Point<GLfloat>) -> Bool {
        return direction.isSameValue(point.x - frame.x)
    }
    
    // MARK: Méthodes de suppression du sprite
    
    func destroy() {
        self.removed = true
        
        if definition.animations[DefaultAnimationName.Disappear.name]?.frames.count > 0 {
            setAnimation(DefaultAnimationName.Disappear, onEnd: { self.factory.removeSprite(self) })
            self.motion = NoMotion()
            self.type = DefaultSpriteType.Decoration
        } else {
            factory.removeSprite(self)
        }
    }
    
    func explode(definition: Int) {
        self.removed = true
        
        let explosion = factory.sprite(definition)
        explosion.frame.center = self.frame.center
        explosion.motion = NoMotion()
        explosion.setAnimation(DefaultAnimationName.Normal, onEnd: { self.factory.removeSprite(explosion) })
        
        factory.removeSprite(self)
    }
    
    // MARK: Gestion des animations
    
    func setAnimation(animationName: AnimationName, force: Bool = false) {
        if animationName.name != currentAnimation?.name || force, let nextAnimation = definition.animations[animationName.name]?.toAnimation() {
            self.animation = animation.transitionTo(nextAnimation)
            self.currentAnimation = animationName
        }
    }
    
    func setAnimation(animationName: AnimationName, onEnd: () -> Void) {
        if let nextAnimation = definition.animations[animationName.name]?.toAnimation(onEnd) {
            self.animation = animation.transitionTo(nextAnimation)
            self.currentAnimation = animationName
        }
    }
    
    func setBlinkingWith(duration duration: NSTimeInterval) {
        self.animation = BlinkingAnimation(animation: animation, blinkRate: 0.2, duration: duration) { (animation) -> Void in
            self.animation = animation
        }
    }
    
    func setBlinkingWith(rate rate: NSTimeInterval) {
        self.animation = BlinkingAnimation(animation: animation, blinkRate: rate)
    }
    
    func setBlinking(blinking: Bool) {
        if blinking {
            if !(animation is BlinkingAnimation) {
                let blinkingAnimation = BlinkingAnimation(animation: animation)
                self.animation = blinkingAnimation
            }
        } else if let blinkingAnimation = self.animation as? BlinkingAnimation {
            self.animation = blinkingAnimation.animation
        }
    }
    
    // MARK: Accès aux variables
    
    func variable(name: String, or defaultValue: GLfloat = 0) -> GLfloat {
        if let value = self.variables[name] {
            return value
        } else {
            return defaultValue
        }
    }
    
    func variable(name: String, or defaultValue: Int = 0) -> Int {
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
