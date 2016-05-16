//
//  Font.swift
//  Melisse
//
//  Created by Raphaël Calabro on 12/05/2016.
//  Copyright © 2016 Raphaël Calabro. All rights reserved.
//

import GLKit

public protocol Font {
    
    var definition: Int { get }
    var spaceWidth: GLfloat { get }
    var digitAnimation: AnimationName { get }
    var upperCaseAnimation: AnimationName { get }
    var lowerCaseAnimation: AnimationName { get }
    var semicolonAnimation: AnimationName { get }
    
    var cursorDefintion: Int? { get }
    
}

public struct NoFont : Font {
    
    public let definition = 0
    public let spaceWidth = GLfloat(0)
    public let digitAnimation: AnimationName = DefaultAnimationName.Normal
    public let upperCaseAnimation: AnimationName = DefaultAnimationName.Normal
    public let lowerCaseAnimation: AnimationName = DefaultAnimationName.Normal
    public let semicolonAnimation: AnimationName = DefaultAnimationName.Normal
    
    public let cursorDefintion: Int? = nil
    
}