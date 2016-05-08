//
//  Draws.swift
//  MeltedIce
//
//  Created by Raphaël Calabro on 29/09/2015.
//  Copyright © 2015 Raphaël Calabro. All rights reserved.
//

import GLKit

class Draws {
    
    static var lastTranslation = Point<GLfloat>()
    
    static func bindTexture(texture: GLKTextureInfo) {
        glBindTexture(texture.target, texture.name)
        glTexParameteri(texture.target, GLenum(GL_TEXTURE_MIN_FILTER), GL_NEAREST)
        glTexParameteri(texture.target, GLenum(GL_TEXTURE_MAG_FILTER), GL_NEAREST)
    }
    
    static func freeTexture(texture: GLKTextureInfo) {
        var name = texture.name
        glDeleteTextures(1, &name)
    }
    
    static func drawWithVertexPointer(vertexPointer: UnsafeMutablePointer<GLfloat>, texCoordPointer: UnsafeMutablePointer<GLshort>, count: GLsizei) {
        glVertexPointer(GLint(coordinatesByVertex), GLenum(GL_FLOAT), 0, vertexPointer)
        glTexCoordPointer(GLint(coordinatesByTexture), GLenum(GL_SHORT), 0, texCoordPointer)
        glDrawArrays(GLenum(GL_TRIANGLE_STRIP), 0, count)
    }
    
    static func drawWithVertexPointer(vertexPointer: UnsafeMutablePointer<GLfloat>, colorPointer: UnsafeMutablePointer<GLubyte>, count: GLsizei) {
        glDisable(GLenum(GL_TEXTURE_2D))
        glDisableClientState(GLenum(GL_TEXTURE_COORD_ARRAY))
        glEnableClientState(GLenum(GL_COLOR_ARRAY))
        
        glVertexPointer(GLint(coordinatesByVertex), GLenum(GL_FLOAT), 0, vertexPointer)
        glColorPointer(GLint(coordinatesByColor), GLenum(GL_UNSIGNED_BYTE), 0, colorPointer)
        glDrawArrays(GLenum(GL_TRIANGLE_STRIP), 0, count)
        
        glDisableClientState(GLenum(GL_COLOR_ARRAY))
        glEnableClientState(GLenum(GL_TEXTURE_COORD_ARRAY))
        glEnable(GLenum(GL_TEXTURE_2D))
    }
    
    static func clearWithColor(color: Color<GLfloat>) {
        glClearColor(color.red, color.green, color.blue, 1)
        glClear(GLbitfield(GL_COLOR_BUFFER_BIT) | GLbitfield(GL_DEPTH_BUFFER_BIT))
    }
    
    static func translateTo(topLeft: Point<GLfloat>) {
        let translation = topLeft - lastTranslation
        glTranslatef(-translation.x, translation.y, 0)
        lastTranslation = topLeft
    }
    
}
