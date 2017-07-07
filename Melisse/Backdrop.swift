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
    public private(set) var texCoordPointers = [SurfaceArray<GLfloat>]()
    fileprivate var layerSizes = [Point<Int>]()
    
    fileprivate let tiltEffect = Point(x: tileSize / 4, y: tileSize / 6)
    
    public init(palette: ImagePalette = ImagePalette(), map: Map = Map()) {
        self.palette = palette
        self.map = map
        
        createVerticesAndTextureCoordinates()
    }
    
    convenience public init?(palette: ImagePalette?, map: Map?) {
        if let palette = palette, let map = map {
            self.init(palette: palette, map: map)
        } else {
            return nil
        }
    }
    
    public func draw(at translation: Point<GLfloat> = Point(), tilt: Point<GLfloat> = Point()) {
        Draws.bindTexture(palette.texture)
        
        for index in 0 ..< map.layers.count {
            let layer = map.layers[index]
            
            #if PIXEL_PERFECT
                let layerTranslation = (translation * layer.scrollRate + square((1 - layer.scrollRate) * tilt * tiltEffect)).floored() % layerSizes[index]
            #else
                let layerTranslation = (translation * layer.scrollRate + square((1 - layer.scrollRate) * tilt * tiltEffect)) % layerSizes[index]
            #endif
            
            Draws.translateTo(layerTranslation)
            
            let vertexPointer = vertexPointers[index]
            Draws.drawWith(vertexPointer.memory, texCoordPointer: texCoordPointers[index].memory, count: vertexPointer.count)
        }
    }
    
    private func createVerticesAndTextureCoordinates() {
        for layer in map.layers {
            let vertexPointer = SurfaceArray<GLfloat>(capacity: layer.length * 2, coordinates: coordinatesByVertex)
            let texCoordPointer = SurfaceArray<GLfloat>(capacity: layer.length * 2, coordinates: coordinatesByTexture)
            
            let width = layer.width
            let height = layer.height
            
            for y in 0 ..< height {
                for x in 0 ..< width {
                    if let tile = layer.tileAt(x: x, y: y) {
                        vertexPointer.appendQuad(width: tileSize, height: tileSize, left: GLfloat(x) * tileSize, top: GLfloat(y) * tileSize)
                        texCoordPointer.append(tile: tile, from: palette)

                        vertexPointer.appendQuad(width: tileSize, height: tileSize, left: GLfloat(width + x) * tileSize, top: GLfloat(y) * tileSize)
                        texCoordPointer.append(tile: tile, from: palette)
                    }
                }
            }
            
            vertexPointers.append(vertexPointer)
            texCoordPointers.append(texCoordPointer)
            layerSizes.append(Point(x: width * Int(tileSize), y: height * Int(tileSize)))
        }
    }
    
}

