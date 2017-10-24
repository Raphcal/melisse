//
//  ImageContext-iOS.swift
//  Melisse-iOS
//
//  Created by Raphaël Calabro on 24/10/2017.
//  Copyright © 2017 Raphaël Calabro. All rights reserved.
//

import Foundation
import UIKit

public class ImageContext {
    
    public let context: CGContext?
    
    public var cgImage: CGImage? {
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image?.cgImage
    }
    
    public init(size: CGSize, scale: CGFloat) {
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        self.context = UIGraphicsGetCurrentContext()
    }
    
}
