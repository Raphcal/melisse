//
//  Font.swift
//  Melisse
//
//  Created by Raphaël Calabro on 12/05/2016.
//  Copyright © 2016 Raphaël Calabro. All rights reserved.
//

import GLKit

public protocol Font {
    
    var definition: String { get }
    var spaceWidth: GLfloat { get }
    var digitAnimation: AnimationName { get }
    var upperCaseAnimation: AnimationName { get }
    var lowerCaseAnimation: AnimationName { get }
    var semicolonAnimation: AnimationName { get }
    var hiraganaAnimation: AnimationName { get }
    var katakanaAnimation: AnimationName { get }
    
    var cursorDefinition: String? { get }
    
}

public extension Font {
    
    var definition: String {
        return ""
    }
    
    var spaceWidth: GLfloat {
        return 0
    }
    
    var digitAnimation: AnimationName {
        return DefaultAnimationName.normal
    }
    
    var upperCaseAnimation: AnimationName {
        return DefaultAnimationName.normal
    }
    
    var lowerCaseAnimation: AnimationName {
        return DefaultAnimationName.normal
    }
    
    var semicolonAnimation: AnimationName {
        return DefaultAnimationName.normal
    }
    
    var hiraganaAnimation: AnimationName {
        return DefaultAnimationName.normal
    }
    
    var katakanaAnimation: AnimationName {
        return DefaultAnimationName.normal
    }
    
    var cursorDefinition: String? {
        return nil
    }
    
}

public struct NoFont : Font {
    public init() {}
}
