//
//  Draws.swift
//  MeltedIce
//
//  Created by Raphaël Calabro on 29/09/2015.
//  Copyright © 2015 Raphaël Calabro. All rights reserved.
//

import GLKit

enum DrawMode {
    case texture, color, textureAndColor
}

public class Draws {
    
    static var lastTranslation = Point<GLfloat>()
    static weak var lastTexture: GLKTextureInfo?
    static var drawMode: DrawMode?
    
    public static func bindTexture(_ texture: GLKTextureInfo) {
        if texture !== lastTexture {
            glBindTexture(texture.target, texture.name)
            lastTexture = texture
        }
    }
    
    public static func freeTexture(_ texture: GLKTextureInfo) {
        var name = texture.name
        glDeleteTextures(1, &name)
    }
    
    public static func drawWith(_ vertexPointer: UnsafeMutablePointer<GLfloat>, texCoordPointer: UnsafeMutablePointer<GLfloat>, count: GLsizei) {
        if drawMode != .texture {
            glDisableClientState(GLenum(GL_COLOR_ARRAY))
            if drawMode != .textureAndColor {
                glEnableClientState(GLenum(GL_TEXTURE_COORD_ARRAY))
                glEnable(GLenum(GL_TEXTURE_2D))
            }
            drawMode = .texture
        }
        glVertexPointer(GLint(coordinatesByVertex), GLenum(GL_FLOAT), 0, vertexPointer)
        glTexCoordPointer(GLint(coordinatesByTexture), GLenum(GL_FLOAT), 0, texCoordPointer)
        glDrawArrays(GLenum(GL_TRIANGLE_STRIP), 0, count)
    }
    
    public static func drawWith(_ vertexPointer: UnsafeMutablePointer<GLfloat>, colorPointer: UnsafeMutablePointer<GLubyte>, count: GLsizei) {
        if drawMode != .color {
            glDisable(GLenum(GL_TEXTURE_2D))
            glDisableClientState(GLenum(GL_TEXTURE_COORD_ARRAY))
            if drawMode != .textureAndColor {
                glEnableClientState(GLenum(GL_COLOR_ARRAY))
            }
            drawMode = .color
        }
        
        glVertexPointer(GLint(coordinatesByVertex), GLenum(GL_FLOAT), 0, vertexPointer)
        glColorPointer(GLint(coordinatesByColor), GLenum(GL_UNSIGNED_BYTE), 0, colorPointer)
        glDrawArrays(GLenum(GL_TRIANGLE_STRIP), 0, count)
    }
    
    public static func drawWith(_ vertexPointer: UnsafeMutablePointer<GLfloat>, texCoordPointer: UnsafeMutablePointer<GLfloat>, colorPointer: UnsafeMutablePointer<GLubyte>, count: GLsizei) {
        if drawMode != .textureAndColor {
            if drawMode == .texture {
                glEnableClientState(GLenum(GL_COLOR_ARRAY))
            } else if drawMode == .color {
                glEnableClientState(GLenum(GL_TEXTURE_COORD_ARRAY))
                glEnable(GLenum(GL_TEXTURE_2D))
            }
            drawMode = .textureAndColor
        }
        glVertexPointer(GLint(coordinatesByVertex), GLenum(GL_FLOAT), 0, vertexPointer)
        glTexCoordPointer(GLint(coordinatesByTexture), GLenum(GL_FLOAT), 0, texCoordPointer)
        glColorPointer(GLint(coordinatesByColor), GLenum(GL_UNSIGNED_BYTE), 0, colorPointer)
        glDrawArrays(GLenum(GL_TRIANGLE_STRIP), 0, count)
    }
    
    public static func clearWith(_ color: Color<GLfloat>) {
        glClearColor(color.red, color.green, color.blue, 1)
        glClear(GLbitfield(GL_COLOR_BUFFER_BIT) | GLbitfield(GL_DEPTH_BUFFER_BIT))
    }
    
    public static func translateTo(_ topLeft: Point<GLfloat>) {
        let translation = topLeft - lastTranslation
        if translation != Point() {
            glTranslatef(-translation.x, translation.y, 0)
            lastTranslation = topLeft
        }
    }
}
