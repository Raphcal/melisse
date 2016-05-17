//
//  Sprite.swift
//  MeltedIce
//
//  Created by Raphaël Calabro on 28/06/2015.
//  Copyright (c) 2015 Raphaël Calabro. All rights reserved.
//

import GLKit

public class Sprite {
    
    public let definition: SpriteDefinition
    public let info: SpriteInfo?
    public var type: SpriteType = DefaultSpriteType.Decoration
    
    public var frame: Rectangle<GLfloat> {
        didSet {
            vertexSurface.setQuadWith(frame)
        }
    }
    public var direction: Direction = .Right
    
    let factory: SpriteFactory
    
    let reference: Int
    public let vertexSurface: Surface<GLfloat>
    public let texCoordSurface: Surface<GLshort>
    
    public var removed: Bool = false
    
    public var hitbox: Hitbox
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
        vertexSurface = Surface(memory: UnsafeMutablePointer.alloc(0), cursor: 0, coordinates: 0, vertexesByQuad: vertexesByQuad)
        texCoordSurface = Surface(memory: UnsafeMutablePointer.alloc(0), cursor: 0, coordinates: 0, vertexesByQuad: vertexesByQuad)
        hitbox = SimpleHitbox()
    }
    
    public init(definition: SpriteDefinition = SpriteDefinition(), reference: Int, factory: SpriteFactory, info: SpriteInfo? = nil) {
        self.definition = definition
        self.info = info
        self.factory = factory
        self.type = definition.type
        self.reference = reference
        self.vertexSurface = factory.vertexPointer.surfaceAt(reference)
        self.texCoordSurface = factory.texCoordPointer.surfaceAt(reference)
        
        if let normalAnimationDefinition = definition.animations[DefaultAnimationName.Normal.name] {
            self.animation = normalAnimationDefinition.toAnimation()
            self.currentAnimation = DefaultAnimationName.Normal
        } else {
            self.animation = NoAnimation()
        }
        
        let size = animation.frame.frame.size
        self.frame = Rectangle(size: Size(width: GLfloat(size.width), height: GLfloat(size.height)))
        self.hitbox = SimpleHitbox()
        
        if animation.frame.hitbox != Rectangle() {
            self.hitbox = SpriteHitbox(sprite: self)
        }
    }
    
    // MARK: Gestion des mises à jour
    
    public func updateWith(timeSinceLastUpdate: NSTimeInterval) {
        motion.updateWith(timeSinceLastUpdate, sprite: self)
        animation.updateWith(timeSinceLastUpdate)
        animation.draw(self)
    }
    
    public func isLookingToward(point: Point<GLfloat>) -> Bool {
        return direction.isSameValue(point.x - frame.x)
    }
    
    // MARK: Méthodes de suppression du sprite
    
    public func destroy() {
        self.removed = true
        
        if definition.animations[DefaultAnimationName.Disappear.name]?.frames.count > 0 {
            setAnimation(DefaultAnimationName.Disappear, onEnd: { self.factory.removeSprite(self) })
            self.motion = NoMotion()
            self.type = DefaultSpriteType.Decoration
        } else {
            factory.removeSprite(self)
        }
    }
    
    public func explode(definition: Int) {
        self.removed = true
        
        let explosion = factory.sprite(definition)
        explosion.frame.center = self.frame.center
        explosion.motion = NoMotion()
        explosion.setAnimation(DefaultAnimationName.Normal, onEnd: { self.factory.removeSprite(explosion) })
        
        factory.removeSprite(self)
    }
    
    // MARK: Gestion des animations
    
    public func setAnimation(animationName: AnimationName, force: Bool = false) {
        if animationName.name != currentAnimation?.name || force, let nextAnimation = definition.animations[animationName.name]?.toAnimation() {
            self.animation = animation.transitionTo(nextAnimation)
            self.currentAnimation = animationName
        }
    }
    
    public func setAnimation(animationName: AnimationName, onEnd: () -> Void) {
        if let nextAnimation = definition.animations[animationName.name]?.toAnimation(onEnd) {
            self.animation = animation.transitionTo(nextAnimation)
            self.currentAnimation = animationName
        }
    }
    
    public func setBlinkingWith(duration duration: NSTimeInterval) {
        self.animation = BlinkingAnimation(animation: animation, blinkRate: 0.2, duration: duration) { (animation) -> Void in
            self.animation = animation
        }
    }
    
    public func setBlinkingWith(rate rate: NSTimeInterval) {
        self.animation = BlinkingAnimation(animation: animation, blinkRate: rate)
    }
    
    public func setBlinking(blinking: Bool) {
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
    
    public func variable(name: String, or defaultValue: GLfloat = 0) -> GLfloat {
        if let value = self.variables[name] {
            return value
        } else {
            return defaultValue
        }
    }
    
    public func variable(name: String, or defaultValue: Int = 0) -> Int {
        if let value = self.variables[name] {
            return Int(value)
        } else {
            return defaultValue
        }
    }
    
}

public func +=(inout left: GLfloat?, right: GLfloat) {
    if let l = left {
        left = l + right
    } else {
        left = right
    }
}

public func +=(inout left: Int?, right: Int) {
    if let l = left {
        left = l + right
    } else {
        left = right
    }
}
