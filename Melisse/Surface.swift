//
//  Surface.swift
//  Melisse
//
//  Created by Raphaël Calabro on 04/05/2016.
//  Copyright © 2016 Raphaël Calabro. All rights reserved.
//

import GLKit

struct Surface<Element : Numeric> {
    
    var memory: UnsafeMutablePointer<Element>
    var cursor: Int
    var coordinates: Int
    
    func clear() {
        memset(memory, 0, vertexesByQuad * coordinates)
    }
    
    func setQuadWith(left left: Element, top: Element, width: Element, height: Element) {
        setQuadWith(left: left, right: left + width, top: top, bottom: top + height)
    }
    
    func setQuadWith(left left: Element, right: Element, top: Element, bottom: Element) {
        // Bas gauche
        memory[cursor] = left
        memory[cursor + 1] = bottom
        
        // (idem)
        memory[cursor + 2] = left
        memory[cursor + 3] = bottom
        
        // Bas droite
        memory[cursor + 4] = right
        memory[cursor + 5] = bottom
        
        // Haut gauche
        memory[cursor + 6] = left
        memory[cursor + 7] = top
        
        // Haut droite
        memory[cursor + 8] = right
        memory[cursor + 9] = top
        
        // (idem)
        memory[cursor + 10] = right
        memory[cursor + 11] = top
    }
    
    func setColor(color: Color<Element>) {
        var index = cursor
        for _ in 0 ..< vertexesByQuad {
            memory[index] = color.red
            memory[index + 1] = color.green
            memory[index + 2] = color.blue
            memory[index + 3] = color.alpha
            index += 4
        }
    }
    
    func setColor(with white: Element, alpha: Element) {
        var index = cursor
        for _ in 0 ..< vertexesByQuad {
            memory[index] = white
            memory[index + 1] = white
            memory[index + 2] = white
            memory[index + 3] = alpha
            index += 4
        }
    }
    
}

extension Surface where Element: FloatingPoint {
    
    func setQuadWith(left: Int, top: Int, width: Int, height: Int, direction: Direction, texture: GLKTextureInfo) {
        setQuadWith(left: (Element(left) + Element(width) * direction.mirror) / Element(texture.width),
                    top: Element(top) / Element(texture.height),
                    width: (Element(width) * direction.value) / Element(texture.width),
                    height: Element(height) / Element(texture.height))
    }
    
    func setQuadWith(square: Square) {
        setQuadWith(left: Element(square.left), right: Element(square.right), top: Element(square.top), bottom: Element(square.bottom))
    }
    
    func setQuadWith(quadrilateral: Quadrilateral) {
        memory[cursor] = Element(quadrilateral.bottomLeft.x)
        memory[cursor + 1] = Element(-quadrilateral.bottomLeft.y)
        
        // (idem)
        memory[cursor + 2] = Element(quadrilateral.bottomLeft.x)
        memory[cursor + 3] = Element(-quadrilateral.bottomLeft.y)
        
        // bas droite
        memory[cursor + 4] = Element(quadrilateral.bottomRight.x)
        memory[cursor + 5] = Element(-quadrilateral.bottomRight.y)
        
        // haut gauche
        memory[cursor + 6] = Element(quadrilateral.topLeft.x)
        memory[cursor + 7] = Element(-quadrilateral.topLeft.y)
        
        // haut droite
        memory[cursor + 8] = Element(quadrilateral.topRight.x)
        memory[cursor + 9] = Element(-quadrilateral.topRight.y)
        
        // (idem)
        memory[cursor + 10] = Element(quadrilateral.topRight.x)
        memory[cursor + 11] = Element(-quadrilateral.topRight.y)
    }
    
}

extension Surface where Element: Integer {
    
    func setQuadWith(left: Int, top: Int, width: Int, height: Int, direction: Direction, texture: GLKTextureInfo) {
        setQuadWith(left: Element(left + width * Int(direction.mirror)),
                    top: Element(top),
                    width: Element(width * Int(direction.value)),
                    height: Element(height))
    }
    
}
