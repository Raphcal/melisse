//
//  Textures.swift
//  Melisse
//
//  Created by Raphaël Calabro on 19/05/2016.
//  Copyright © 2016 Raphaël Calabro. All rights reserved.
//

import GLKit

enum TextureLoadError : ErrorProtocol {
    case urlNotFound
}

public func textureForResource(_ name: String, extension ext: String, in folder: String? = nil) throws -> GLKTextureInfo {
    clearGLError()
    
    if let url = URLForResource(name, extension: ext, in: folder) {
        #if os(iOS)
            let premultiplication = false
        #else
            let premultiplication = true
        #endif
        let texture = try GLKTextureLoader.texture(withContentsOf: url, options: [GLKTextureLoaderOriginBottomLeft: false, GLKTextureLoaderApplyPremultiplication: premultiplication])
        clearGLError()
        glTexParameteri(texture.target, GLenum(GL_TEXTURE_MIN_FILTER), GL_NEAREST)
        glTexParameteri(texture.target, GLenum(GL_TEXTURE_MAG_FILTER), GL_NEAREST)
        return texture
    } else {
        throw TextureLoadError.urlNotFound
    }
}

public func URLForResource(_ name: String, extension ext: String, in folder: String? = nil) -> URL? {
    if let folder = folder where FileManager.default().isReadableFile(atPath: folder + "/" + name + "." + ext) {
        return URL(fileURLWithPath: folder + "/" + name + "." + ext)
    } else {
        return Bundle.main().urlForResource(name, withExtension: ext)
    }
}

private func clearGLError() {
    let error = glGetError()
    if error != 0 {
        NSLog("Erreur OpenGL : \(error)")
    }
}
