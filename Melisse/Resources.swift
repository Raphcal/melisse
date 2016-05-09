//
//  Textures.swift
//  MeltedIce
//
//  Created by Raphaël Calabro on 17/08/2015.
//  Copyright (c) 2015 Raphaël Calabro. All rights reserved.
//

import GLKit

enum ResourceLoadError : ErrorType {
    case URLNotFound
}

class Resources {
    
    static let instance = Resources()
    static var context : String?
    
    var textureAtlas : GLKTextureInfo
    var definitions : [SpriteDefinition]
    
    var grid = Grid()
    
    init() {
        do {
            self.textureAtlas = try Resources.textureForResource("atlas", withExtension: "png")
        } catch {
            NSLog("Erreur de chargement de la texture des sprites \(error)")
            self.textureAtlas = GLKTextureInfo()
        }
        
        if let url = Resources.URLForResource("atlas", withExtension: "sprites"), let inputStream = NSInputStream(URL: url) {
            inputStream.open()
            self.definitions = SpriteDefinition.definitionsFrom(inputStream)
            inputStream.close()
        } else {
            NSLog("Erreur de chargement des définitions.")
            self.definitions = []
        }
    }
    
    static func textureForResource(name: String, withExtension ext: String) throws -> GLKTextureInfo {
        let error = glGetError()
        if error != 0 {
            NSLog("Erreur OpenGL : \(error)")
        }
        
        if let url = URLForResource(name, withExtension: ext) {
            #if os(iOS)
                let premultiplication = false
            #else
                let premultiplication = true
            #endif
            return try GLKTextureLoader.textureWithContentsOfURL(url, options: [GLKTextureLoaderOriginBottomLeft: false, GLKTextureLoaderApplyPremultiplication: premultiplication])
        } else {
            throw ResourceLoadError.URLNotFound
        }
    }
    
    private static func URLForResource(name: String, withExtension ext: String) -> NSURL? {
        if let context = Resources.context where NSFileManager.defaultManager().isReadableFileAtPath(context + "/" + name + "." + ext) {
            return NSURL(fileURLWithPath: context + "/" + name + "." + ext)
        } else {
            return NSBundle.mainBundle().URLForResource(name, withExtension: ext)
        }
    }
    
    func reloadSpriteTextureAndAtlasFromMML(mml: String) {
        Resources.context = mml
        
        do {
            let oldTextureAtlas = textureAtlas
            self.textureAtlas = try Resources.textureForResource("atlas", withExtension: "png")
            Draws.freeTexture(oldTextureAtlas)
        } catch {
            NSLog("Erreur de chargement de la texture des sprites \(error)")
        }
        
        if let inputStream = NSInputStream(fileAtPath: mml + "/atlas.sprites") {
            inputStream.open()
            self.definitions = SpriteDefinition.definitionsFromInputStream(inputStream)
            inputStream.close()
        }
    }

    
}