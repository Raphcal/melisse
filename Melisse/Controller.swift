//
//  Controller.swift
//  Melisse
//
//  Created by Raphaël Calabro on 16/05/2016.
//  Copyright © 2016 Raphaël Calabro. All rights reserved.
//

import GLKit

public enum GamePadButton {
    case Up, Down, Left, Right, Jump, L, R, Start
    
    static public let values = [Up, Down, Left, Right, Jump, L, R, Start]
}

public protocol Controller {
    
    var direction: GLfloat { get }
    
    func pressed(button: GamePadButton) -> Bool
    func pressing(button: GamePadButton) -> Bool
    func draw()
    
}

public extension Controller {
    
    func draw() {
        // Pas d'affichage.
    }
    
}