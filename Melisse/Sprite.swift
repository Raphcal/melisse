//
//  Sprite.swift
//  MeltedIce
//
//  Created by Raphaël Calabro on 28/06/2015.
//  Copyright (c) 2015 Raphaël Calabro. All rights reserved.
//

import GLKit

public class Sprite : Equatable {
    
    public let definition: SpriteDefinition
    public let info: SpriteInfo?
    public var type: SpriteType = DefaultSpriteType.decoration
    
    public var frame: Rectangle<GLfloat> {
        didSet {
            #if PIXEL_PERFECT
                vertexSurface.setQuadWith(frame.floored())
            #else
                vertexSurface.setQuadWith(frame)
            #endif
        }
    }
    public var direction: Direction = .right
    public var front: GLfloat {
        get {
            return frame.x + frame.width * direction.value
        }
    }
    
    let factory: SpriteFactory
    
    let reference: Int
    public let vertexSurface: Surface<GLfloat>
    public let texCoordSurface: Surface<GLfloat>
    
    public var isRemoved: Bool = false
    
    public var hitbox: Hitbox = StaticHitbox()
    public var motion: Motion = NoMotion()
    
    public var currentAnimation: AnimationName?
    public var animation: Animation = NoAnimation()
    
    public var variables = [String : GLfloat]()
    public var objects = [String : AnyObject]()
    
    public init() {
        definition = SpriteDefinition()
        info = nil
        frame = Rectangle()
        factory = SpriteFactory()
        reference = -1
        vertexSurface = Surface(memory: UnsafeMutablePointer.allocate(capacity: 0), coordinates: 0, vertexesByQuad: vertexesByQuad)
        texCoordSurface = Surface(memory: UnsafeMutablePointer.allocate(capacity: 0), coordinates: 0, vertexesByQuad: vertexesByQuad)
    }
    
    public init(definition: SpriteDefinition = SpriteDefinition(), reference: Int, factory: SpriteFactory, info: SpriteInfo? = nil) {
        self.definition = definition
        self.info = info
        self.factory = factory
        self.type = definition.type
        self.reference = reference
        self.vertexSurface = factory.vertexPointer.surfaceAt(reference)
        self.texCoordSurface = factory.texCoordPointer.surfaceAt(reference)
        
        if let normalAnimationDefinition = definition.animations[DefaultAnimationName.normal.name] {
            self.animation = normalAnimationDefinition.toAnimation()
            self.currentAnimation = DefaultAnimationName.normal
        } else {
            self.animation = NoAnimation()
        }
        
        self.frame = Rectangle(size: animation.frame.size)
        
        if animation.frame.hitbox != Rectangle() {
            self.hitbox = SpriteHitbox(sprite: self)
        } else {
            self.hitbox = SimpleSpriteHitbox(sprite: self)
        }
    }
    
    public convenience init(factory: SpriteFactory, definition: Int) {
        // TODO: Tester comme ça.
        self.init(definition: factory.definitions[definition], reference: 0, factory: factory)
    }
    
    // MARK: Gestion des mises à jour
    
    public func updateWith(_ timeSinceLastUpdate: TimeInterval) {
        motion.updateWith(timeSinceLastUpdate, sprite: self)
        animation.updateWith(timeSinceLastUpdate)
        animation.draw(self)
    }
    
    public func isLookingToward(_ point: Point<GLfloat>) -> Bool {
        return direction.isSameValue(point.x - frame.x)
    }
    
    // MARK: Méthodes de suppression du sprite
    
    public func destroy() {
        self.isRemoved = true
        
        if let count = definition.animations[DefaultAnimationName.disappear.name]?.frames.count, count > 0 {
            self.motion.unload(self)
            self.motion = NoMotion()
            self.type = DefaultSpriteType.decoration
            setAnimation(DefaultAnimationName.disappear, onEnd: { self.factory.removeSprite(self) })
        } else {
            factory.removeSprite(self)
        }
    }
    
    public func explode(_ definition: Int) {
        self.isRemoved = true
        
        let explosion = factory.sprite(definition)
        explosion.frame.center = self.frame.center
        explosion.motion = NoMotion()
        explosion.setAnimation(DefaultAnimationName.normal, onEnd: { self.factory.removeSprite(explosion) })
        
        factory.removeSprite(self)
    }
    
    // MARK: Gestion des animations
    
    public func setAnimation(_ animationName: AnimationName, force: Bool = false) {
        if animationName.name != currentAnimation?.name || force, let nextAnimation = definition.animations[animationName.name]?.toAnimation() {
            self.animation = animation.transitionTo(nextAnimation)
            self.currentAnimation = animationName
        }
    }
    
    public func setAnimation(_ animationName: AnimationName, onEnd: @escaping () -> Void) {
        if let nextAnimation = definition.animations[animationName.name]?.toAnimation(onEnd) {
            self.animation = animation.transitionTo(nextAnimation)
            self.currentAnimation = animationName
        }
    }
    
    public func setBlinkingWith(duration: TimeInterval) {
        self.animation = BlinkingAnimation(animation: animation, blinkRate: 0.2, duration: duration) { (animation) -> Void in
            self.animation = animation
        }
    }
    
    public func setBlinkingWith(rate: TimeInterval) {
        self.animation = BlinkingAnimation(animation: animation, blinkRate: rate)
    }
    
    public func setBlinking(_ blinking: Bool) {
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
    
    public func variable(_ name: String, or defaultValue: GLfloat = 0) -> GLfloat {
        if let value = self.variables[name] {
            return value
        } else {
            return defaultValue
        }
    }
    
    public func variable(_ name: String, or defaultValue: Int = 0) -> Int {
        if let value = self.variables[name] {
            return Int(value)
        } else {
            return defaultValue
        }
    }
    
}

public func ==(left: Sprite, right: Sprite) -> Bool {
    return left === right
}

public func +=(left: inout GLfloat?, right: GLfloat) {
    if let l = left {
        left = l + right
    } else {
        left = right
    }
}

public func +=(left: inout Int?, right: Int) {
    if let l = left {
        left = l + right
    } else {
        left = right
    }
}
