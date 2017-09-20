//
//  SingleFrameAnimation.swift
//  Melisse
//
//  Created by Raphaël Calabro on 11/05/2016.
//  Copyright © 2016 Raphaël Calabro. All rights reserved.
//

import Foundation

public struct SingleFrameAnimation : Animation {
    
    public var definition: AnimationDefinition
    public var frameIndex: Int = 0
    public var speed: Float = 1
    
    public init(definition: AnimationDefinition = AnimationDefinition()) {
        self.definition = definition
    }
    
    public init(animation: AnimationName, from sprite: Sprite) {
        self.init(definition: sprite.definition.animations[animation.name]!)
    }
    
    public func start() {
        // Pas de traitement
    }
    
    public func updateWith(_ timeSinceLastUpdate: TimeInterval) {
        // Pas de traitement
    }
    
}
