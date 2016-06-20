//
//  NoController.swift
//  MeltedIce
//
//  Created by Raphaël Calabro on 30/09/2015.
//  Copyright © 2015 Raphaël Calabro. All rights reserved.
//

import GLKit

/// Pas de contrôle.
public struct NoController : Controller {
    
    public var direction: GLfloat = 0
    
    public init() {
        // Pas d'initialisation.
    }
    
    public func pressed(_ button: GamePadButton) -> Bool {
        return false
    }
    
    public func pressing(_ button: GamePadButton) -> Bool {
        return false
    }
    
}
