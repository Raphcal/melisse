//
//  Scene.swift
//  MeltedIce
//
//  Created by Raphaël Calabro on 29/06/2015.
//  Copyright (c) 2015 Raphaël Calabro. All rights reserved.
//

import GLKit

public protocol Scene {
    
    var backgroundColor : Color<GLfloat> { get }
    
    /// Chargement initial de la scène. Appelé lors d'une transition vers cette scène.
    func load()
    
    /// Rechargement de la scène. La scène est déjà affiché mais elle doit être rechargée (exemple : mort).
    func reload()
    
    /// Libération de la scène. Appelé lors de la transition vers une autre scène.
    func unload()
    
    /// La vue devient la scène principale du directeur.
    func willAppear()
    
    /// Gestion de la mise à jour de la scène.
    func updateWith(_ timeSinceLastUpdate: TimeInterval)
    
    /// Affichage de la scène.
    func draw()
    
}

public extension Scene {
    
    func load() {
        // Implémentation par défaut. Méthode vide.
    }
    
    func reload() {
        // Implémentation par défaut. Méthode vide.
    }
    
    func unload() {
        // Implémentation par défaut. Méthode vide.
    }
    
    func willAppear() {
        // Implémentation par défaut. Méthode vide.
    }
    
}
