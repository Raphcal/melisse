//
//  Animation.swift
//  MeltedIce
//
//  Created by Raphaël Calabro on 28/06/2015.
//  Copyright (c) 2015 Raphaël Calabro. All rights reserved.
//

import Foundation


protocol Animation {
    
    func updateWith(timeSinceLastUpdate: NSTimeInterval)
    func draw(sprite: Sprite)
    func transitionTo(nextAnimation: Animation) -> Animation
    
    var definition: AnimationDefinition { get set }
    var frameIndex: Int { get set }
    var frame: Frame { get }
    var speed: Float { get set }
    
}

// MARK: - Implémentation des différents types d'animation

class NoAnimation : Animation {
    
    static let instance : NoAnimation = NoAnimation()
    
    var definition : AnimationDefinition = AnimationDefinition()
    var frameIndex : Int = 0
    let frame : Frame
    var speed : Float = 0
    
    init() {
        self.frame = Frame()
    }
    
    init(definition: AnimationDefinition) {
        self.frame = Frame()
        self.definition = definition
    }
    
    init(frame: Frame) {
        self.frame = frame
    }
    
    func updateWith(timeSinceLastUpdate: NSTimeInterval) {
        // Pas de traitement
    }
    
    func draw(sprite: Sprite) {
        // Pas de traitement
    }
    
    func transitionTo(nextAnimation: Animation) -> Animation {
        return nextAnimation
    }
    
}

class SingleFrameAnimation : Animation {
    
    var definition : AnimationDefinition {
        didSet {
            start()
        }
    }
    var frameIndex : Int {
        didSet {
            if frameIndex >= 0 && frameIndex < definition.frames.count {
                self.frame = definition.frames[frameIndex]
            }
        }
    }
    var frame : Frame
    var speed : Float = 1
    var frequency : NSTimeInterval
    
    init(definition: AnimationDefinition) {
        self.definition = definition
        self.frequency = 1 / NSTimeInterval(definition.frequency)
        self.frameIndex = 0
        if definition.frames.count > 0 {
            self.frame = definition.frames[0]
        } else {
            self.frame = Frame()
        }
    }
    
    convenience init(animation: AnimationName, fromSprite sprite: Sprite) {
        self.init(definition: sprite.definition.animations[animation.name]!)
    }
    
    func updateWith(timeSinceLastUpdate: NSTimeInterval) {
        // Pas de traitement
    }
    
    func draw(sprite: Sprite) {
        frame.draw(sprite)
    }
    
    func transitionTo(nextAnimation: Animation) -> Animation {
        return nextAnimation
    }
    
    func start() {
        self.frameIndex = 0
    }
    
}

class LoopingAnimation : SingleFrameAnimation {
    
    var time : NSTimeInterval = 0
    
    override func updateWith(timeSinceLastUpdate: NSTimeInterval) {
        time += timeSinceLastUpdate * NSTimeInterval(speed)
        
        if time >= frequency {
            let elapsedFrames = Int(time / frequency)
            self.frameIndex = (frameIndex + elapsedFrames) % definition.frames.count
            time -= NSTimeInterval(elapsedFrames) * frequency
        }
    }
    
}

class SynchronizedLoopingAnimation : SingleFrameAnimation {
    
    static let referenceDate = NSDate()
    
    override func updateWith(timeSinceLastUpdate: NSTimeInterval) {
        self.frameIndex = Int(NSDate().timeIntervalSinceDate(SynchronizedLoopingAnimation.referenceDate) / frequency) % definition.frames.count
    }
    
}

class PlayOnceAnimation : SingleFrameAnimation {
    
    let onEnd : (() -> Void)?
    
    private var startDate : NSDate
    private var called : Bool
    
    override init(definition: AnimationDefinition) {
        self.onEnd = nil
        self.startDate = NSDate()
        self.called = false
        
        super.init(definition: definition)
    }
    
    init(definition: AnimationDefinition, onEnd: () -> Void) {
        self.onEnd = onEnd
        self.startDate = NSDate()
        self.called = false
        
        super.init(definition: definition)
    }
    
    override func updateWith(timeSinceLastUpdate: NSTimeInterval) {
        let timeSinceStart = NSDate().timeIntervalSinceDate(startDate)
        let frame = Int(timeSinceStart / frequency)
        
        if frame < definition.frames.count {
            self.frameIndex = frame
        } else {
            self.frameIndex = definition.frames.count - 1
            
            if onEnd != nil && !called {
                self.called = true
                onEnd!()
            }
        }
    }
    
    override func start() {
        super.start()
        self.startDate = NSDate()
    }
    
}

class BlinkingAnimation : Animation {
    
    static let Pair = 2
    
    var animation : Animation
    let onEnd : ((animation: Animation) -> Void)?
    let duration : NSTimeInterval
    
    var time : NSTimeInterval = 0
    let blinkRate : NSTimeInterval
    
    private var visible = true
    
    var definition : AnimationDefinition {
        get {
            return animation.definition
        }
        set {
            animation.definition = newValue
        }
    }
    var frameIndex : Int {
        get {
            return animation.frameIndex
        }
        set {
            animation.frameIndex = newValue
        }
    }
    var frame : Frame {
        get {
            return animation.frame
        }
    }
    var speed : Float {
        get {
            return animation.speed
        }
        set {
            animation.speed = newValue
        }
    }
    
    init(animation: Animation, blinkRate: NSTimeInterval = 0.2, duration: NSTimeInterval = 0, onEnd:((animation: Animation) -> Void)? = nil) {
        self.animation = animation
        self.onEnd = onEnd
        self.duration = duration
        self.blinkRate = blinkRate
    }
    
    func updateWith(timeSinceLastUpdate: NSTimeInterval) {
        self.time += timeSinceLastUpdate
        
        let frame = Int(time / blinkRate)
        self.visible = (frame % BlinkingAnimation.Pair) == 0
        
        if let onEnd = self.onEnd where time >= duration {
            onEnd(animation: animation)
        }
        
        animation.updateWith(timeSinceLastUpdate)
    }
    
    func draw(sprite: Sprite) {
        if visible {
            animation.draw(sprite)
        } else {
            sprite.texCoordSurface.clear()
        }
    }
    
    func transitionTo(nextAnimation: Animation) -> Animation {
        self.animation = nextAnimation
        return self
    }
    
}
