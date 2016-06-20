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
    mutating func load(_ sprite: Sprite)
    
    /// Nettoyage du mouvement pour le sprite donné.
    mutating func unload(_ sprite: Sprite)
    
    /// Calcul et application du mouvement pour le sprite donné.
    mutating func updateWith(_ timeSinceLastUpdate: TimeInterval, sprite: Sprite)
    
}

public extension Motion {
    
    func load(_ sprite: Sprite) {
        // Implémentation vide.
    }
    
    func unload(_ sprite: Sprite) {
        // Implémentation vide.
    }
    
    func updateWith(_ timeSinceLastUpdate: TimeInterval, sprite: Sprite) {
        // Implémentation vide.
    }
    
}
