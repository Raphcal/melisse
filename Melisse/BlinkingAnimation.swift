//
//  BlinkingAnimation.swift
//  Melisse
//
//  Created by Raphaël Calabro on 11/05/2016.
//  Copyright © 2016 Raphaël Calabro. All rights reserved.
//

import Foundation

public class BlinkingAnimation : Animation {
    
    static let Pair = 2
    
    public var animation: Animation
    public var onEnd: ((_ animation: Animation) -> Void)?
    public var duration: TimeInterval
    
    public var time: TimeInterval = 0
    public var blinkRate: TimeInterval
    
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
    
    public init(animation: Animation, blinkRate: TimeInterval = 0.2, duration: TimeInterval = 0, onEnd:((_ animation: Animation) -> Void)? = nil) {
        self.animation = animation
        self.onEnd = onEnd
        self.duration = duration
        self.blinkRate = blinkRate
    }
    
    public func start() {
        animation.start()
    }
    
    public func updateWith(_ timeSinceLastUpdate: TimeInterval) {
        time += timeSinceLastUpdate
        visible = (Int(time / blinkRate) % BlinkingAnimation.Pair) == 0
        
        if time >= duration, let onEnd = self.onEnd {
            onEnd(animation)
        } else {
            animation.updateWith(timeSinceLastUpdate)
        }
    }
    
    public func draw(_ sprite: Sprite) {
        if visible {
            animation.draw(sprite)
        } else {
            sprite.texCoordSurface.clear()
        }
    }
    
    public func transitionTo(_ nextAnimation: Animation) -> Animation {
        self.animation = nextAnimation
        return self
    }
    
}
