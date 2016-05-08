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
    
    init(inputStream : NSInputStream) {
        self.name = Streams.readString(inputStream)
        self.width = Streams.readInt(inputStream)
        self.height = Streams.readInt(inputStream)
        self.scrollRate = Streams.readPoint(inputStream)
        
        let count = Streams.readInt(inputStream)
        var length = 0
        
        self.tiles = (0 ..< count).map { _ in
            let tile = Streams.readInt(inputStream)
            
            if tile > -1 {
                length += 1
                return tile
            } else {
                return nil
            }
        }

        // TODO: VertexPointer
        
    }
    
}

func ==(left: TileLayer, right: TileLayer) -> Bool {
    return left.width == right.width
        && left.height == right.height
        && left.scrollRate == right.scrollRate
        && left.name == right.name
}