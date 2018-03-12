//
//  AnimationDefinition.swift
//  Melisse
//
//  Created by Raphaël Calabro on 07/05/2016.
//  Copyright © 2016 Raphaël Calabro. All rights reserved.
//

import Foundation

public enum AnimationType {
    case none, singleFrame, playOnce, looping, synchronized
}

public struct AnimationDefinition : Equatable {
    
    public var name: String
    public var frames: [AnimationFrame]
    public var frequency: Int
    public var type: AnimationType
    
    public var duration: TimeInterval {
        get {
            return TimeInterval(frames.count) / TimeInterval(frequency)
        }
    }
    
    public init(name: String = "", frames: [AnimationFrame] = [], looping: Bool = false) {
        self.name = ""
        self.frames = frames
        self.frequency = 1
        self.type = AnimationDefinition.typeFor(frames.count, looping: looping)
    }
    
    public init(name: String = "", frames: [AnimationFrame], frequency: Int = 1, type: AnimationType) {
        self.name = name
        self.frames = frames
        self.frequency = frequency
        self.type = type
    }
    
    public init(inputStream : InputStream) {
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
        self.type = AnimationDefinition.typeFor(frames.count, looping: looping)
    }
    
    public func toAnimation() -> Animation {
        switch type {
        case .none:
            return NoAnimation(definition: self)
        case .singleFrame:
            return SingleFrameAnimation(definition: self)
        case .playOnce:
            return PlayOnceAnimation(definition: self)
        case .looping:
            return LoopingAnimation(definition: self)
        case .synchronized:
            return SynchronizedLoopingAnimation(definition: self)
        }
    }
    
    func toAnimation(_ onEnd: @escaping () -> Void) -> Animation {
        return PlayOnceAnimation(definition: self, onEnd: onEnd)
    }
    
    private static func typeFor(_ frameCount: Int, looping: Bool) -> AnimationType {
        if looping {
            return .looping
        } else if frameCount > 1 {
            return .playOnce
        } else if frameCount == 1 {
            return .singleFrame
        } else {
            return .none
        }
    }
    
}

public func ==(left: AnimationDefinition, right: AnimationDefinition) -> Bool {
    return left.frequency == right.frequency
        && left.type == right.type
        && left.name == right.name
        && left.frames == right.frames
}
