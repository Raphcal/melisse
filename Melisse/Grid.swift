//
//  Grid.swift
//  MeltedIce
//
//  Created by Raphaël Calabro on 27/06/2015.
//  Copyright (c) 2015 Raphaël Calabro. All rights reserved.
//

import GLKit

public class Grid {
    
    let groundLayerName = "Piste"
    let waterLayerName = "Eau"
    
    public let palette: ImagePalette
    public let map: Map
    public let foreground: Int
    public let ground: Layer
    public let water: Layer?
    public private(set) var vertexPointers = [SurfaceArray<GLfloat>]()
    public private(set) var texCoordPointers = [SurfaceArray<GLushort>]()
    
    public init(palette: ImagePalette = ImagePalette(), map: Map = Map()) {
        self.palette = palette
        self.map = map
        
        if let ground = map.indexOfLayer(named: groundLayerName) {
            self.foreground = ground + 1
            self.ground = map.layers[ground]
        } else if map.layers.count > 0 {
            self.foreground = 0
            self.ground = map.layers[0]
        } else {
            self.foreground = 0
            self.ground = Layer()
        }
        
        self.water = map.layerNamed(waterLayerName)
        
        createVerticesAndTexturePointers()
    }
    
    // MARK: Affichage.
    
    public func draw(at translation: Point<GLfloat> = Point()) {
        draw(at: translation, to: map.layers.count)
    }
    
    public func draw(at translation: Point<GLfloat> = Point(), from: Int = 0, to: Int) {
        Draws.bindTexture(palette.texture)
        
        for index in from ..< to {
            let layer = map.layers[index]
            
            Draws.translateTo(translation * layer.scrollRate)
            Draws.drawWithVertexPointer(vertexPointers[index].memory, texCoordPointer: texCoordPointers[index].memory, count: vertexPointers[index].count)
        }
    }
    
    public func drawBackground() {
        draw(to: foreground)
    }
    
    public func drawForeground() {
        draw(from: foreground, to: map.layers.count)
    }
    
    // MARK: Fonctions publiques.
    
    public func angleAt(point: Point<GLfloat>, direction: Direction) -> GLfloat {
        if let tile = ground.tileAt(point: point), let tileHitbox = palette.functions[tile] {
            let pixel = Layer.pointInTileAt(point)
            
            let backY = Operation.execute(tileHitbox, x: pixel.x)
            let frontY = Operation.execute(tileHitbox, x: pixel.x + direction.value)
            
            return atan2(frontY - backY, direction.value)
        } else {
            return direction.angle
        }
    }
    
    public func angleForVerticalRunAt(point: Point<GLfloat>, forDirection direction: Direction, verticalDirection: Direction) -> GLfloat {
        if let x = xInTileAt(point, direction: direction) {
            return atan2(verticalDirection.value, x - point.x)
        } else {
            return verticalDirection.angle
        }
    }
    
    /// Recherche l'emplacement x en fonction de la hauteur du point donné.
    public func xInTileAt(point: Point<GLfloat>, direction: Direction) -> GLfloat? {
        if let tile = ground.tileAt(point: Point(x: point.x + direction.value * tileSize / 2, y: point.y)), let tileHitbox = palette.functions[tile] {
            let halfTileSize = Int(tileSize / 2)
            for index in 0 ..< halfTileSize {
                let x = point.x + GLfloat(index) * direction.value
                let pixel = Layer.pointInTileAt(Point(x: x, y: point.y))
                
                let y = Operation.execute(tileHitbox, x: pixel.x)
                if (pixel.y > y) {
                    return x
                }
            }
        }
        return nil
    }
    
    private func createVerticesAndTexturePointers() {
        for layer in map.layers {
            let vertexPointer = SurfaceArray<GLfloat>(capacity: layer.length, coordinates: coordinatesByVertex)
            let texCoordPointer = SurfaceArray<GLushort>(capacity: layer.length, coordinates: coordinatesByTexture)
            
            for y in 0..<layer.height {
                for x in 0..<layer.width {
                    if let tile = layer.tileAt(x: x, y: y) {
                        vertexPointer.appendQuad(width: tileSize, height: tileSize, left: GLfloat(x) * tileSize, top: GLfloat(y) * tileSize)
                        texCoordPointer.append(tile: tile, from: palette)
                    }
                }
            }
            
            vertexPointers.append(vertexPointer)
            texCoordPointers.append(texCoordPointer)
        }
    }
   
}


