//
//  SynchronizedLoopingAnimation.swift
//  Melisse
//
//  Created by Raphaël Calabro on 11/05/2016.
//  Copyright © 2016 Raphaël Calabro. All rights reserved.
//

import Foundation

let synchronizedLoopingAnimationReferenceDate = Date()

public class SynchronizedLoopingAnimation : Animation {
    
    public var definition: AnimationDefinition
    public var frameIndex: Int = 0
    public var speed: Float = 1
    
    public init(definition: AnimationDefinition) {
        self.definition = definition
    }
    
    public func start() {
        frameIndex = 0
    }
    
    public func updateWith(_ timeSinceLastUpdate: TimeInterval) {
        frameIndex = Int(Date().timeIntervalSince(synchronizedLoopingAnimationReferenceDate) * framesPerSecond) % definition.frames.count
    }
    
}
