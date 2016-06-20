//
//  SurfaceArray.swift
//  MeltedIce
//
//  Created by Raphaël Calabro on 07/12/2015.
//  Copyright © 2015 Raphaël Calabro. All rights reserved.
//

import GLKit

public class SurfaceArray<Element where Element: Numeric> {
    
    public let memory: UnsafeMutablePointer<Element>
    public let capacity: Int
    public let coordinates: Int
    public let vertexesByQuad: Int
    
    public var count: GLsizei {
        get {
            return GLsizei(cursor / coordinates)
        }
    }
    
    private var cursor: Int = 0
    
    public convenience init() {
        self.init(capacity: 0, coordinates: 0)
    }
    
    public init(capacity: Int, coordinates: Int, vertexesByQuad: Int = Melisse.vertexesByQuad) {
        let total = capacity * coordinates * vertexesByQuad
        
        self.capacity = total
        self.coordinates = coordinates
        self.memory = UnsafeMutablePointer(allocatingCapacity: total)
        self.vertexesByQuad = vertexesByQuad
    }
    
    deinit {
        memory.deinitialize()
    }
    
    public func clear() {
        memset(UnsafeMutablePointer<Int8>(memory), 0, capacity * sizeof(Element))
    }
    
    public func clearFrom(_ index: Int, count: Int) {
        memset(UnsafeMutablePointer<Int8>(memory.advanced(by: index * coordinates)), 0, count * coordinates * sizeof(GLfloat))
    }
    
    public func clearQuadAt(_ index: Int) {
        clearFrom(index * vertexesByQuad, count: vertexesByQuad)
    }
    
    public func surfaceAt(_ index: Int) -> Surface<Element> {
        return Surface<Element>(memory: memory.advanced(by: index * coordinates * vertexesByQuad), coordinates: coordinates, vertexesByQuad: vertexesByQuad)
    }
    
    public func reset() {
        cursor = 0
    }
    
    public func append(_ value: Element) {
        #if CHECK_CAPACITY
            if cursor < capacity {
                memory[cursor] = value
                cursor += 1
            } else {
                NSLog("append: capacité insuffisante (\(capacity)).")
            }
        #else
            memory[cursor] = value
            cursor += 1
        #endif
    }
    
    public func append(width: Element, height: Element, left: Element, top: Element) {
        // Bas gauche
        append(left)
        append(top + height)
        
        // (idem)
        append(left)
        append(top + height)
        
        // Bas droite
        append(left + width)
        append(top + height)
        
        // Haut gauche
        append(left)
        append(top)
        
        // Haut droite
        append(left + width)
        append(top)
        
        // (idem)
        append(left + width)
        append(top)
    }
    
    public func append(color: Color<Element>) {
        for _ in 0 ..< vertexesByQuad {
            append(color.red)
            append(color.green)
            append(color.blue)
            append(color.alpha)
        }
    }
    
}

public extension SurfaceArray where Element: Signed {
    
    func appendQuad(width: Element, height: Element, left: Element, top: Element) {
        append(width: width, height: -height, left: left, top: -top)
    }
    
    func append(tile: Int, from palette: ImagePalette) {
        append(width: Element(palette.textureTileSize), height: Element(palette.textureTileSize), left: Element(tile % palette.columns) * Element(palette.textureTileSize + palette.texturePadding) + Element(palette.texturePadding),
               top: Element(tile / palette.columns) * Element(palette.textureTileSize + palette.texturePadding) + Element(palette.texturePadding))
    }
    
}
