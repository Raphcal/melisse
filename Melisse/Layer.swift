//
//  Layer.swift
//  MeltedIce
//
//  Created by Raphaël Calabro on 25/04/2016.
//  Copyright © 2016 Raphaël Calabro. All rights reserved.
//

import GLKit

public struct Layer : Equatable {
    
    public var name: String
    public var width: Int
    public var height: Int
    public var tiles: [Int?]
    public var scrollRate: Point<GLfloat>
    public var length: Int
    
    public init() {
        self.name = ""
        self.width = 0
        self.height = 0
        self.tiles = []
        self.scrollRate = Point()
        self.length = 0
    }
    
    public init(name: String = "", width: Int, height: Int, tiles: [Int?], scrollRate: Point<GLfloat> = Point()) {
        self.name = name
        self.width = width
        self.height = height
        self.tiles = tiles
        self.scrollRate = scrollRate
        
        var length = 0
        for tile in tiles {
            if let tile = tile, tile > -1 {
                length += 1
            }
        }
        self.length = length
    }
    
    public init(inputStream : InputStream) {
        self.name = Streams.readString(inputStream)
        self.width = Streams.readInt(inputStream)
        self.height = Streams.readInt(inputStream)
        self.scrollRate = Streams.readPoint(inputStream)
        
        var length = 0
        let count = Streams.readInt(inputStream)
        
        self.tiles = (0 ..< count).map { _ in
            let tile = Streams.readInt(inputStream)
            
            if tile > -1 {
                length += 1
                return tile
            } else {
                return nil
            }
        }
        self.length = length
    }
    
    public mutating func setTilesAndLengthFrom(_ array: [Int]) {
        var length = 0
        self.tiles = array.map { tile in
            if tile > -1 {
                length += 1
                return tile
            } else {
                return nil
            }
        }
        self.length = length
    }
    
    public func tileAt(x: Int, y: Int) -> Int? {
        if x >= 0 && x < width && y >= 0 && y < height {
            return tiles[y * width + x]
        } else {
            return nil
        }
    }
    
    public func tileAt(_ point: Point<GLfloat>) -> Int? {
        return tileAt(x: Int(point.x / tileSize), y: Int(point.y / tileSize))
    }
    
    public static func pointInTileAt(_ point: Point<GLfloat>) -> Point<GLfloat> {
        return Point(x: point.x % tileSize, y: point.y % tileSize)
    }
    
    public static func tileTop(_ point: Point<GLfloat>) -> GLfloat {
        return GLfloat(Int(point.y / tileSize)) * tileSize
    }
    
    public static func tileBottom(_ point: Point<GLfloat>) -> GLfloat {
        return GLfloat(Int(point.y / tileSize) + 1) * tileSize
    }
    
    public static func tileBorder(_ point: Point<GLfloat>, direction: Direction) -> GLfloat {
        return GLfloat(Int(point.x / tileSize) + direction.rawValue) * tileSize
    }
    
}

public func ==(left: Layer, right: Layer) -> Bool {
    return left.width == right.width
        && left.height == right.height
        && left.length == right.length
        && left.scrollRate == right.scrollRate
        && left.name == right.name
}

