//
//  Backdrop.swift
//  MeltedIce
//
//  Created by Raphaël Calabro on 25/04/2016.
//  Copyright © 2016 Raphaël Calabro. All rights reserved.
//

import GLKit

public class Backdrop {
    
    public let palette: ImagePalette
    public let map: Map
    public private(set) var vertexPointers = [SurfaceArray<GLfloat>]()
    public private(set) var texCoordPointers = [SurfaceArray<GLshort>]()
    
    private let width: Int
    private let height: Int
    
    public init(palette: ImagePalette = ImagePalette(), map: Map = Map()) {
        self.palette = palette
        self.map = map
        
        self.width = Int(ceil(View.instance.width / tileSize) + 2)
        self.height = Int(ceil(View.instance.height / tileSize) + 2)
        
        createVerticesAndTextureCoordinates()
    }
    
    public func update(offset offset: GLfloat = 0, tilt: Point<GLfloat> = Point()) {
        for (index, layer) in map.layers.enumerate() {
            let vertexPointer = vertexPointers[index]
            let texCoordPointer = texCoordPointers[index]
            
            let cameraLeft = (Camera.instance.frame.left + offset) * layer.scrollRate.x + rectangle((1 - layer.scrollRate.x) * tilt.x * tileSize / 4)
            
            let cameraTop = Camera.instance.frame.top * layer.scrollRate.y + (1 - layer.scrollRate.y) * tilt.y * tileSize / 2
            
            let left = Int(cameraLeft / tileSize)
            let top = Int(cameraTop / tileSize)
            
            vertexPointer.reset()
            texCoordPointer.reset()
            
            for y in top ..< top + height {
                for x in left ..< left + width {
                    if let tile = layer.tileAt(x: x % layer.width, y: y % layer.height) {
                        vertexPointer.appendQuad(width: tileSize, height: tileSize, left: GLfloat(x) * tileSize - cameraLeft, top: GLfloat(y) * tileSize - cameraTop)
                        texCoordPointer.append(tile: tile, from: palette)
                    }
                }
            }
        }
    }
    
    public func draw() {
        Draws.bindTexture(palette.texture)
        Draws.translateTo(Point())
        
        for index in 0 ..< map.layers.count {
            let vertexPointer = vertexPointers[index]
            let texCoordPointer = texCoordPointers[index]
            
            Draws.drawWithVertexPointer(vertexPointer.memory, texCoordPointer: texCoordPointer.memory, count: vertexPointer.count)
        }
    }
    
    private func createVerticesAndTextureCoordinates() {
        let maximumLength = width * height
        
        for _ in 0 ..< map.layers.count {
            let vertexPointer = SurfaceArray<GLfloat>(capacity: maximumLength * vertexesByQuad, coordinates: coordinatesByVertex)
            let texCoordPointer = SurfaceArray<GLshort>(capacity: maximumLength * vertexesByQuad, coordinates: coordinatesByTexture)
            
            vertexPointers.append(vertexPointer)
            texCoordPointers.append(texCoordPointer)
        }
    }
    
}

