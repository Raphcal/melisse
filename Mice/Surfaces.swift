//
//  Surfaces.swift
//  MeltedIce
//
//  Created by Raphaël Calabro on 28/06/2015.
//  Copyright (c) 2015 Raphaël Calabro. All rights reserved.
//

import GLKit

/// Méthodes de gestion des surfaces OpenGL.
class Surfaces : NSObject {
    
    // 384 x 224
    
    static let vertexesByQuad = 6
    static let coordinatesByVertice = 2
    static let coordinatesByTexture = 2
    static let coordinatesByColor = 4
    static let tileSize : Float = 32
    
}

extension Surface {
    
    func setQuadWithLeft(left: Int, top: Int, width: Int, height: Int, direction: Direction, texture: GLKTextureInfo) {
        setQuadWithLeft((GLfloat(left) + GLfloat(width) * direction.mirror) / GLfloat(texture.width),
                        top: GLfloat(top) / GLfloat(texture.height),
                        width: GLfloat(width) * direction.value / GLfloat(texture.width),
                        height: GLfloat(height) / GLfloat(texture.height))
    }
    
}
