//
//  SurfaceArray.swift
//  MeltedIce
//
//  Created by Raphaël Calabro on 07/12/2015.
//  Copyright © 2015 Raphaël Calabro. All rights reserved.
//

import GLKit

public class SurfaceArray<Element> where Element: Numeric {
    
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
    
    private var didAllocateMemory: Bool
    
    public convenience init() {
        self.init(capacity: 0, coordinates: 0)
    }
    
    public init(capacity: Int, coordinates: Int, vertexesByQuad: Int = Melisse.vertexesByQuad) {
        let total = capacity * coordinates * vertexesByQuad
        
        self.capacity = total
        self.coordinates = coordinates
        self.memory = UnsafeMutablePointer.allocate(capacity: total)
        self.didAllocateMemory = true
        self.vertexesByQuad = vertexesByQuad
    }
    
    public init(parent: SurfaceArray<Element>, capacity: Int) {
        self.coordinates = parent.coordinates
        self.vertexesByQuad = parent.vertexesByQuad
        self.capacity = capacity * coordinates * vertexesByQuad
        self.memory = parent.memory.advanced(by: parent.cursor)
        self.didAllocateMemory = false
        
        parent.cursor += capacity * coordinates * vertexesByQuad
    }
    
    deinit {
        if didAllocateMemory {
            memory.deinitialize()
        }
    }
    
    public func clear() {
        let size = capacity * MemoryLayout<Element>.size
        memory.withMemoryRebound(to: Int8.self, capacity: size) { (pointer) -> Void in
            memset(pointer, 0, size)
        }
    }
    
    public func clear(from index: Int, count: Int) {
        let size = count * coordinates * MemoryLayout<Element>.size
        memory.advanced(by: index * coordinates).withMemoryRebound(to: Int8.self, capacity: size) { (pointer) -> Void in
            memset(pointer, 0, size)
        }
    }
    
    public func clear(quadAt index: Int) {
        clear(from: index * vertexesByQuad, count: vertexesByQuad)
    }
    
    public func surface(at index: Int) -> Surface<Element> {
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
    
    public func referencePool(capacity: Int) -> ReferencePool {
        let start = cursor / (vertexesByQuad * coordinates)
        self.cursor += capacity * vertexesByQuad * coordinates
        return ReferencePool(from: start, to: start + capacity)
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
