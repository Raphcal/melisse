//
//  BlinkingAnimation.swift
//  Melisse
//
//  Created by Raphaël Calabro on 11/05/2016.
//  Copyright © 2016 Raphaël Calabro. All rights reserved.
//

import Foundation

public struct BlinkingAnimation : Animation {
    
    static let Pair = 2
    
    public var animation: Animation
    public var onEnd: ((animation: Animation) -> Void)?
    public var duration: NSTimeInterval
    
    public var time: NSTimeInterval = 0
    public var blinkRate: NSTimeInterval
    
    private var visible = true
    
    public var definition: AnimationDefinition {
        get {
            return animation.definition
        }
        set {
            animation.definition = newValue
        }
    }
    public var frameIndex: Int {
        get {
            return animation.frameIndex
        }
        set {
            animation.frameIndex = newValue
        }
    }
    public var speed : Float {
        get {
            return animation.speed
        }
        set {
            animation.speed = newValue
        }
    }
    
    public init(animation: Animation, blinkRate: NSTimeInterval = 0.2, duration: NSTimeInterval = 0, onEnd:((animation: Animation) -> Void)? = nil) {
        self.animation = animation
        self.onEnd = onEnd
        self.duration = duration
        self.blinkRate = blinkRate
    }
    
    mutating public func updateWith(timeSinceLastUpdate: NSTimeInterval) {
        time += timeSinceLastUpdate
        visible = (Int(time / blinkRate) % BlinkingAnimation.Pair) == 0
        
        if time >= duration, let onEnd = self.onEnd {
            onEnd(animation: animation)
        }
        
        animation.updateWith(timeSinceLastUpdate)
    }
    
    public func draw(sprite: Sprite) {
        if visible {
            animation.draw(sprite)
        } else {
            sprite.texCoordSurface.clear()
        }
    }
    
    mutating public func transitionTo(nextAnimation: Animation) -> Animation {
        self.animation = nextAnimation
        return self
    }
    
}
