//
//  View.swift
//  MeltedIce
//
//  Created by Raphaël Calabro on 05/01/2016.
//  Copyright © 2016 Raphaël Calabro. All rights reserved.
//

import GLKit

class View : NSObject {
    
    static let instance = View()
    
    var width : GLfloat
    var height : GLfloat
    
    var zoomedWidth : GLfloat {
        get {
            return width * zoom
        }
    }
    
    var zoomedHeight : GLfloat {
        get {
            return height * zoom
        }
    }
    
    /// Rapport entre la taille de l'écran et la vue.
    var ratio : GLfloat
    
    /// Zoom général de la vue.
    var zoom : GLfloat = 1
    
    weak var factory : SpriteFactory?
    
    override init() {
        let screenWidth = GLfloat(UIScreen.mainScreen().bounds.width)
        let screenHeight = GLfloat(UIScreen.mainScreen().bounds.height)
        
        self.width = 384
        self.ratio = width / screenWidth
        self.height = screenHeight * ratio
    }
    
    func applyZoom() {
        glLoadIdentity()
        #if os(iOS)
            glOrthof(0, zoomedWidth, 0, zoomedHeight, -1, 1)
        #else
            glOrtho(0, GLdouble(zoomedWidth), 0, GLdouble(zoomedHeight), -1, 1)
        #endif
        
        // TODO: Utiliser autre chose que factory pour pouvoir gérer les objets Text.
        if let factory = self.factory {
            for sprite in factory.sprites {
                sprite.width = GLfloat(sprite.animation.frame.width) * zoom
                sprite.height = GLfloat(sprite.animation.frame.height) * zoom
                // TODO: Changer les positions Y
                // sprite.y =
                sprite.updateLocation()
            }
        }
    }
    
    func updateViewWithBounds(bounds: CGRect) {
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
            self.height = screenHeight * ratio
        #endif
    }
    
}
