//
//  HasHitbox.swift
//  Melisse
//
//  Created by Raphaël Calabro on 12/01/2017.
//  Copyright © 2017 Raphaël Calabro. All rights reserved.
//

import Foundation

public protocol HasHitbox {
    
    var hitbox: Hitbox { get }
    
}

public extension HasHitbox {
    
    func collides(with other: HasHitbox) -> Bool {
        return hitbox.collides(with: other.hitbox)
    }
    
    func collides(with hitbox: Hitbox) -> Bool {
        return self.hitbox.collides(with: hitbox)
    }
    
}
