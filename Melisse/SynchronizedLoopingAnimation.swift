//
//  SynchronizedLoopingAnimation.swift
//  Melisse
//
//  Created by Raphaël Calabro on 11/05/2016.
//  Copyright © 2016 Raphaël Calabro. All rights reserved.
//

import Foundation

let synchronizedLoopingAnimationReferenceDate = NSDate()

public struct SynchronizedLoopingAnimation : Animation {
    
    public var definition: AnimationDefinition
    public var frameIndex: Int = 0
    public var speed: Float = 1
    
    public init(definition: AnimationDefinition) {
        self.definition = definition
    }
    
    mutating public func updateWith(timeSinceLastUpdate: NSTimeInterval) {
        frameIndex = Int(NSDate().timeIntervalSinceDate(synchronizedLoopingAnimationReferenceDate) * framesPerSecond) % definition.frames.count
    }
    
}