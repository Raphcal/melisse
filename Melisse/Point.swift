//
//  Point.swift
//  MeltedIce
//
//  Created by Raphaël Calabro on 28/06/2015.
//  Copyright (c) 2015 Raphaël Calabro. All rights reserved.
//

import GLKit

struct Point<Coordinate where Coordinate : Numeric> : Coordinates {
    
    var x: Coordinate
    var y: Coordinate
    
}