//
//  LayerStructure.swift
//  MeltedIce
//
//  Created by Raphaël Calabro on 05/01/2016.
//  Copyright © 2016 Raphaël Calabro. All rights reserved.
//

import GLKit

// TODO: Utiliser ces types à la place de Layer pour permettre le développement d'un mouvement à 360°.

enum TileType {
    
    case Block, Bottom, Right, Top, Left
    
}

class Tile {
    
    let type : TileType = .Bottom
    let operation : [UInt8]? = nil
    
    func top(x: GLfloat) -> GLfloat {
        return Operation.execute(operation, x: x)
    }
    
}

class LayerStructure {
    
    let tiles : [Tile] = []
    
    func topAtPoint(point: Spot) {
        // TODO: voir Map#tileTop et renvoyer ça + tile.top()
    }
    
}
