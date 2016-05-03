//
//  Scene.swift
//  MeltedIce
//
//  Created by Raphaël Calabro on 29/06/2015.
//  Copyright (c) 2015 Raphaël Calabro. All rights reserved.
//

import Foundation

@objc protocol Scene {
    
    var backgroundColor : Color { get }
    
    /// Chargement initial de la scène. Appelé lors d'une transition vers cette scène.
    optional func load()
    
    /// Rechargement de la scène. La scène est déjà affiché mais elle doit être rechargée (exemple : mort).
    optional func reload()
    
    /// Libération de la scène. Appelé lors de la transition vers une autre scène.
    optional func unload()
    
    /// La vue devient la scène principale du directeur.
    optional func willAppear()
    
    /// Gestion de la mise à jour de la scène.
    func updateWithTimeSinceLastUpdate(timeSinceLastUpdate: NSTimeInterval)
    
    /// Affichage de la scène.
    func draw()
    
}

// TODO: Faire une extension des méthodes load/reload/etc pour permettre la suppression du @objc.

protocol Fade : Scene {
    
    var progress : Float { get set }
    var previousScene : Scene { get set }
    var nextScene : Scene { get set }
    
}

class NoFade : NSObject, Fade {
    
    var progress : Float = 1
    var previousScene : Scene = EmptyScene()
    var nextScene : Scene = EmptyScene()
    var backgroundColor = Color()
    
    func draw() {
        // Pas de dessin.
    }
    
    func updateWithTimeSinceLastUpdate(timeSinceLastUpdate: NSTimeInterval) {
        // Pas de mise à jour.
    }
    
}

