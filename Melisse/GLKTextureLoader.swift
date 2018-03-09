//
//  GLKTextureLoader.swift
//  Melisse
//
//  Created by Raphaël Calabro on 09/03/2018.
//  Copyright © 2018 Raphaël Calabro. All rights reserved.
//

import GLKit

public protocol Paintable {
    func paint(in context: CGContext, at origin: Point<Int>)
}

public enum TextureError : Error {
    case imageNotGenerated
}

public extension GLKTextureLoader {
    
    /// Creates a GLKTexture from the given pack map.
    public static func texture<P>(with packMap: PackMap<P>) throws -> GLKTextureInfo where P : Paintable {
        let imageContext = ImageContext(size: CGSize(width: packMap.size.width, height: packMap.size.height), scale: UIScreen.main.scale)
        
        if let context = imageContext.context {
            context.textMatrix = CGAffineTransform(scaleX: 1.0, y: -1.0)
            
            for (paintable, origin) in packMap.locations {
                context.saveGState()
                paintable.paint(in: context, at: origin)
                context.restoreGState()
            }
        }
        
        if let image = imageContext.cgImage {
            #if os(iOS)
                return try GLKTextureLoader.texture(with: image, options: [GLKTextureLoaderOriginBottomLeft: false])
            #elseif os(macOS)
                return try GLKTextureLoader.texture(withContentsOf: temporaryPNGUrl(with: image), options: [GLKTextureLoaderOriginBottomLeft: false])
            #endif
        }
        
        throw TextureError.imageNotGenerated
    }
    
    fileprivate static func temporaryPNGUrl(with image: CGImage) -> URL {
        let directories = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true)
        let url = NSURL(fileURLWithPath: "\(directories[0])/out.png")
        if let destination = CGImageDestinationCreateWithURL(url as CFURL, kUTTypePNG, 1, nil) {
            CGImageDestinationAddImage(destination, image, nil)
            if !CGImageDestinationFinalize(destination) {
                NSLog("Unable to write temporary PNG at URL \(url).")
            }
        } else {
            NSLog("Unable to use URL \(url) to create a temporary PNG.")
        }
        return url as URL
    }
    
}
