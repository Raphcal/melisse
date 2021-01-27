//
//  UIFont.swift
//  Melisse-Mac
//
//  Created by Raphaël Calabro on 20/10/2017.
//  Copyright © 2017 Raphaël Calabro. All rights reserved.
//

import Foundation
import Cocoa

public typealias UIFont = NSFont

public extension UIFont {
    func withSize(_ size: CGFloat) -> UIFont {
        return NSFont(name: self.fontName, size: size)!
    }
}
