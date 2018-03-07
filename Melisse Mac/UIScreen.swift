//
//  UIScreen.swift
//  Melisse
//
//  Created by Raphaël Calabro on 29/09/2015.
//  Copyright © 2015 Raphaël Calabro. All rights reserved.
//

import Foundation
import AppKit

public class UIScreen : NSObject {
    
    static public let main = UIScreen()
    
    public var scale: CGFloat = NSScreen.main?.backingScaleFactor ?? 1
    public var bounds = CGRect()
    
}
