//
//  Surface.swift
//  Melisse
//
//  Created by Raphaël Calabro on 04/05/2016.
//  Copyright © 2016 Raphaël Calabro. All rights reserved.
//

import GLKit

public struct Surface<Element : Numeric> {
    
    var memory: UnsafeMutablePointer<Element>
    var cursor: Int
    var coordinates: Int
    var vertexesByQuad: Int
    
    public func clear() {
        memset(memory, 0, vertexesByQuad * coordinates)
    }
    
    public func setQuadWith(left left: Element, top: Element, width: Element, height: Element) {
        setQuadWith(left: left, right: left + width, top: top, bottom: top + height)
    }
    
    public func setQuadWith(left left: Element, right: Element, top: Element, bottom: Element) {
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
    
    public func setColor(color: Color<Element>) {
        var index = cursor
        for _ in 0 ..< vertexesByQuad {
            memory[index] = color.red
            memory[index + 1] = color.green
            memory[index + 2] = color.blue
            memory[index + 3] = color.alpha
            index += 4
        }
    }
    
    public func setColor(with white: Element, alpha: Element) {
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

public extension Surface where Element: FloatingPoint, Element: Signed {
    
    func setQuadWith(left left: Int, top: Int, width: Int, height: Int, direction: Direction, texture: GLKTextureInfo) {
        setQuadWith(left: (Element(left) + Element(width) * direction.mirror) / Element(texture.width),
                    top: Element(top) / Element(texture.height),
                    width: (Element(width) * direction.value) / Element(texture.width),
                    height: Element(height) / Element(texture.height))
    }
    
    func setQuadWith(rectangle: Rectangle<Element>) {
        setQuadWith(left: rectangle.left, right: rectangle.right, top: rectangle.top, bottom: rectangle.bottom)
    }
    
    func setQuadWith(quadrilateral: Quadrilateral<Element>) {
        memory[cursor] = quadrilateral.bottomLeft.x
        memory[cursor + 1] = -quadrilateral.bottomLeft.y
        
        // (idem)
        memory[cursor + 2] = quadrilateral.bottomLeft.x
        memory[cursor + 3] = -quadrilateral.bottomLeft.y
        
        // bas droite
        memory[cursor + 4] = quadrilateral.bottomRight.x
        memory[cursor + 5] = -quadrilateral.bottomRight.y
        
        // haut gauche
        memory[cursor + 6] = quadrilateral.topLeft.x
        memory[cursor + 7] = -quadrilateral.topLeft.y
        
        // haut droite
        memory[cursor + 8] = quadrilateral.topRight.x
        memory[cursor + 9] = -quadrilateral.topRight.y
        
        // (idem)
        memory[cursor + 10] = quadrilateral.topRight.x
        memory[cursor + 11] = -quadrilateral.topRight.y
    }
    
}

public extension Surface where Element: Integer {
    
    func setQuadWith(left left: Element, top: Element, width: Element, height: Element, direction: Direction, texture: GLKTextureInfo) {
        setQuadWith(left: left + width * Element(direction.mirror),
                    top: top,
                    width: width * Element(direction.value),
                    height: height)
    }
    
}
