//
//  SpriteAtlas.swift
//  Melisse
//
//  Created by Raphaël Calabro on 19/05/2016.
//  Copyright © 2016 Raphaël Calabro. All rights reserved.
//

import GLKit

public class SpriteAtlas {
    
    static public private(set) var currentAtlas: SpriteAtlas?
    
    /// Définitions des sprites contenus dans l'atlas.
    public var definitions: [SpriteDefinition]
    
    /// Texture contenant toutes les étapes d'animation.
    public var texture: GLKTextureInfo
    
    public init() {
        self.definitions = []
        self.texture = GLKTextureInfo()
    }
    
    public init(definitions: [SpriteDefinition], texture: GLKTextureInfo) {
        self.definitions = definitions
        self.texture = texture
    }
    
    public init?(name: String, folder: String? = nil, animationNames: [AnimationName]) {
        do {
            texture = try textureForResource(name, extension: "png", in: folder)
        } catch {
            return nil
        }
        
        if let url = URLForResource(name, extension: "sprites", in: folder), let inputStream = NSInputStream(URL: url) {
            inputStream.open()
            definitions = SpriteDefinition.definitionsFrom(inputStream, animationNames: animationNames)
            inputStream.close()
        } else {
            return nil
        }
    }
    
    deinit {
        if texture.width != 0 && texture.height != 0 {
            Draws.freeTexture(texture)
        }
    }
    
    public func makeCurrent() {
        SpriteAtlas.currentAtlas = self
    }
    
}