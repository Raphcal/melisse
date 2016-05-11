//
//  Animation.swift
//  MeltedIce
//
//  Created by Raphaël Calabro on 28/06/2015.
//  Copyright (c) 2015 Raphaël Calabro. All rights reserved.
//

import Foundation


public protocol Animation {
    
    mutating func updateWith(timeSinceLastUpdate: NSTimeInterval)
    func draw(sprite: Sprite)
    
    mutating func start()
    mutating func transitionTo(nextAnimation: Animation) -> Animation
    
    var definition: AnimationDefinition { get set }
    var frameIndex: Int { get set }
    var frame: AnimationFrame { get }
    var speed: Float { get set }
    
}

public extension Animation {
    
    var frame: AnimationFrame {
        get {
            return definition.frames[frameIndex]
        }
    }
    
    var framesPerSecond: NSTimeInterval {
        get {
            return NSTimeInterval(definition.frequency) * NSTimeInterval(speed)
        }
    }
    
    func draw(sprite: Sprite) {
        frame.draw(sprite)
    }
    
    mutating func start() {
        self.frameIndex = 0
    }
    
    func transitionTo(nextAnimation: Animation) -> Animation {
        return nextAnimation
    }
    
}
