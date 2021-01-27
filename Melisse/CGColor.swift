//
//  CGColor.swift
//  Melisse
//
//  Created by Raphaël Calabro on 09/03/2018.
//  Copyright © 2018 Raphaël Calabro. All rights reserved.
//

import Foundation
import GLKit

public extension CGColor {

    /// Creates a `CGColor` instance from a Melisse color.
    static func with(color: Color<GLfloat>) -> CGColor {
        #if os(iOS)
            return UIColor(red: CGFloat(color.red), green: CGFloat(color.green), blue: CGFloat(color.blue), alpha: CGFloat(color.alpha)).cgColor
        #elseif os(macOS)
            return CGColor(red: CGFloat(color.red), green: CGFloat(color.green), blue: CGFloat(color.blue), alpha: CGFloat(color.alpha))
        #endif
    }
    
    /// Creates a `CGColor` instance from a Melisse color.
    static func with(color: Color<GLubyte>) -> CGColor {
        #if os(iOS)
            return UIColor(red: CGFloat(color.red) / 255, green: CGFloat(color.green) / 255, blue: CGFloat(color.blue) / 255, alpha: CGFloat(color.alpha) / 255).cgColor
        #elseif os(macOS)
            return CGColor(red: CGFloat(color.red) / 255, green: CGFloat(color.green) / 255, blue: CGFloat(color.blue) / 255, alpha: CGFloat(color.alpha) / 255)
        #endif
    }

}
