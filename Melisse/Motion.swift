//
//  Motion.swift
//  MeltedIce
//
//  Created by Raphaël Calabro on 29/06/2015.
//  Copyright (c) 2015 Raphaël Calabro. All rights reserved.
//

import Foundation

/// Description d'un gestionnaire de mouvements.
public protocol Motion {
    
    /// Initialisation du mouvement pour le sprite donné.
    mutating func load(sprite : Sprite)
    
    /// Calcul et application du mouvement pour le sprite donné.
    mutating func updateWith(timeSinceLastUpdate: NSTimeInterval, sprite: Sprite)
    
}

public extension Motion {
    
    func load(sprite: Sprite) {
        // Implémentation vide.
    }
    
    func updateWith(timeSinceLastUpdate: NSTimeInterval, sprite: Sprite) {
        // Implémentation vide.
    }
    
}