//
//  Draws.swift
//  MeltedIce
//
//  Created by Raphaël Calabro on 29/09/2015.
//  Copyright © 2015 Raphaël Calabro. All rights reserved.
//

import GLKit

class Draws {
    
    static var lastTranslation = Point()
    
    static func bindTexture(texture: GLKTextureInfo) {
        glBindTexture(texture.target, texture.name)
        glTexParameteri(texture.target, GLenum(GL_TEXTURE_MIN_FILTER), GL_NEAREST)
        glTexParameteri(texture.target, GLenum(GL_TEXTURE_MAG_FILTER), GL_NEAREST)
    }
    
    static func freeTexture(texture: GLKTextureInfo) {
        var name = texture.name
        glDeleteTextures(1, &name)
    }
    
    static func drawWithVertexPointer(vertexPointer: UnsafeMutablePointer<GLfloat>, texCoordPointer: UnsafeMutablePointer<GLfloat>, count: GLsizei) {
        glVertexPointer(GLint(Surfaces.coordinatesByVertice), GLenum(GL_FLOAT), 0, vertexPointer)
        // TODO: Utiliser GL_SHORT
        glTexCoordPointer(GLint(Surfaces.coordinatesByTexture), GLenum(GL_FLOAT), 0, texCoordPointer)
        glDrawArrays(GLenum(GL_TRIANGLE_STRIP), 0, count)
    }
    
    static func drawWithVertexPointer(vertexPointer: UnsafeMutablePointer<GLfloat>, colorPointer: UnsafeMutablePointer<GLfloat>, count: GLsizei) {
        glDisable(GLenum(GL_TEXTURE_2D))
        glDisableClientState(GLenum(GL_TEXTURE_COORD_ARRAY))
        glEnableClientState(GLenum(GL_COLOR_ARRAY))
        
        glVertexPointer(GLint(Surfaces.coordinatesByVertice), GLenum(GL_FLOAT), 0, vertexPointer)
        glColorPointer(GLint(Surfaces.coordinatesByColor), GLenum(GL_FLOAT), 0, colorPointer)
        glDrawArrays(GLenum(GL_TRIANGLE_STRIP), 0, count)
        
        glDisableClientState(GLenum(GL_COLOR_ARRAY))
        glEnableClientState(GLenum(GL_TEXTURE_COORD_ARRAY))
        glEnable(GLenum(GL_TEXTURE_2D))
    }
    
    static func clearWithColor(color: Color) {
        glClearColor(color.red, color.green, color.blue, 1)
        glClear(GLbitfield(GL_COLOR_BUFFER_BIT) | GLbitfield(GL_DEPTH_BUFFER_BIT))
    }
    
    static func translateTo(topLeft: Point) {
        let translation = topLeft - lastTranslation
        glTranslatef(-translation.x, translation.y, 0)
        lastTranslation = topLeft
    }
    
}
