//
//  Palette.swift
//  MeltedIce
//
//  Created by Raphaël Calabro on 26/06/2015.
//  Copyright (c) 2015 Raphaël Calabro. All rights reserved.
//

import GLKit

public protocol Palette {
    var functions: [[UInt8]?] { get }
}

public protocol TexturePalette : Palette {
    var texture: GLKTextureInfo { get }
    
    var tileSize: GLshort { get }
    var padding: GLshort { get }
    var columns: Int { get }
    
    func loadTexture()
}

public protocol ColorPalette : Palette {
    func colorFor(tile: Int) -> Color<GLubyte>
}
