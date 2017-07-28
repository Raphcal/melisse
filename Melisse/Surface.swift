//
//  Surface.swift
//  Melisse
//
//  Created by Raphaël Calabro on 04/05/2016.
//  Copyright © 2016 Raphaël Calabro. All rights reserved.
//

import GLKit

public class Surface<Element : Numeric> {
    
    let memory: UnsafeMutablePointer<Element>
    let coordinates: Int
    let vertexesByQuad: Int
    
    init(memory: UnsafeMutablePointer<Element>, coordinates: Int, vertexesByQuad: Int) {
        self.memory = memory
        self.coordinates = coordinates
        self.vertexesByQuad = vertexesByQuad
    }
    
    public func clear() {
        memset(memory, 0, vertexesByQuad * coordinates * MemoryLayout<Element>.size)
    }
    
    public func setQuadWith(left: Element, top: Element, width: Element, height: Element) {
        setQuadWith(left: left, right: left + width, top: top, bottom: top + height)
    }
    
    public func setQuadWith(left: Element, right: Element, top: Element, bottom: Element) {
        // Bas gauche
        memory[0] = left
        memory[1] = bottom
        
        // (idem)
        memory[2] = left
        memory[3] = bottom
        
        // Bas droite
        memory[4] = right
        memory[5] = bottom
        
        // Haut gauche
        memory[6] = left
        memory[7] = top
        
        // Haut droite
        memory[8] = right
        memory[9] = top
        
        // (idem)
        memory[10] = right
        memory[11] = top
    }
    
    public func setColor(_ color: Color<Element>) {
        var index = 0
        for _ in 0 ..< vertexesByQuad {
            memory[index] = color.red
            memory[index + 1] = color.green
            memory[index + 2] = color.blue
            memory[index + 3] = color.alpha
            index += 4
        }
    }
    
    public func setColor(with white: Element, alpha: Element) {
        var index = 0
        for _ in 0 ..< vertexesByQuad {
            memory[index] = white
            memory[index + 1] = white
            memory[index + 2] = white
            memory[index + 3] = alpha
            index += 4
        }
    }
    
    public func setAlpha(_ alpha: Element) {
        var index = 0
        for _ in 0 ..< vertexesByQuad {
            memory[index + 3] = alpha
            index += 4
        }
    }
    
    public func setGradient(_ gradient: Gradient<Element>) {
        // Bas gauche
        memory[0] = gradient.bottomLeft.red
        memory[1] = gradient.bottomLeft.green
        memory[2] = gradient.bottomLeft.blue
        memory[3] = gradient.bottomLeft.alpha
        
        // (idem)
        memory[4] = gradient.bottomLeft.red
        memory[5] = gradient.bottomLeft.green
        memory[6] = gradient.bottomLeft.blue
        memory[7] = gradient.bottomLeft.alpha
        
        // Bas droite
        memory[8] = gradient.bottomRight.red
        memory[9] = gradient.bottomRight.green
        memory[10] = gradient.bottomRight.blue
        memory[11] = gradient.bottomRight.alpha
        
        // Haut gauche
        memory[12] = gradient.topLeft.red
        memory[13] = gradient.topLeft.green
        memory[14] = gradient.topLeft.blue
        memory[15] = gradient.topLeft.alpha
        
        // Haut droite
        memory[16] = gradient.topRight.red
        memory[17] = gradient.topRight.green
        memory[18] = gradient.topRight.blue
        memory[19] = gradient.topRight.alpha
        
        // (idem)
        memory[20] = gradient.topRight.red
        memory[21] = gradient.topRight.green
        memory[22] = gradient.topRight.blue
        memory[23] = gradient.topRight.alpha
    }
    
}

public extension Surface where Element: FloatingPoint, Element: Signed {
    
    func setQuadWith(left: Int, top: Int, width: Int, height: Int, direction: Direction, texture: GLKTextureInfo) {
        setQuadWith(left: (Element(left) + Element(width) * direction.mirror) / Element(texture.width),
                    top: Element(top) / Element(texture.height),
                    width: (Element(width) * direction.value) / Element(texture.width),
                    height: Element(height) / Element(texture.height))
    }
    
    func setQuadWith(_ rectangle: Rectangle<Element>) {
        setQuadWith(left: rectangle.left, right: rectangle.right, top: -rectangle.top, bottom: -rectangle.bottom)
    }
    
    func setQuadWith(_ quadrilateral: Quadrilateral<Element>) {
        memory[0] = quadrilateral.bottomLeft.x
        memory[1] = -quadrilateral.bottomLeft.y
        
        // (idem)
        memory[2] = quadrilateral.bottomLeft.x
        memory[3] = -quadrilateral.bottomLeft.y
        
        // bas droite
        memory[4] = quadrilateral.bottomRight.x
        memory[5] = -quadrilateral.bottomRight.y
        
        // haut gauche
        memory[6] = quadrilateral.topLeft.x
        memory[7] = -quadrilateral.topLeft.y
        
        // haut droite
        memory[8] = quadrilateral.topRight.x
        memory[9] = -quadrilateral.topRight.y
        
        // (idem)
        memory[10] = quadrilateral.topRight.x
        memory[11] = -quadrilateral.topRight.y
    }
    
}

public extension Surface where Element: Integer {
    
    func setQuadWith(left: Element, top: Element, width: Element, height: Element, direction: Direction, texture: GLKTextureInfo) {
        setQuadWith(left: left + width * Element(direction.mirror),
                    top: top,
                    width: width * Element(direction.value),
                    height: height)
    }
    
}
