//
//  ImagePalette.swift
//  Melisse
//
//  Created by Raphaël Calabro on 10/05/2016.
//  Copyright © 2016 Raphaël Calabro. All rights reserved.
//

import GLKit

public class ImagePalette : Palette {
    
    static let fileExtension = "pal"
    
    public var texture = GLKTextureInfo()
    public let textureName: String
    public let tileSize: GLshort
    public let padding: GLshort
    public let columns: Int
    
    public let functions: [[UInt8]?]
    
    public init() {
        self.textureName = ""
        self.tileSize = 0
        self.columns = 0
        self.padding = 0
        self.functions = []
    }
    
    public init(inputStream : NSInputStream) {
        self.textureName = Streams.readString(inputStream)
        self.columns = Streams.readInt(inputStream)
        self.tileSize = GLshort(Streams.readInt(inputStream))
        self.padding = GLshort(Streams.readInt(inputStream))
        
        let size = Streams.readInt(inputStream)
        self.functions = (0 ..< size).map { _ in
            Streams.readNullableByteArray(inputStream)
        }
    }
    
    convenience public init?(resource : String) {
        if let url = NSBundle.mainBundle().URLForResource(resource, withExtension: ImagePalette.fileExtension), let inputStream = NSInputStream(URL: url) {
            inputStream.open()
            self.init(inputStream: inputStream)
            inputStream.close()
        } else {
            self.init()
            return nil
        }
    }
    
    deinit {
        if texture.width != 0 && texture.height != 0 {
            Draws.freeTexture(texture)
        }
    }
    
    public func loadTexture() {
        do {
            self.texture = try Resources.textureForResource(textureName + "-32", withExtension: "png")
        } catch let error as NSError {
            NSLog("Erreur lors du chargement de la texture %@-32.png : %@", textureName, error)
        }
    }
    
}
