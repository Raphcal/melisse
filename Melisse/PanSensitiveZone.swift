//
//  PanSensitiveZone.swift
//  Melisse
//
//  Created by Raphaël Calabro on 31/08/2017.
//  Copyright © 2017 Raphaël Calabro. All rights reserved.
//

import Foundation
import GLKit

public class PanSensitiveZone : SensitiveZone {
    
    public let frame: Rectangle<GLfloat>
    var trackedFinger: UnsafeRawPointer? = nil
    var oldLocation = Point<GLfloat>()
    
    public var translation = Point<GLfloat>()
    public var isPaning: Bool {
        return trackedFinger != nil
    }
    
    public init(frame: Rectangle<GLfloat>, touches: [UnsafeRawPointer : Point<GLfloat>] = [:]) {
        self.frame = frame
        let scale = View.instance.scale
        
        super.init(hitbox: StaticHitbox(frame: Rectangle<GLfloat>(x: frame.x / scale.x, y: frame.y / scale.y, width: frame.width / scale.x, height: frame.height / scale.y)), touches: touches)
    }
    
    public override func touchDown(_ touch: UnsafeRawPointer, at location: Point<GLfloat>) {
        if trackedFinger == nil {
            trackedFinger = touch
            translation = Point()
            oldLocation = location
        }
    }
    
    public override func touch(_ touch: UnsafeRawPointer, movedTo location: Point<GLfloat>) {
        if touch == trackedFinger || trackedFinger == nil {
            trackedFinger = touch
            let newLocation = location * View.instance.scale
            translation = newLocation - oldLocation
            oldLocation = newLocation
        }
    }
    
    public override func touchUp(_ touch: UnsafeRawPointer, withState state: TouchState) {
        if touch == trackedFinger {
            trackedFinger = nil
            translation = Point()
            oldLocation = Point()
        }
    }
    
}
