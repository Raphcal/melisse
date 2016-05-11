//
//  NoAnimation.swift
//  Melisse
//
//  Created by Raphaël Calabro on 11/05/2016.
//  Copyright © 2016 Raphaël Calabro. All rights reserved.
//

import Foundation

public struct NoAnimation : Animation {
    
    public var definition: AnimationDefinition
    public var frameIndex: Int = 0
    public var frame: AnimationFrame
    public var speed: Float = 0
    
    public init(definition: AnimationDefinition = AnimationDefinition(), frame: AnimationFrame = AnimationFrame()) {
        self.definition = definition
        self.frame = frame
    }
    
    public func updateWith(timeSinceLastUpdate: NSTimeInterval) {
        // Pas de traitement
    }
    
    public func draw(sprite: Sprite) {
        // Pas de traitement
    }
    
}
