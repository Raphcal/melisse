//
//  AnimationDefinition.swift
//  Melisse
//
//  Created by Raphaël Calabro on 07/05/2016.
//  Copyright © 2016 Raphaël Calabro. All rights reserved.
//

import Foundation

public enum AnimationType {
    case None, SingleFrame, PlayOnce, Looping, Synchronized
}

public struct AnimationDefinition : Equatable {
    
    public var name: String
    public var frames: [AnimationFrame]
    public var frequency: Int
    public var type: AnimationType
    
    init() {
        self.name = ""
        self.frames = []
        self.frequency = 1
        self.type = .None
    }
    
    init(frames: [AnimationFrame]) {
        self.name = ""
        self.frames = frames
        self.frequency = 1
        self.type = .None
    }
    
    init(inputStream : NSInputStream) {
        self.name = Streams.readString(inputStream)
        self.frequency = Streams.readInt(inputStream)
        let looping = Streams.readBoolean(inputStream)
        
        // Directions et frames
        let directionCount = Streams.readInt(inputStream)
        
        var mainFrames : [AnimationFrame] = []
        
        for _ in 0..<directionCount {
            let key = Streams.readDouble(inputStream)
            
            // Frames
            let frameCount = Streams.readInt(inputStream)
            
            var frames : [AnimationFrame] = []
            
            for _ in 0..<frameCount {
                frames.append(AnimationFrame(inputStream: inputStream))
            }
            
            if key == 0 || mainFrames.isEmpty {
                mainFrames = frames
            }
        }
        
        self.frames = mainFrames
        
        if looping {
            self.type = .Looping
        } else if frames.count > 1 {
            self.type = .PlayOnce
        } else if frames.count == 1 {
            self.type = .SingleFrame
        } else {
            self.type = .None
        }
    }
    
    func toAnimation() -> Animation {
        switch type {
        case .None:
            return NoAnimation(definition: self)
        case .SingleFrame:
            return SingleFrameAnimation(definition: self)
        case .PlayOnce:
            return PlayOnceAnimation(definition: self)
        case .Looping:
            return LoopingAnimation(definition: self)
        case .Synchronized:
            return SynchronizedLoopingAnimation(definition: self)
        }
    }
    
    func toAnimation(onEnd: () -> Void) -> Animation {
        return PlayOnceAnimation(definition: self, onEnd: onEnd)
    }
    
}

public func ==(left: AnimationDefinition, right: AnimationDefinition) -> Bool {
    return left.frequency == right.frequency
        && left.type == right.type
        && left.name == right.name
        && left.frames == right.frames
}