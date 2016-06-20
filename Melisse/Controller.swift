//
//  Controller.swift
//  Melisse
//
//  Created by Raphaël Calabro on 16/05/2016.
//  Copyright © 2016 Raphaël Calabro. All rights reserved.
//

import GLKit

public enum GamePadButton {
    case up, down, left, right, jump, l, r, start
    
    static public let values = [up, down, left, right, jump, l, r, start]
}

public protocol Controller {
    
    var direction: GLfloat { get }
    
    func pressed(_ button: GamePadButton) -> Bool
    func pressing(_ button: GamePadButton) -> Bool
    
}
