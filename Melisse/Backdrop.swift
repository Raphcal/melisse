//
//  Backdrop.swift
//  MeltedIce
//
//  Created by Raphaël Calabro on 25/04/2016.
//  Copyright © 2016 Raphaël Calabro. All rights reserved.
//

import GLKit

class Backdrop {
    
    /// Nombre de cases horizontalement.
    static let width = 13
    /// Nombre de cases verticalement.
    static let height = 8
    /// Taille maximum d'une couche.
    static let maximumLength = width * height
    
    let palette : Palette
    let map : Map
    var vertexPointers = [SurfaceArray<GLfloat>]()
    var texCoordPointers = [SurfaceArray<GLshort>]()
    
    init(palette: Palette, map: Map) {
        self.palette = palette
        self.map = map
        
        createVerticesAndTextureCoordinates()
    }
    
    func update(offset offset: GLfloat = 0, tilt: Point<GLfloat> = Point()) {
        for (index, layer) in map.layers.enumerate() {
            let vertexPointer = vertexPointers[index]
            let texCoordPointer = texCoordPointers[index]
            
            let cameraLeft = (Camera.instance.left + offset) * layer.scrollRate.x + rectangle((1 - layer.scrollRate.x) * tilt.x * tileSize / 4)
            
            let cameraTop = Camera.instance.top * layer.scrollRate.y + (1 - layer.scrollRate.y) * tilt.y * tileSize / 2
            
            let left = Int(cameraLeft / tileSize)
            let top = Int(cameraTop / tileSize)
            
            vertexPointer.reset()
            texCoordPointer.reset()
            
            for y in top ..< top + Backdrop.height {
                for x in left ..< left + Backdrop.width {
                    if let tile = layer.tileAtX(x % layer.width, y: y % layer.height) {
                        vertexPointer.appendQuad(tileSize, height: tileSize, left: GLfloat(x) * tileSize - cameraLeft, top: GLfloat(y) * tileSize - cameraTop, distance: 0)
                        texCoordPointer.appendTile(tile, fromPalette: palette)
                    }
                }
            }
        }
    }
    
    func draw() {
        Draws.bindTexture(palette.texture)
        Draws.translateTo(Point())
        
        for index in 0 ..< map.layers.count {
            let vertexPointer = vertexPointers[index]
            let texCoordPointer = texCoordPointers[index]
            
            Draws.drawWithVertexPointer(vertexPointer.memory, texCoordPointer: texCoordPointer.memory, count: vertexPointer.count)
        }
    }
    
    private func createVerticesAndTextureCoordinates() {
        for _ in 0 ..< map.layers.count {
            let vertexPointer = SurfaceArray(capacity: Backdrop.maximumLength * vertexesByQuad, coordinates: coordinatesByVertex)
            let texCoordPointer = SurfaceArray(capacity: Backdrop.maximumLength * vertexesByQuad, coordinates: coordinatesByTexture)
            
            vertexPointers.append(vertexPointer)
            texCoordPointers.append(texCoordPointer)
        }
    }
    
}

