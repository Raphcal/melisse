//
//  MelisseViewController-Shared.swift
//  Melisse
//
//  Created by Raphaël Calabro on 02/06/2016.
//  Copyright © 2016 Raphaël Calabro. All rights reserved.
//

import GLKit

public protocol MelisseViewControllerType {
    
    var director: Director { get }
    var viewSize: Size<GLfloat> { get }
    
    func createGLContext()
    func directorDidStart()
    
    func initialScene() -> Scene
    
}

extension MelisseViewController {
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        createGLContext()
        glEnable(GLenum(GL_BLEND))
        glBlendFunc(GLenum(GL_ONE), GLenum(GL_ONE_MINUS_SRC_ALPHA))
        glAlphaFunc(GLenum(GL_GREATER), 0.1)
        
        glEnableClientState(GLenum(GL_VERTEX_ARRAY))
        
        View.instance.setSize(self.viewSize)
        
        director.makeCurrent()
        director.startWith(initialScene())
        
        directorDidStart()
    }
    
}