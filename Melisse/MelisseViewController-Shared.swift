//
//  MelisseViewController-Shared.swift
//  Melisse
//
//  Created by Raphaël Calabro on 02/06/2016.
//  Copyright © 2016 Raphaël Calabro. All rights reserved.
//

import GLKit

protocol GLViewController {
    
    func setupGL()
    
}

extension MelisseViewController {
    
    func setupGL() {
        glEnable(GLenum(GL_BLEND))
        glBlendFunc(GLenum(GL_ONE), GLenum(GL_ONE_MINUS_SRC_ALPHA))
        glAlphaFunc(GLenum(GL_GREATER), 0.1)
    }
    
}