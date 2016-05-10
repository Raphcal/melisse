//
//  NoFade.swift
//  Melisse
//
//  Created by Raphaël Calabro on 09/05/2016.
//  Copyright © 2016 Raphaël Calabro. All rights reserved.
//

import GLKit

public struct NoFade: Fade {
    
    public var progress : Float = 1
    public var previousScene : Scene = EmptyScene()
    public var nextScene : Scene = EmptyScene()
    public var backgroundColor = Color<GLfloat>()
    
    public func draw() {
        // Pas de dessin.
    }
    
    public func updateWith(timeSinceLastUpdate: NSTimeInterval) {
        // Pas de mise à jour.
    }
    
}

