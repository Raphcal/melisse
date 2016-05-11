//
//  LoopingAnimation.swift
//  Melisse
//
//  Created by Raphaël Calabro on 11/05/2016.
//  Copyright © 2016 Raphaël Calabro. All rights reserved.
//

import Foundation

public struct LoopingAnimation : Animation {
    
    public var definition: AnimationDefinition
    public var frameIndex: Int = 0
    public var speed: Float = 1
    public var time: NSTimeInterval = 0
    
    public init(definition: AnimationDefinition) {
        self.definition = definition
    }
    
    public mutating func updateWith(timeSinceLastUpdate: NSTimeInterval) {
        time += timeSinceLastUpdate
        
        let elapsedFrames = Int(time * framesPerSecond)
        if elapsedFrames > 0 {
            frameIndex = (frameIndex + elapsedFrames) % definition.frames.count
            time -= NSTimeInterval(elapsedFrames) / framesPerSecond
        }
    }
    
}