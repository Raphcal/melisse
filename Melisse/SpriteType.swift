//
//  SpriteType.swift
//  Melisse
//
//  Created by Raphaël Calabro on 06/05/2016.
//  Copyright © 2016 Raphaël Calabro. All rights reserved.
//

import Foundation

protocol SpriteType {
    
    var collidable: Bool { get }
    
}

enum DefaultSpriteType: SpriteType {
    
    case Decoration
    
    var collidable: Bool {
        get {
            return false
        }
    }
    
}