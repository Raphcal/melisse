//
//  Color.swift
//  MeltedIce
//
//  Created by Raphaël Calabro on 29/09/2015.
//  Copyright © 2015 Raphaël Calabro. All rights reserved.
//

import GLKit

class Color : NSObject {
    
    let red : GLfloat
    let green : GLfloat
    let blue : GLfloat
    let alpha : GLfloat
    
    convenience override init() {
        self.init(red: 0, green: 0, blue: 0, alpha: 1)
    }
    
    convenience init(red: GLfloat, green: GLfloat, blue: GLfloat) {
        self.init(red: red, green: green, blue: blue, alpha: 1)
    }
    
    convenience init(intRed red: Int, intGreen green: Int, intBlue blue: Int, intAlpha alpha: Int) {
        self.init(red: GLfloat(red) / 255, green: GLfloat(green) / 255, blue: GLfloat(blue) / 255, alpha: GLfloat(alpha) / 255)
    }
    
    convenience init(hex: Int, alpha: GLfloat = 1) {
        let red = GLfloat((hex & 0xFF0000) >> 16) / 255
        let green = GLfloat((hex & 0xFF00) >> 8) / 255
        let blue = GLfloat(hex & 0xFF) / 255
        self.init(red: red, green: green, blue: blue, alpha: alpha)
    }
    
    convenience init(white: GLfloat, alpha: GLfloat = 1) {
        self.init(red: white, green: white, blue: white, alpha: alpha)
    }
    
    init(red: GLfloat, green: GLfloat, blue: GLfloat, alpha: GLfloat) {
        self.red = red
        self.green = green
        self.blue = blue
        self.alpha = alpha
    }
    
}