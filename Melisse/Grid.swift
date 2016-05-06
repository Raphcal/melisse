//
//  Grid.swift
//  MeltedIce
//
//  Created by Raphaël Calabro on 27/06/2015.
//  Copyright (c) 2015 Raphaël Calabro. All rights reserved.
//

import GLKit

class Grid : NSObject {
    
    let groundLayerName = "Piste"
    let waterLayerName = "Eau"
    
    let palette : Palette
    let map : Map
    let foreground : Int
    let ground : Layer
    let water : Layer?
    var vertexPointers = [SurfaceArray]()
    var texCoordPointers = [SurfaceArray]()
    
    override init() {
        self.palette = Palette()
        self.map = Map()
        self.foreground = 0
        self.ground = Layer()
        self.water = nil
        
        super.init()
    }
    
    init(palette: Palette, map: Map) {
        self.palette = palette
        self.map = map
        
        if let ground = map.layerIndex(groundLayerName) {
            self.foreground = ground + 1
            self.ground = map.layers[ground]
        } else {
            self.foreground = 0
            self.ground = map.layers[0]
        }
        
        if let water = map.layerIndex(waterLayerName) {
            self.water = map.layers[water]
        } else {
            self.water = nil
        }
        
        super.init()
        
        createVerticesAndTextureCoordinates()
    }
    
    // MARK: Affichage.
    
    func draw() {
        drawFrom(0, to: map.layers.count)
    }
    
    func drawBackground() {
        drawFrom(0, to: foreground)
    }
    
    func drawForeground() {
        drawFrom(foreground, to: map.layers.count)
    }
    
    private func drawFrom(from: Int, to: Int) {
        Draws.bindTexture(palette.texture)
        
        for index in from..<to {
            let layer = map.layers[index]
            
            Draws.translateTo(Camera.instance.topLeft * layer.scrollRate)
            Draws.drawWithVertexPointer(vertexPointers[index].memory, texCoordPointer: texCoordPointers[index].memory, count: vertexPointers[index].count)
        }
    }
    
    private func createVerticesAndTextureCoordinates() {
        for layer in map.layers {
            let length = layer.length * vertexesByQuad
            let vertexPointer = SurfaceArray(capacity: length, coordinates: coordinatesByVertice)
            let texCoordPointer = SurfaceArray(capacity: length, coordinates: coordinatesByTexture)
            
            for y in 0..<layer.height {
                for x in 0..<layer.width {
                    if let tile = layer.tileAtX(x, y: y) {
                        vertexPointer.appendQuad(x + layer.topLeft.x, y: y + layer.topLeft.y)
                        texCoordPointer.appendTile(tile, fromPalette: palette)
                    }
                }
            }
            
            vertexPointers.append(vertexPointer)
            texCoordPointers.append(texCoordPointer)
        }
    }
    
    // MARK: Fonctions publiques.
    
    func angleAtPoint(point: Point, forDirection direction: Direction) -> GLfloat {
        if let tile = ground.tileAtPoint(point), let tileHitbox = palette.functions[tile] {
            let pixel = Layer.pointInTileAtPoint(point)
            
            let backY = Operation.execute(tileHitbox, x: pixel.x)
            let frontY = Operation.execute(tileHitbox, x: pixel.x + direction.value)
            
            return atan2(frontY - backY, direction.value)
        } else {
            return direction.angle
        }
    }
    
    func angleForVerticalRunAtPoint(point: Point, forDirection direction: Direction, verticalDirection: Direction) -> GLfloat {
        if let x = xInTileAtPoint(point, direction: direction) {
            return atan2(verticalDirection.value, x - point.x)
        } else {
            return verticalDirection.angle
        }
    }
    
    /// Recherche l'emplacement x en fonction de la hauteur du point donné.
    func xInTileAtPoint(point: Point, direction: Direction) -> GLfloat? {
        if let tile = ground.tileAtPoint(Point(x: point.x + direction.value * tileSize / 2, y: point.y)), let tileHitbox = palette.functions[tile] {
            let halfTileSize = Int(tileSize / 2)
            for index in 0 ..< halfTileSize {
                let x = point.x + GLfloat(index) * direction.value
                let pixel = Layer.pointInTileAtPoint(Point(x: x, y: point.y))
                
                let y = Operation.execute(tileHitbox, x: pixel.x)
                if (pixel.y > y) {
                    return x
                }
            }
        }
        return nil
    }
   
}
