//
//  Grid.swift
//  MeltedIce
//
//  Created by Raphaël Calabro on 27/06/2015.
//  Copyright (c) 2015 Raphaël Calabro. All rights reserved.
//

import GLKit

public struct Grid {
    
    let groundLayerName = "Piste"
    let waterLayerName = "Eau"
    
    public var palette: Palette
    public var map: Map
    public var foreground: Int
    public var ground: Layer
    public var water: Layer?
    public var vertexPointers = [SurfaceArray<GLfloat>]()
    public var texCoordPointers = [SurfaceArray<GLshort>]()
    
    init() {
        self.palette = Palette()
        self.map = Map()
        self.foreground = 0
        self.ground = Layer()
        self.water = nil
    }
    
    init(palette: Palette, map: Map) {
        self.palette = palette
        self.map = map
        
        if let ground = map.indexOfLayer(named: groundLayerName) {
            self.foreground = ground + 1
            self.ground = map.layers[ground]
        } else {
            self.foreground = 0
            self.ground = map.layers[0]
        }
        
        self.water = map.layerNamed(waterLayerName)
    }
    
    // MARK: Affichage.
    
    public func drawBackground() {
        draw(to: foreground)
    }
    
    public func drawForeground() {
        draw(from: foreground, to: map.layers.count)
    }
    
    public func draw(from from: Int = 0, to: Int) {
        Draws.bindTexture(palette.texture)
        
        for index in from ..< to {
            let layer = map.layers[index]
            
            Draws.translateTo(Camera.instance.frame.topLeft * layer.scrollRate)
            Draws.drawWithVertexPointer(vertexPointers[index].memory, texCoordPointer: texCoordPointers[index].memory, count: vertexPointers[index].count)
        }
    }
    
    // MARK: Fonctions publiques.
    
    func angleAt(point: Point<GLfloat>, direction: Direction) -> GLfloat {
        if let tile = ground.tileAt(point: point), let tileHitbox = palette.functions[tile] {
            let pixel = Layer.pointInTileAt(point)
            
            let backY = Operation.execute(tileHitbox, x: pixel.x)
            let frontY = Operation.execute(tileHitbox, x: pixel.x + direction.value)
            
            return atan2(frontY - backY, direction.value)
        } else {
            return direction.angle
        }
    }
    
    func angleForVerticalRunAt(point: Point<GLfloat>, forDirection direction: Direction, verticalDirection: Direction) -> GLfloat {
        if let x = xInTileAt(point, direction: direction) {
            return atan2(verticalDirection.value, x - point.x)
        } else {
            return verticalDirection.angle
        }
    }
    
    /// Recherche l'emplacement x en fonction de la hauteur du point donné.
    func xInTileAt(point: Point<GLfloat>, direction: Direction) -> GLfloat? {
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
   
}
