//
//  SurfaceArray.swift
//  MeltedIce
//
//  Created by Raphaël Calabro on 07/12/2015.
//  Copyright © 2015 Raphaël Calabro. All rights reserved.
//

import Foundation

class SurfaceArray<Element where Element: Numeric> {
    
    let memory: UnsafeMutablePointer<Element>
    let capacity: Int
    let coordinates: Int
    
    var count: GLsizei {
        get {
            return GLsizei(cursor / coordinates)
        }
    }
    
    private var cursor: Int = 0
    
    convenience init() {
        self.init(capacity: 0, coordinates: 0)
    }
    
    init(capacity: Int, coordinates: Int) {
        let total = capacity * coordinates
        
        self.capacity = total
        self.coordinates = coordinates
        self.memory = UnsafeMutablePointer.alloc(total)
    }
    
    deinit {
        memory.destroy()
    }
    
    func clear() {
        memset(UnsafeMutablePointer<Int8>(memory), 0, capacity * sizeof(Element))
    }
    
    func clearFrom(index: Int, count: Int) {
        memset(UnsafeMutablePointer<Int8>(memory.advancedBy(index * coordinates)), 0, count * coordinates * sizeof(GLfloat))
    }
    
    func clearQuadAt(index: Int) {
        clearFrom(index * vertexesByQuad, count: vertexesByQuad)
    }
    
    func reset() {
        cursor = 0
    }
    
    func surfaceAt(index: Int) -> Surface<Element> {
        return Surface<Element>(memory: memory, cursor: index * coordinates * vertexesByQuad, coordinates: coordinates)
    }
    
    func append(value: Element) {
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
    
    func append(width width: Element, height: Element, left: Element, top: Element) {
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
    
}

extension SurfaceArray where Element: Signed {
    
    func appendQuad(width width: Element, height: Element, left: Element, top: Element) {
        append(width: width, height: -height, left: left, top: -top)
    }
    
}

extension SurfaceArray where Element: Integer {
    
    func appendTile(tile: Int, from palette: Palette) {
        // TODO: Écrire la méthode.
        appendTile(width: palette.tileWidth, height: palette.tileHeight, left: (tile % palette.columns) * (palette.tileWidth + palette.paddingX) + palette.paddingX,
            top: (tile / palette.columns) * (palette.tileHeight + palette.paddingY) + palette.paddingY)
    }
    
}
