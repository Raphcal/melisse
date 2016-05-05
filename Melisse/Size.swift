//
//  Size.swift
//  Melisse
//
//  Created by Raphaël Calabro on 04/05/2016.
//  Copyright © 2016 Raphaël Calabro. All rights reserved.
//

import Foundation

struct Size<Coordinate where Coordinate : Numeric> {
    
    var width: Coordinate
    var height: Coordinate
    
    init() {
        self.width = Coordinate(0)
        self.height = Coordinate(0)
    }
    
    init(width: Coordinate, height: Coordinate) {
        self.width = width
        self.height = height
    }
    
}