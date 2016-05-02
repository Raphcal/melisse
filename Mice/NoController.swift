//
//  NoController.swift
//  MeltedIce
//
//  Created by Raphaël Calabro on 30/09/2015.
//  Copyright © 2015 Raphaël Calabro. All rights reserved.
//

import GLKit

/// Pas de contrôle.
class NoController : Controller {
    
    static let instance = NoController()
    
    var direction : GLfloat = 0
    
    func pressed(button: GamePadButton) -> Bool {
        return false
    }
    
    func pressing(button: GamePadButton) -> Bool {
        return false
    }
    
    func draw() {
        // Pas de vue.
    }
    
    func updateWithTouches(touches: [Int:Spot]) {
        // Pas de traitement.
    }
    
}
