//
//  Gradient.swift
//  Melisse
//
//  Created by Raphaël Calabro on 01/06/2016.
//  Copyright © 2016 Raphaël Calabro. All rights reserved.
//

import Foundation

public struct Gradient<Component> : Equatable where Component : Numeric {
    
    public var topLeft: Color<Component>
    public var topRight: Color<Component>
    public var bottomLeft: Color<Component>
    public var bottomRight: Color<Component>
    
    public init() {
        let black = Color(red: Component(0), green: Component(0), blue: Component(0), alpha: Component(0))
        self.topLeft = black
        self.topRight = black
        self.bottomLeft = black
        self.bottomRight = black
    }
    
    public init(color: Color<Component>) {
        self.topLeft = color
        self.topRight = color
        self.bottomLeft = color
        self.bottomRight = color
    }
    
    public init(top: Color<Component>, bottom: Color<Component>) {
        self.topLeft = top
        self.topRight = top
        self.bottomLeft = bottom
        self.bottomRight = bottom
    }
    
    public init(left: Color<Component>, right: Color<Component>) {
        self.topLeft = left
        self.topRight = right
        self.bottomLeft = left
        self.bottomRight = right
    }
    
    public init(topLeft: Color<Component>, topRight: Color<Component>, bottomLeft: Color<Component>, bottomRight: Color<Component>) {
        self.topLeft = topLeft
        self.topRight = topRight
        self.bottomLeft = bottomLeft
        self.bottomRight = bottomRight
    }
    
}

public func ==<Component>(lhs: Gradient<Component>, rhs: Gradient<Component>) -> Bool {
    return lhs.topLeft == rhs.topLeft
        && lhs.topRight == rhs.topRight
        && lhs.bottomLeft == rhs.bottomLeft
        && lhs.bottomRight == rhs.bottomRight
}
