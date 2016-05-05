//
//  OffsettedRectangle.swift
//  Melisse
//
//  Created by Raphaël Calabro on 05/05/2016.
//  Copyright © 2016 Raphaël Calabro. All rights reserved.
//

import Foundation

struct OffsettedRectangle : OffsettedRectangular, Hitbox {
    
    var center: Point<GLfloat>
    var offset: Point<GLfloat>
    var size: Size<GLfloat>
    
}