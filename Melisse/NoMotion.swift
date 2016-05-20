//
//  NoMotion.swift
//  Melisse
//
//  Created by Raphaël Calabro on 08/05/2016.
//  Copyright © 2016 Raphaël Calabro. All rights reserved.
//

import Foundation

/// Gestionnaire vide, aucun mouvement.
public struct NoMotion : Motion {
    
    public init() {
        // Pas d'initialisation.
    }
    
    public func load(sprite: Sprite) {
        // Pas de chargement.
    }
    
    public func updateWith(timeSinceLastUpdate: NSTimeInterval, sprite: Sprite) {
        // Pas de mouvement.
    }
    
}
