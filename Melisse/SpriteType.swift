//
//  SpriteType.swift
//  Melisse
//
//  Created by Raphaël Calabro on 06/05/2016.
//  Copyright © 2016 Raphaël Calabro. All rights reserved.
//

import Foundation

public protocol SpriteType {
    
    var group: String { get }
    
}

public enum DefaultSpriteType: SpriteType {
    
    case decoration
    
    public var group: String {
        return "decoration"
    }
    
}
