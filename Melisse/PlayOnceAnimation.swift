//
//  PlayOnceAnimation.swift
//  Melisse
//
//  Created by Raphaël Calabro on 11/05/2016.
//  Copyright © 2016 Raphaël Calabro. All rights reserved.
//

import Foundation

public struct PlayOnceAnimation : Animation {
    
    public var definition: AnimationDefinition
    public var frameIndex: Int = 0
    public var speed: Float = 1
    public var onEnd: (() -> Void)?
    private var startDate: Date
    
    public init(definition: AnimationDefinition, onEnd: (() -> Void)? = nil) {
        self.definition = definition
        self.onEnd = onEnd
        self.startDate = Date()
    }
    
    mutating public func updateWith(_ timeSinceLastUpdate: TimeInterval) {
        let timeSinceStart = Date().timeIntervalSince(startDate)
        let frame = Int(timeSinceStart * framesPerSecond)
        
        if frame < definition.frames.count {
            self.frameIndex = frame
        } else {
            self.frameIndex = definition.frames.count - 1
            
            if let onEnd = self.onEnd {
                self.onEnd = nil
                onEnd()
            }
        }
    }
    
    mutating public func start() {
        self.frameIndex = 0
        self.startDate = Date()
    }
    
}
