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
    
    public var frame: Rectangle<GLfloat>
    public var selection: ((sender: TouchSensitiveZone) -> Void)?
    
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
    
    public init(frame: Rectangle<GLfloat> = Rectangle()) {
        self.frame = frame
    }
    
    public func update(with touches: [UnsafePointer<Void> : Point<GLfloat>]) {
        // TODO: Implémenter le zoom ?
        let zoom: GLfloat = 1
        for touch in touches.values {
            self.state = state || hitbox.collidesWith(touch * zoom)
        }
    }
    
}
