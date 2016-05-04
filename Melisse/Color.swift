//
//  Color.swift
//  MeltedIce
//
//  Created by Raphaël Calabro on 29/09/2015.
//  Copyright © 2015 Raphaël Calabro. All rights reserved.
//

import GLKit

struct Color<Component where Component : Numeric> {
    
    var red: Component
    var green: Component
    var blue: Component
    var alpha: Component
    
    init(red: Component, green: Component, blue: Component, alpha: Component) {
        self.red = red
        self.green = green
        self.blue = blue
        self.alpha = alpha
    }
    
    init(white: Component, alpha: Component) {
        self.red = white
        self.green = white
        self.blue = white
        self.alpha = alpha
    }
    
}

extension Color where Component : FloatingPoint {
    
    init() {
        self.red = Component(0)
        self.green = Component(0)
        self.blue = Component(0)
        self.alpha = Component(1)
    }
    
    init(hex: Int, alpha: Component = Component(1)) {
        let red = (hex & 0xFF0000) >> 16
        let green = (hex & 0xFF00) >> 8
        let blue = hex & 0xFF
        
        self.red = Component(red) / GLfloat(255)
        self.green = Component(green) / GLfloat(255)
        self.green = Component(blue) / GLfloat(255)
        self.alpha = alpha
    }
    
}

extension Color where Component : Integer {
    
    init() {
        self.red = Component(0)
        self.green = Component(0)
        self.blue = Component(0)
        self.alpha = Component(255)
    }
    
    init(hex: Int, alpha: Component = Component(1)) {
        let red = (hex & 0xFF0000) >> 16
        let green = (hex & 0xFF00) >> 8
        let blue = hex & 0xFF
        
        self.red = Component(red)
        self.green = Component(green)
        self.green = Component(blue)
        self.alpha = alpha
    }
    
}
