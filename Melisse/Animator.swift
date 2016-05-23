//
//  Animator.swift
//  Melisse
//
//  Created by Raphaël Calabro on 22/05/2016.
//  Copyright © 2016 Raphaël Calabro. All rights reserved.
//

import GLKit

public class Animator {
    
    public let durations: [NSTimeInterval]
    public let values: [String : [GLfloat]]
    public let animations: (values: [String : GLfloat]) -> Void
    public var onKeyFrame: [(() -> Void)?]
    
    var time: NSTimeInterval = 0
    var keyFrame = 0
    
    public init(durations: [NSTimeInterval], values: [String : [GLfloat]], animations: (values: [String : GLfloat]) -> Void) {
        self.durations = durations
        self.values = values
        self.animations = animations
        self.onKeyFrame = Array(count: durations.count + 1, repeatedValue: nil)
    }
    
    public func updateWith(timeSinceLastUpdate: NSTimeInterval) {
        time += timeSinceLastUpdate
        
        if keyFrame >= durations.count {
            return
        }
        
        if time < durations[keyFrame] {
            let progress = smoothStep(0, to: durations[keyFrame], value: self.time)
            
            var values = [String : GLfloat]()
            for (key, value) in self.values {
                values[key] = valueFor(progress, from: value[keyFrame], to: value[keyFrame + 1])
            }
            animations(values: values)
        } else {
            var values = [String : GLfloat]()
            for (key, value) in self.values {
                values[key] = value[keyFrame + 1]
            }
            animations(values: values)
            
            keyFrame += 1
            
            if let completionBlock = onKeyFrame[keyFrame] {
                onKeyFrame[keyFrame] = nil
                completionBlock()
            }
        }
    }
    
    func valueFor(progress: GLfloat, from: GLfloat, to: GLfloat) -> GLfloat {
        return from + (to - from) * progress
    }
    
}
