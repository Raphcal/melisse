//
//  Shape.swift
//  Melisse
//
//  Created by Raphaël Calabro on 04/05/2016.
//  Copyright © 2016 Raphaël Calabro. All rights reserved.
//

import Foundation

protocol Shape {
    
    var x : GLfloat { get }
    var y : GLfloat { get }
    var width : GLfloat { get }
    var height : GLfloat { get }
    var top : GLfloat { get }
    var bottom : GLfloat { get }
    var left : GLfloat { get }
    var right : GLfloat { get }
    
}