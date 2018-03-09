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
    public static func with(color: Color<GLfloat>) -> CGColor {
        return CGColor(red: CGFloat(color.red), green: CGFloat(color.green), blue: CGFloat(color.blue), alpha: CGFloat(color.alpha))
    }
    
    /// Creates a `CGColor` instance from a Melisse color.
    public static func with(color: Color<GLubyte>) -> CGColor {
        return CGColor(red: CGFloat(color.red) / 255, green: CGFloat(color.green) / 255, blue: CGFloat(color.blue) / 255, alpha: CGFloat(color.alpha) / 255)
    }

}
