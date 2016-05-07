//
//  AnimationDefinition.swift
//  Melisse
//
//  Created by Raphaël Calabro on 07/05/2016.
//  Copyright © 2016 Raphaël Calabro. All rights reserved.
//

import Foundation

enum AnimationType {
    case None, SingleFrame, PlayOnce, Looping, Synchronized
}

struct AnimationDefinition {
    
    var name: String
    var frames: [Frame]
    var frequency: Int
    var type: AnimationType
    
    init() {
        self.name = ""
        self.frames = []
        self.frequency = 1
        self.type = .None
    }
    
    init(frames: [Frame]) {
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
        
        var mainFrames : [Frame] = []
        
        for _ in 0..<directionCount {
            let key = Streams.readDouble(inputStream)
            
            // Frames
            let frameCount = Streams.readInt(inputStream)
            
            var frames : [Frame] = []
            
            for _ in 0..<frameCount {
                frames.append(Frame(inputStream: inputStream))
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
