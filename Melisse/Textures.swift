//
//  Textures.swift
//  Melisse
//
//  Created by Raphaël Calabro on 19/05/2016.
//  Copyright © 2016 Raphaël Calabro. All rights reserved.
//

import GLKit

enum TextureLoadError : ErrorType {
    case URLNotFound
}

public func textureForResource(name: String, extension ext: String, in folder: String? = nil) throws -> GLKTextureInfo {
    let error = glGetError()
    if error != 0 {
        NSLog("Erreur OpenGL : \(error)")
    }
    
    if let url = URLForResource(name, extension: ext, in: folder) {
        #if os(iOS)
            let premultiplication = false
        #else
            let premultiplication = true
        #endif
        let texture = try GLKTextureLoader.textureWithContentsOfURL(url, options: [GLKTextureLoaderOriginBottomLeft: false, GLKTextureLoaderApplyPremultiplication: premultiplication])
        glTexParameteri(texture.target, GLenum(GL_TEXTURE_MIN_FILTER), GL_NEAREST)
        glTexParameteri(texture.target, GLenum(GL_TEXTURE_MAG_FILTER), GL_NEAREST)
        return texture
    } else {
        throw TextureLoadError.URLNotFound
    }
}

public func URLForResource(name: String, extension ext: String, in folder: String? = nil) -> NSURL? {
    if let folder = folder where NSFileManager.defaultManager().isReadableFileAtPath(folder + "/" + name + "." + ext) {
        return NSURL(fileURLWithPath: folder + "/" + name + "." + ext)
    } else {
        return NSBundle.mainBundle().URLForResource(name, withExtension: ext)
    }
}
