//
//  EmptyScene.swift
//  Melisse
//
//  Created by Raphaël Calabro on 09/05/2016.
//  Copyright © 2016 Raphaël Calabro. All rights reserved.
//

import GLKit

public struct EmptyScene: Scene {
    
    public var backgroundColor = Color<GLfloat>()
    
    public func updateWith(_ timeSinceLastUpdate: TimeInterval) {
        // Pas de mise à jour.
    }
    
    public func draw() {
        // Pas d'affichage.
    }
    
}
