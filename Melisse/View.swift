//
//  View.swift
//  MeltedIce
//
//  Created by Raphaël Calabro on 05/01/2016.
//  Copyright © 2016 Raphaël Calabro. All rights reserved.
//

import GLKit

public struct View {
    
    static public var instance = View()
    
    public let width: GLfloat = 384
    public var height: GLfloat {
        get {
            return size.height
        }
    }
    
    public private(set) var size = Size<GLfloat>(width: 384, height: 240)
    
    /// Rapport entre la largeur et la hauteur.
    public var ratio: GLfloat = 1
    
    /// Zoom général de la vue.
    var zoom: GLfloat = 1
    
    weak var factory: SpriteFactory?
    
    public mutating func setSize(size: Size<GLfloat>) {
        self.ratio = width / size.width
        self.size = Size(width: width, height: size.height * ratio)
    }
    
    // TODO: Faire quelque chose de cette méthode.
    public func applyZoom() {
        glLoadIdentity()
        let zoomedSize = size * zoom
        #if os(iOS)
            glOrthof(0, zoomedSize.width, 0, zoomedSize.height, -1, 1)
        #else
            glOrtho(0, GLdouble(zoomedSize.width), 0, GLdouble(zoomedSize.height), -1, 1)
        #endif
        
        // TODO: Utiliser autre chose que factory pour pouvoir gérer les objets Text.
        if let factory = self.factory {
            for sprite in factory.sprites {
                var frame = sprite.frame
                frame.width = GLfloat(sprite.animation.frame.frame.width) * zoom
                frame.height = GLfloat(sprite.animation.frame.frame.height) * zoom
                // TODO: Changer les positions Y
                // sprite.y =
                sprite.frame = frame
            }
        }
    }
    
    // TODO: Faire quelque chose de cette méthode.
    mutating func updateViewWithBounds(bounds: CGRect) {
        #if VIEW_UPDATE_WITH_ZOOM
            let zoom = max(
                Float(bounds.width) / (12 * 32),
                Float(bounds.height) / (6.8 * 32))
            
            self.width = GLfloat(bounds.width) / zoom
            self.height = GLfloat(bounds.height) / zoom
            
            let screenWidth = GLfloat(bounds.width)
            self.ratio = width / screenWidth
        #else
            let screenWidth = GLfloat(bounds.width)
            let screenHeight = GLfloat(bounds.height)
            
            self.ratio = width / screenWidth
            self.size = Size(width: width, height: screenHeight * ratio)
        #endif
    }
    
}
