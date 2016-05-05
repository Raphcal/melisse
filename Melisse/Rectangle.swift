//
//  Rectangle.swift
//  Melisse
//
//  Created by Raphaël Calabro on 04/05/2016.
//  Copyright © 2016 Raphaël Calabro. All rights reserved.
//

import GLKit

struct Rectangle<Coordinate where Coordinate : Numeric> : Rectangular, Hitbox {
    
    var center: Point<Coordinate>
    var size: Size<Coordinate>

}
