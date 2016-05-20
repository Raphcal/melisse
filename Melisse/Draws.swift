//
//  Draws.swift
//  MeltedIce
//
//  Created by Raphaël Calabro on 29/09/2015.
//  Copyright © 2015 Raphaël Calabro. All rights reserved.
//

import GLKit

enum DrawMode {
    case Texture, Color
}

public class Draws {
    
    static var lastTranslation = Point<GLfloat>()
    static weak var lastTexture: GLKTextureInfo?
    static var drawMode: DrawMode?
    
    public static func bindTexture(texture: GLKTextureInfo) {
        if texture !== lastTexture {
            glBindTexture(texture.target, texture.name)
            lastTexture = texture
        }
    }
    
    public static func freeTexture(texture: GLKTextureInfo) {
        var name = texture.name
        glDeleteTextures(1, &name)
    }
    
    public static func drawWithVertexPointer(vertexPointer: UnsafeMutablePointer<GLfloat>, texCoordPointer: UnsafeMutablePointer<GLshort>, count: GLsizei) {
        if drawMode != .Texture {
            glDisableClientState(GLenum(GL_COLOR_ARRAY))
            glEnableClientState(GLenum(GL_TEXTURE_COORD_ARRAY))
            glEnable(GLenum(GL_TEXTURE_2D))
            drawMode = .Texture
        }
        glVertexPointer(GLint(coordinatesByVertex), GLenum(GL_FLOAT), 0, vertexPointer)
        glTexCoordPointer(GLint(coordinatesByTexture), GLenum(GL_SHORT), 0, texCoordPointer)
        glDrawArrays(GLenum(GL_TRIANGLE_STRIP), 0, count)
    }
    
    public static func drawWithVertexPointer(vertexPointer: UnsafeMutablePointer<GLfloat>, texCoordPointer: UnsafeMutablePointer<GLfloat>, count: GLsizei) {
        if drawMode != .Texture {
            glDisableClientState(GLenum(GL_COLOR_ARRAY))
            glEnableClientState(GLenum(GL_TEXTURE_COORD_ARRAY))
            glEnable(GLenum(GL_TEXTURE_2D))
            drawMode = .Texture
        }
        glVertexPointer(GLint(coordinatesByVertex), GLenum(GL_FLOAT), 0, vertexPointer)
        glTexCoordPointer(GLint(coordinatesByTexture), GLenum(GL_FLOAT), 0, texCoordPointer)
        glDrawArrays(GLenum(GL_TRIANGLE_STRIP), 0, count)
    }
    
    public static func drawWithVertexPointer(vertexPointer: UnsafeMutablePointer<GLfloat>, colorPointer: UnsafeMutablePointer<GLubyte>, count: GLsizei) {
        if drawMode != .Color {
            glDisable(GLenum(GL_TEXTURE_2D))
            glDisableClientState(GLenum(GL_TEXTURE_COORD_ARRAY))
            glEnableClientState(GLenum(GL_COLOR_ARRAY))
            drawMode = .Color
        }
        
        glVertexPointer(GLint(coordinatesByVertex), GLenum(GL_FLOAT), 0, vertexPointer)
        glColorPointer(GLint(coordinatesByColor), GLenum(GL_UNSIGNED_BYTE), 0, colorPointer)
        glDrawArrays(GLenum(GL_TRIANGLE_STRIP), 0, count)
    }
    
    public static func clearWith(color: Color<GLfloat>) {
        glClearColor(color.red, color.green, color.blue, 1)
        glClear(GLbitfield(GL_COLOR_BUFFER_BIT) | GLbitfield(GL_DEPTH_BUFFER_BIT))
    }
    
    public static func translateTo(topLeft: Point<GLfloat>) {
        let translation = topLeft - lastTranslation
        glTranslatef(-translation.x, translation.y, 0)
        lastTranslation = topLeft
    }
}
