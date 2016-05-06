//
//  Layer.swift
//  MeltedIce
//
//  Created by Raphaël Calabro on 25/04/2016.
//  Copyright © 2016 Raphaël Calabro. All rights reserved.
//

import GLKit

class Layer {
    
    let name : String
    let width : Int
    let height : Int
    let tiles : [Int?]
    let scrollRate : Point
    let length : Int
    let topLeft : (x: Int, y: Int)
    
    init() {
        self.name = ""
        self.width = 0
        self.height = 0
        self.tiles = []
        self.scrollRate = Point()
        self.length = 0
        self.topLeft = (x: 0, y: 0)
    }
    
    init(name: String, width: Int, height: Int, tiles: [Int?], length: Int, scrollRate: Point, topLeft: (x: Int, y: Int)) {
        self.name = name
        self.width = width
        self.height = height
        self.tiles = tiles
        self.length = length
        self.scrollRate = scrollRate
        self.topLeft = topLeft
    }
    
    init(name : String, width : Int, height : Int, tiles : [Int?], scrollRateX : Float, scrollRateY : Float) {
        self.name = name
        self.width = width
        self.height = height
        self.tiles = tiles
        self.scrollRate = Point(x: scrollRateX, y: scrollRateY)
        
        var length = 0
        for tile in tiles {
            if tile > -1 {
                length += 1
            }
        }
        self.length = length
        self.topLeft = (x: 0, y: 0)
    }
    
    init(inputStream : NSInputStream) {
        self.name = Streams.readString(inputStream)
        self.width = Streams.readInt(inputStream)
        self.height = Streams.readInt(inputStream)
        
        let scrollRateX = Streams.readFloat(inputStream)
        let scrollRateY = Streams.readFloat(inputStream)
        self.scrollRate = Point(x: scrollRateX, y: scrollRateY)
        
        let count = Streams.readInt(inputStream)
        var tiles : [Int?] = []
        var length = 0
        
        for _ in 0..<count {
            let tile = Streams.readInt(inputStream)
            
            if tile > -1 {
                tiles.append(tile)
                length += 1
            } else {
                tiles.append(nil)
            }
        }
        
        self.tiles = tiles
        self.length = length
        self.topLeft = (x: 0, y: 0)
    }
    
    func tileAtX(x : Int, y: Int) -> Int? {
        if x >= 0 && x < width && y >= 0 && y < height {
            return tiles[y * width + x]
        } else {
            return nil
        }
    }
    
    func tileAtPoint(point: Point) -> Int? {
        return tileAtX(Int(point.x / tileSize), y: Int(point.y / tileSize))
    }
    
    static func pointInTileAtPoint(point: Point) -> Point {
        return Point(x: point.x % tileSize, y: point.y % tileSize)
    }
    
    static func tileTop(point: Point) -> GLfloat {
        return GLfloat(Int(point.y / tileSize)) * tileSize
    }
    
    static func tileBottom(point: Point) -> GLfloat {
        return GLfloat(Int(point.y / tileSize) + 1) * tileSize
    }
    
    static func tileBorder(point: Point, direction: Direction) -> GLfloat {
        return GLfloat(Int(point.x / tileSize) + direction.rawValue) * tileSize
    }
    
}

func % (left: GLfloat, right: GLfloat) -> GLfloat {
    let division = left / right
    return (division - floor(division)) * right
}

