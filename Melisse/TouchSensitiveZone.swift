//
//  TouchSensitiveZone.swift
//  Melisse
//
//  Created by Raphaël Calabro on 22/06/2016.
//  Copyright © 2016 Raphaël Calabro. All rights reserved.
//

import Foundation
import GLKit

/// Zone détectant les taps ou les clics.
public class TouchSensitiveZone : SensitiveZone {
    
    public var selection: ((_ sender: TouchSensitiveZone) -> Void)?
    
    public var pressed = false
    public var pressing = false
    
    public init(frame: Rectangle<GLfloat> = Rectangle(), touches: [UnsafeRawPointer : Point<GLfloat>] = [:]) {
        super.init(hitbox: StaticHitbox(frame: frame), touches: touches)
    }
    
    public init(hasFrame: HasFrame, touches: [UnsafeRawPointer : Point<GLfloat>] = [:]) {
        let frame = hasFrame.frame
        let scale = View.instance.scale
        
        super.init(hitbox: StaticHitbox(frame: Rectangle<GLfloat>(x: frame.x / scale.x, y: frame.y / scale.y, width: frame.width / scale.x, height: frame.height / scale.y)), touches: touches)
    }
    
    public override func touchDown(_ touch: UnsafeRawPointer, at location: Point<GLfloat>) {
        pressing = true
    }
    
    public override func touch(_ touch: UnsafeRawPointer, movedTo location: Point<GLfloat>) {
        super.touch(touch, movedTo: location)
        pressing = states[touch] == .touchDownInside
    }
    
    public override func touchUp(_ touch: UnsafeRawPointer, withState state: TouchState) {
        if state == .touchUpInside {
            selection?(self)
        }
    }
    
}
