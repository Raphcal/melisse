//
//  ColorGrid.swift
//  Melisse
//
//  Created by Raphaël Calabro on 10/05/2016.
//  Copyright © 2016 Raphaël Calabro. All rights reserved.
//

import GLKit

public struct ColorGrid {
    
    public var palette: ColorPalette
    public var map: Map
    
    public var vertexPointers = [SurfaceArray<GLfloat>]()
    public var colorPointers = [SurfaceArray<GLubyte>]()
    
    init(palette: ColorPalette = AlphaColorPalette(), map: Map = Map()) {
        self.palette = palette
        self.map = map
        
        createVerticesAndColorPointers()
    }
    
    private mutating func createVerticesAndColorPointers() {
        for layer in map.layers {
            let vertexPointer = SurfaceArray<GLfloat>(capacity: layer.length, coordinates: coordinatesByVertex)
            let colorPointer = SurfaceArray<GLubyte>(capacity: layer.length, coordinates: coordinatesByColor)
            
            for y in 0..<layer.height {
                for x in 0..<layer.width {
                    if let tile = layer.tileAt(x: x, y: y) {
                        vertexPointer.appendQuad(width: tileSize, height: tileSize, left: GLfloat(x) * tileSize, top: GLfloat(y) * tileSize)
                        colorPointer.append(color: palette.colorFor(tile))
                    }
                }
            }
            
            vertexPointers.append(vertexPointer)
            colorPointers.append(colorPointer)
        }
    }
    
}