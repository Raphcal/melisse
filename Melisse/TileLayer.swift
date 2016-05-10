//
//  TileLayer.swift
//  Melisse
//
//  Created by Raphaël Calabro on 08/05/2016.
//  Copyright © 2016 Raphaël Calabro. All rights reserved.
//

import GLKit

struct TileLayer : Equatable {
    
    var name: String
    var width: Int
    var height: Int
    var tiles: [Int?]
    var scrollRate: Point<GLfloat>
    
    var vertexPointer: SurfaceArray<GLfloat>
    var texCoordPointer: SurfaceArray<GLshort>
    
    init() {
        self.name = ""
        self.width = 0
        self.height = 0
        self.tiles = []
        self.scrollRate = Point()
        self.vertexPointer = SurfaceArray()
        self.texCoordPointer = SurfaceArray()
    }
    
    init(inputStream : NSInputStream, palette: TexturePalette) {
        self.name = Streams.readString(inputStream)
        self.width = Streams.readInt(inputStream)
        self.height = Streams.readInt(inputStream)
        self.scrollRate = Streams.readPoint(inputStream)
        
        let count = Streams.readInt(inputStream)
        
        #if REDUCE_MEMORY_USAGE
            var length = 0
            var tiles = [Int?]()
            for index in 0 ..< count {
                let tile = Streams.readInt(inputStream)
                
                if tile > -1 {
                    tiles.append(tile)
                    length += 1
                } else {
                    tiles.append(nil)
                }
            }
            
            self.tiles = tiles
            self.vertexPointer = SurfaceArray(capacity: length, coordinates: coordinatesByVertex)
            self.texCoordPointer = SurfaceArray(capacity: length, coordinates: coordinatesByTexture)
            
            for (index, tile) in tiles.enumerate() {
                if let tile = tile {
                    let x = index % width
                    let y = index / width
                    
                    vertexPointer.appendQuad(width: tileSize, height: tileSize, left: GLfloat(x) * tileSize, top: GLfloat(y) * tileSize)
                    texCoordPointer.append(tile: tile, from: palette)
                }
            }
        #else
            self.vertexPointer = SurfaceArray(capacity: width * height, coordinates: coordinatesByVertex)
            self.texCoordPointer = SurfaceArray(capacity: width * height, coordinates: coordinatesByTexture)
            
            var tiles = [Int?]()
            for index in 0 ..< count {
                let tile = Streams.readInt(inputStream)
                
                if tile > -1 {
                    tiles.append(tile)
                    
                    let x = index % width
                    let y = index / width
                    vertexPointer.appendQuad(width: tileSize, height: tileSize, left: GLfloat(x) * tileSize, top: GLfloat(y) * tileSize)
                    texCoordPointer.append(tile: tile, from: palette)
                } else {
                    tiles.append(nil)
                }
            }
            self.tiles = tiles
        #endif
    }
    
}

func ==(left: TileLayer, right: TileLayer) -> Bool {
    return left.width == right.width
        && left.height == right.height
        && left.scrollRate == right.scrollRate
        && left.name == right.name
}
