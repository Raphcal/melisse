//
//  ImageContext-Mac.swift
//  Melisse-Mac
//
//  Created by Raphaël Calabro on 24/10/2017.
//  Copyright © 2017 Raphaël Calabro. All rights reserved.
//

import Foundation

public class ImageContext {
    
    public let context: CGContext?
    
    public var cgImage: CGImage? {
        return context?.makeImage()
    }
    
    private let colorSpace: CGColorSpace
    
    public init(size: CGSize, scale: CGFloat) {
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        self.colorSpace = colorSpace
        self.context = CGContext(data: nil, width: Int(size.width), height: Int(size.height), bitsPerComponent: 8, bytesPerRow: Int(size.width) * 4, space: colorSpace, bitmapInfo: CGImageAlphaInfo.premultipliedFirst.rawValue)
        context?.scaleBy(x: 1, y: -1)
        context?.translateBy(x: 0, y: -size.height)
    }
    
}
