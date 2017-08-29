//
//  TouchSensitiveZone.swift
//  Melisse
//
//  Created by Raphaël Calabro on 22/06/2016.
//  Copyright © 2016 Raphaël Calabro. All rights reserved.
//

import Foundation
import GLKit

public class TouchSensitiveZone {
    
    public var frame: Rectangle<GLfloat> {
        didSet {
            hitbox = StaticHitbox(frame: frame)
        }
    }
    public var selection: ((_ sender: TouchSensitiveZone) -> Void)?
    
    var hitbox = StaticHitbox()
    
    var state = true
    var previousState = true
    
    public var pressed: Bool {
        get {
            return state && !previousState
        }
    }
    
    public var pressing: Bool {
        get {
            return state
        }
    }
    
    public init(frame: Rectangle<GLfloat> = Rectangle(), touches: [UnsafeRawPointer : Point<GLfloat>] = [:]) {
        self.frame = frame
        self.hitbox = StaticHitbox(frame: frame)
        
        var pressing = false
        for touch in touches.values {
            pressing = pressing || hitbox.collides(with: touch)
        }
        self.state = pressing
        self.previousState = pressing
    }
    
    public convenience init(hasFrame: HasFrame, touches: [UnsafeRawPointer : Point<GLfloat>] = [:]) {
        let frame = hasFrame.frame
        let scale = View.instance.scale
        
        self.init(frame: Rectangle<GLfloat>(x: frame.x / scale.x, y: frame.y / scale.y, width: frame.width / scale.x, height: frame.height / scale.y), touches: touches)
    }
    
    public func update(with touches: [UnsafeRawPointer : Point<GLfloat>]) {
        var state = false
        for touch in touches.values {
            state = state || hitbox.collides(with: touch)
        }
        
        self.previousState = self.state
        self.state = state
        
        if pressed {
            selection?(self)
        }
    }
    
}
