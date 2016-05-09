//
//  Motion.swift
//  MeltedIce
//
//  Created by Raphaël Calabro on 29/06/2015.
//  Copyright (c) 2015 Raphaël Calabro. All rights reserved.
//

import Foundation

/// Description d'un gestionnaire de mouvements.
protocol Motion {
    
    /// Initialisation du mouvement pour le sprite donné.
    func load(sprite : Sprite)
    
    /// Calcul et application du mouvement pour le sprite donné.
    func updateWith(timeSinceLastUpdate: NSTimeInterval, sprite: Sprite)
    
}
