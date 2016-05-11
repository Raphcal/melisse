//
//  SpriteType.swift
//  Melisse
//
//  Created by Raphaël Calabro on 06/05/2016.
//  Copyright © 2016 Raphaël Calabro. All rights reserved.
//

import Foundation

public protocol SpriteType {
    
    var collidable: Bool { get }
    
}

public enum DefaultSpriteType: SpriteType {
    
    case Decoration
    
    public var collidable: Bool {
        get {
            return false
        }
    }
    
}