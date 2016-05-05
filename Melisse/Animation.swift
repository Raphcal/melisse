//
//  Animation.swift
//  MeltedIce
//
//  Created by Raphaël Calabro on 28/06/2015.
//  Copyright (c) 2015 Raphaël Calabro. All rights reserved.
//

import Foundation

enum AnimationName : Int {
    case Stand = 0, Walk, Run, Skid, Jump, Fall, Shaky, Bounce, Duck, Raise, Appear, Disappear, Attack, Hurt, Die
    
    static let values = [.Stand, .Walk, .Run, .Skid, .Jump, Fall, Shaky, Bounce, Duck, Raise, Appear, Disappear, Attack, Hurt, Die]
}

protocol Animation {
    
    func updateWithTimeSinceLastUpdate(timeSinceLastUpdate: NSTimeInterval)
    func draw(sprite: Sprite)
    func transitionToNextAnimation(nextAnimation: Animation) -> Animation
    
    var definition : AnimationDefinition { get set }
    var frameIndex : Int { get set }
    var frame : Frame { get }
    var speed : Float { get set }
    
}

class Frame {
    
    /// Emplacement x dans l'atlas.
    let x : Int
    /// Emplacement y dans l'atlas.
    let y : Int
    /// Largeur de l'image.
    let width : Int
    /// Hauteur de l'image.
    let height : Int
    /// Zone de collision.
    let hitbox : Rectangle
    
    init() {
        self.x = 0
        self.y = 0
        self.width = 0
        self.height = 0
        self.hitbox = Rectangle()
    }
    
    init(width: Int, height: Int) {
        self.x = 0
        self.y = 0
        self.width = width
        self.height = height
        self.hitbox = Rectangle()
    }
    
    init(x: Int, y: Int, width: Int, height: Int) {
        self.x = x
        self.y = y
        self.width = width
        self.height = height
        self.hitbox = Rectangle()
    }
    
    init(inputStream : NSInputStream) {
        self.x = Streams.readInt(inputStream)
        self.y = Streams.readInt(inputStream)
        self.width = Streams.readInt(inputStream)
        self.height = Streams.readInt(inputStream)
        
        if Streams.readBoolean(inputStream) {
            let left = GLfloat(Streams.readInt(inputStream))
            let top = GLfloat(Streams.readInt(inputStream))
            let width = GLfloat(Streams.readInt(inputStream))
            let height = GLfloat(Streams.readInt(inputStream))
            
            self.hitbox = Rectangle(left: left, top: top, width: width, height: height)
        } else {
            self.hitbox = Rectangle()
        }
    }
    
    func draw(sprite: Sprite) {
        sprite.texCoordSurface.setQuadWithLeft(x, top: y, width: width, height: height, direction: sprite.direction, texture: sprite.factory.textureAtlas)
    }
    
    func frameChunksForWidth(width: Int, direction: Direction = .Right) -> [Frame] {
        let start = 0 + self.width * Int(direction.mirror)
        let end = self.width * (1 - Int(direction.mirror))
        let stride = width * Int(direction.value)
        
        var frames = [Frame]()
        for left in start.stride(to: end, by: stride) {
            frames.append(Frame(x: self.x + left, y: self.y, width: stride, height: self.height))
        }
        return frames
    }
    
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
    
    func updateWithTimeSinceLastUpdate(timeSinceLastUpdate: NSTimeInterval) {
        // Pas de traitement
    }
    
    func draw(sprite: Sprite) {
        // Pas de traitement
    }
    
    func transitionToNextAnimation(nextAnimation: Animation) -> Animation {
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
        self.init(definition: sprite.definition.animations[animation]!)
    }
    
    func updateWithTimeSinceLastUpdate(timeSinceLastUpdate: NSTimeInterval) {
        // Pas de traitement
    }
    
    func draw(sprite: Sprite) {
        frame.draw(sprite)
    }
    
    func transitionToNextAnimation(nextAnimation: Animation) -> Animation {
        return nextAnimation
    }
    
    func start() {
        self.frameIndex = 0
    }
    
}

class LoopingAnimation : SingleFrameAnimation {
    
    var time : NSTimeInterval = 0
    
    override func updateWithTimeSinceLastUpdate(timeSinceLastUpdate: NSTimeInterval) {
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
    
    override func updateWithTimeSinceLastUpdate(timeSinceLastUpdate: NSTimeInterval) {
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
    
    override func updateWithTimeSinceLastUpdate(timeSinceLastUpdate: NSTimeInterval) {
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
    
    func updateWithTimeSinceLastUpdate(timeSinceLastUpdate: NSTimeInterval) {
        self.time += timeSinceLastUpdate
        
        let frame = Int(time / blinkRate)
        self.visible = (frame % BlinkingAnimation.Pair) == 0
        
        if let onEnd = self.onEnd where time >= duration {
            onEnd(animation: animation)
        }
        
        animation.updateWithTimeSinceLastUpdate(timeSinceLastUpdate)
    }
    
    func draw(sprite: Sprite) {
        if visible {
            animation.draw(sprite)
        } else {
            sprite.texCoordSurface.clear()
        }
    }
    
    func transitionToNextAnimation(nextAnimation: Animation) -> Animation {
        self.animation = nextAnimation
        return self
    }
    
}
