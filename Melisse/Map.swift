//
//  Layer.swift
//  MeltedIce
//
//  Created by Raphaël Calabro on 26/06/2015.
//  Copyright (c) 2015 Raphaël Calabro. All rights reserved.
//

import GLKit

public struct Map : Equatable {
    
    static let fileExtension = "map"
    
    public var width: Int
    public var height: Int
    public var backgroundColor: Color<GLfloat>
    public var layers: [Layer]
    
    public init() {
        self.width = 0
        self.height = 0
        self.backgroundColor = Color()
        self.layers = []
    }
    
    public init(layers: [Layer], backgroundColor: Color<GLfloat> = Color()) {
        self.layers = layers
        self.backgroundColor = backgroundColor
        
        var maxWidth = 0
        var maxHeight = 0
        
        for layer in layers {
            if layer.width > maxWidth {
                maxWidth = layer.width
            }
            if layer.height > maxHeight {
                maxHeight = layer.height
            }
        }
        
        self.width = maxWidth
        self.height = maxHeight
    }
    
    public init(inputStream : NSInputStream) {
        self.backgroundColor = Streams.readColor(inputStream)
        
        var maxWidth = 0
        var maxHeight = 0
        
        let count = Streams.readInt(inputStream)
        self.layers = (0 ..< count).map { _ in
            let layer = Layer(inputStream: inputStream)
            
            if layer.width > maxWidth {
                maxWidth = layer.width
            }
            if layer.height > maxHeight {
                maxHeight = layer.height
            }
            
            return layer
        }
        self.width = maxWidth
        self.height = maxHeight
    }
    
    public init?(resource : String) {
        if let url = NSBundle.mainBundle().URLForResource(resource, withExtension: Map.fileExtension), let inputStream = NSInputStream(URL: url) {
            inputStream.open()
            self.init(inputStream: inputStream)
            inputStream.close()
        } else {
            print("Map: resource '\(resource)' not found.")
            return nil
        }
    }
    
    public func indexOfLayer(named name: String) -> Int? {
        return layers.indexOf({ (layer) -> Bool in
            layer.name == name
        })
    }
    
    public func mapFromVisibleRect() -> Map {
        var layers = [Layer]()
        
        for layer in self.layers {
            let left = Int(floor(Camera.instance.frame.left * layer.scrollRate.x / tileSize))
            let right = Int(ceil(Camera.instance.frame.right * layer.scrollRate.x / tileSize))
            let top = Int(floor(Camera.instance.frame.top * layer.scrollRate.y / tileSize))
            let bottom = Int(ceil(Camera.instance.frame.bottom * layer.scrollRate.y / tileSize))
            
            var tiles = [Int?]()
            var count = 0
            
            for y in top..<bottom {
                for x in left..<right {
                    let tile = layer.tileAt(x, y: y)
                    tiles.append(tile)
                    
                    if tile != nil {
                        count += 1
                    }
                }
            }
            
            layers.append(Layer(name: layer.name, width: right - left, height: bottom - top, tiles: tiles, length: count, scrollRate: layer.scrollRate, topLeft: (x: left, y: top)))
        }
        
        return Map(layers: layers, backgroundColor: self.backgroundColor)
    }
}

public func ==(lhs: Map, rhs: Map) -> Bool {
    // TODO: Écrire la méthode.
    return false
}