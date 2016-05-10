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
        self.memory = UnsafeMutablePointer.alloc(total)
        self.vertexesByQuad = vertexesByQuad
    }
    
    deinit {
        memory.destroy()
    }
    
    public func clear() {
        memset(UnsafeMutablePointer<Int8>(memory), 0, capacity * sizeof(Element))
    }
    
    public func clearFrom(index: Int, count: Int) {
        memset(UnsafeMutablePointer<Int8>(memory.advancedBy(index * coordinates)), 0, count * coordinates * sizeof(GLfloat))
    }
    
    public func clearQuadAt(index: Int) {
        clearFrom(index * vertexesByQuad, count: vertexesByQuad)
    }
    
    public func surfaceAt(index: Int) -> Surface<Element> {
        return Surface<Element>(memory: memory, cursor: index * coordinates * vertexesByQuad, coordinates: coordinates, vertexesByQuad: vertexesByQuad)
    }
    
    public func reset() {
        cursor = 0
    }
    
    public func append(value: Element) {
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
    
    public func append(width width: Element, height: Element, left: Element, top: Element) {
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
    
    public func append(color color: Color<Element>) {
        for _ in 0 ..< vertexesByQuad {
            append(color.red)
            append(color.green)
            append(color.blue)
            append(color.alpha)
        }
    }
    
}

public extension SurfaceArray where Element: Signed {
    
    func appendQuad(width width: Element, height: Element, left: Element, top: Element) {
        append(width: width, height: -height, left: left, top: -top)
    }
    
}

public extension SurfaceArray where Element: Integer {
    
    func append(tile tile: Int, from palette: TexturePalette) {
        append(width: Element(palette.tileSize), height: Element(palette.tileSize), left: Element(tile % palette.columns) * Element(palette.tileSize + palette.padding) + Element(palette.padding),
            top: Element(tile / palette.columns) * Element(palette.tileSize + palette.padding) + Element(palette.padding))
    }
    
}
