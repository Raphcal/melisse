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
    
    public var width: GLfloat = 384
    public var height: GLfloat {
        get {
            return size.height
        }
    }
    
    public private(set) var size = Size<GLfloat>(width: 384, height: 240)
    
    /// Rapport entre la largeur et la hauteur.
    public var ratio: GLfloat = 1
    
    public var scale: Point<GLfloat> {
        let bounds = UIScreen.main.bounds
        return Point<GLfloat>(x: size.width / GLfloat(bounds.width), y: size.height / GLfloat(bounds.height))
    }
    
    public mutating func setSize(_ size: Size<GLfloat>) {
        self.ratio = width / size.width
        self.size = Size(width: width, height: (size.height * ratio).floored)
    }
    
    /// Charge et applique une matrice effectuant une projection orthographique correspondant à `size`.
    func loadOrthographicMatrix(zoom: GLfloat = 1) {
        glLoadIdentity()
        let zoomedSize = size * zoom
        #if os(iOS)
            glOrthof(0, zoomedSize.width, 0, zoomedSize.height, -1, 1)
        #else
            glOrtho(0, GLdouble(zoomedSize.width), 0, GLdouble(zoomedSize.height), -1, 1)
        #endif
    }
}
