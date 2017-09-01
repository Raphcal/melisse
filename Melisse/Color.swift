//
//  Color.swift
//  MeltedIce
//
//  Created by Raphaël Calabro on 29/09/2015.
//  Copyright © 2015 Raphaël Calabro. All rights reserved.
//

import GLKit

public struct Color<Component> : Equatable, Hashable where Component : Numeric {
    
    public var red: Component
    public var green: Component
    public var blue: Component
    public var alpha: Component
    
    public var hashValue: Int {
        return red.hashValue &* 5
            &+ green.hashValue &* 193
            &+ blue.hashValue &* 73
            &+ alpha.hashValue &* 59
    }
    
    public init(red: Component, green: Component, blue: Component, alpha: Component) {
        self.red = red
        self.green = green
        self.blue = blue
        self.alpha = alpha
    }
    
}

public func ==<Component>(lhs: Color<Component>, rhs: Color<Component>) -> Bool where Component : Numeric {
    return lhs.red == rhs.red
        && lhs.green == rhs.green
        && lhs.blue == rhs.blue
        && lhs.alpha == rhs.alpha
}

public extension Color where Component : FloatingPoint {
    
    static var black: Color<Component> {
        return Color<Component>(white: 0)
    }
    static var darkGray: Color<Component> {
        return Color<Component>(white: 0.333)
    }
    static var lightGray: Color<Component> {
        return Color<Component>(white: 0.667)
    }
    static var white: Color<Component> {
        return Color<Component>(white: 1)
    }
    static var red: Color<Component> {
        return Color<Component>(red: 1, green: 0, blue: 0, alpha: 1)
    }
    static var green: Color<Component> {
        return Color<Component>(red: 0, green: 1, blue: 0, alpha: 1)
    }
    static var blue: Color<Component> {
        return Color<Component>(red: 0, green: 0, blue: 1, alpha: 1)
    }
    static var cyan: Color<Component> {
        return Color<Component>(red: 0, green: 1, blue: 1, alpha: 1)
    }
    static var yellow: Color<Component> {
        return Color<Component>(red: 1, green: 1, blue: 0, alpha: 1)
    }
    static var magenta: Color<Component> {
        return Color<Component>(red: 1, green: 0, blue: 1, alpha: 1)
    }
    static var orange: Color<Component> {
        return Color<Component>(red: 1, green: 0.5, blue: 0, alpha: 1)
    }
    static var purple: Color<Component> {
        return Color<Component>(red: 0.5, green: 0, blue: 0.5, alpha: 1)
    }
    static var brown: Color<Component> {
        return Color<Component>(red: 0.6, green: 0.4, blue: 0.2, alpha: 1)
    }
    static var clear: Color<Component> {
        return Color<Component>(red: 0, green: 0, blue: 0, alpha: 0)
    }
 
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
        
        self.red = Component(red) / 255
        self.green = Component(green) / 255
        self.blue = Component(blue) / 255
        self.alpha = alpha
    }
    
    public init(white: Component, alpha: Component = Component(1)) {
        self.red = white
        self.green = white
        self.blue = white
        self.alpha = alpha
    }
    
}

public func +<Component>(lhs: Color<Component>, rhs: Color<Component>) -> Color<Component> where Component : Numeric {
    return Color(red: fence(0, lhs.red + rhs.red, 1), green: fence(0, lhs.green + rhs.green, 1), blue: fence(0, lhs.blue + rhs.blue, 1), alpha: fence(0, lhs.alpha + rhs.alpha, 1))
}

public func +<Component>(lhs: Color<Component>, rhs: Component) -> Color<Component> where Component : Numeric {
    return Color(red: fence(0, lhs.red + rhs, 1), green: fence(0, lhs.green + rhs, 1), blue: fence(0, lhs.blue + rhs, 1), alpha: fence(0, lhs.alpha + rhs, 1))
}

public func -<Component>(lhs: Color<Component>, rhs: Color<Component>) -> Color<Component> where Component : Numeric {
    return Color(red: fence(0, lhs.red - rhs.red, 1), green: fence(0, lhs.green - rhs.green, 1), blue: fence(0, lhs.blue - rhs.blue, 1), alpha: fence(0, lhs.alpha - rhs.alpha, 1))
}

