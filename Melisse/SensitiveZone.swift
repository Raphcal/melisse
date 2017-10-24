//
//  SensitiveZone.swift
//  Melisse
//
//  Created by Raphaël Calabro on 31/08/2017.
//  Copyright © 2017 Raphaël Calabro. All rights reserved.
//

import Foundation
import GLKit

public class SensitiveZone {

    public var hitbox: Hitbox
    public var states = [UnsafeRawPointer : TouchState]()
    
    public init(hitbox: Hitbox, touches: [UnsafeRawPointer : Point<GLfloat>]) {
        self.hitbox = hitbox
        for (touch, _) in touches {
            self.states[touch] = .invalid
        }
    }
    
    public func update(with touches: [UnsafeRawPointer : Point<GLfloat>]) {
        var updatedStates = [UnsafeRawPointer : TouchState]()
        for (touch, location) in touches {
            if let state = states[touch] {
                updatedStates[touch] = state
                if state != .invalid {
                    self.touch(touch, movedTo: location)
                }
            } else {
                if hitbox.collides(with: location) {
                    updatedStates[touch] = .touchDownInside
                    self.touchDown(touch, at: location)
                } else {
                    updatedStates[touch] = .invalid
                }
            }
        }
        
        for (touch, state) in states {
            if state != .invalid && updatedStates[touch] == nil {
                self.touchUp(touch, withState: state == .touchDownInside ? .touchUpInside : .touchUpOutside)
            }
        }
        self.states = updatedStates
    }
    
    open func touchDown(_ touch: UnsafeRawPointer, at location: Point<GLfloat>) {
        // Pas de traitement
    }
    
    open func touch(_ touch: UnsafeRawPointer, movedTo location: Point<GLfloat>) {
        self.states[touch] = hitbox.collides(with: location) ? .touchDownInside : .touchDownOutside
    }
    
    open func touchUp(_ touch: UnsafeRawPointer, withState state: TouchState) {
        // Pas de traitement
    }
    
}
