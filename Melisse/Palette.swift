//
//  Palette.swift
//  MeltedIce
//
//  Created by Raphaël Calabro on 26/06/2015.
//  Copyright (c) 2015 Raphaël Calabro. All rights reserved.
//

import GLKit

public protocol Palette {
}

public protocol ColorPalette {
    
    func colorFor(tile: Int) -> Color<GLubyte>
    
}