public func -<Component>(lhs: Color<Component>, rhs: Component) -> Color<Component> where Component : Numeric {
    return Color(red: fence(0, lhs.red - rhs, 1), green: fence(0, lhs.green - rhs, 1), blue: fence(0, lhs.blue - rhs, 1), alpha: fence(0, lhs.alpha - rhs, 1))
}

public func *<Component>(lhs: Color<Component>, rhs: Color<Component>) -> Color<Component> where Component : Numeric {
    return Color(red: fence(0, lhs.red * rhs.red, 1), green: fence(0, lhs.green * rhs.green, 1), blue: fence(0, lhs.blue * rhs.blue, 1), alpha: fence(0, lhs.alpha * rhs.alpha, 1))
}

public func *<Component>(lhs: Color<Component>, rhs: Component) -> Color<Component> where Component : Numeric {
    return Color(red: fence(0, lhs.red * rhs, 1), green: fence(0, lhs.green * rhs, 1), blue: fence(0, lhs.blue * rhs, 1), alpha: fence(0, lhs.alpha * rhs, 1))
}

public func /<Component>(lhs: Color<Component>, rhs: Color<Component>) -> Color<Component> where Component : Numeric {
    return Color(red: fence(0, lhs.red / rhs.red, 1), green: fence(0, lhs.green / rhs.green, 1), blue: fence(0, lhs.blue / rhs.blue, 1), alpha: fence(0, lhs.alpha / rhs.alpha, 1))
}

public func /<Component>(lhs: Color<Component>, rhs: Component) -> Color<Component> where Component : Numeric {
    return Color(red: fence(0, lhs.red / rhs, 1), green: fence(0, lhs.green / rhs, 1), blue: fence(0, lhs.blue / rhs, 1), alpha: fence(0, lhs.alpha / rhs, 1))
}

public extension Color where Component : Integer {
    
    static var black: Color<Component> {
        return Color<Component>(white: 0)
    }
    static var darkGray: Color<Component> {
        return Color<Component>(white: 85)
    }
    static var lightGray: Color<Component> {
        return Color<Component>(white: 170)
    }
    static var white: Color<Component> {
        return Color<Component>(white: 255)
    }
    static var red: Color<Component> {
        return Color<Component>(red: 255, green: 0, blue: 0, alpha: 255)
    }
    static var green: Color<Component> {
        return Color<Component>(red: 0, green: 255, blue: 0, alpha: 255)
    }
    static var blue: Color<Component> {
        return Color<Component>(red: 0, green: 0, blue: 255, alpha: 255)
    }
    static var cyan: Color<Component> {
        return Color<Component>(red: 0, green: 255, blue: 255, alpha: 255)
    }
    static var yellow: Color<Component> {
        return Color<Component>(red: 255, green: 255, blue: 0, alpha: 255)
    }
    static var magenta: Color<Component> {
        return Color<Component>(red: 255, green: 0, blue: 255, alpha: 255)
    }
    static var orange: Color<Component> {
        return Color<Component>(red: 255, green: 128, blue: 0, alpha: 255)
    }
    static var purple: Color<Component> {
        return Color<Component>(red: 128, green: 0, blue: 128, alpha: 255)
    }
    static var brown: Color<Component> {
        return Color<Component>(red: 154, green: 102, blue: 51, alpha: 255)
    }
    static var clear: Color<Component> {
        return Color<Component>(red: 0, green: 0, blue: 0, alpha: 0)
    }
    
    init() {
        self.red = Component(0)
        self.green = Component(0)
        self.blue = Component(0)
        self.alpha = Component(255)
    }
    
    init(hex: Int, alpha: Component = Component(255)) {
        let red = (hex & 0xFF0000) >> 16
        let green = (hex & 0xFF00) >> 8
        let blue = hex & 0xFF
        
        self.red = Component(red)
        self.green = Component(green)
        self.blue = Component(blue)
        self.alpha = alpha
    }
    
    public init(white: Component, alpha: Component = Component(255)) {
        self.red = white
        self.green = white
        self.blue = white
        self.alpha = alpha
    }
    
}
