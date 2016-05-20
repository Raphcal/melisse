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
    
    public var texture = GLKTextureInfo() {
        didSet {
            self.tileSize = GLushort(Double(rawTileSize * 0xFFFF) / Double(texture.width))
            self.padding = GLushort(Double(rawPadding * 0xFFFF) / Double(texture.width))
        }
    }
    public let textureName: String
    public var tileSize: GLushort = 0
    public var padding: GLushort = 0
    public let columns: Int
    
    let rawTileSize: Int
    let rawPadding: Int
    
    public let functions: [[UInt8]?]
    
    public init() {
        self.textureName = ""
        self.rawTileSize = 0
        self.rawPadding = 0
        self.columns = 0
        self.functions = []
    }
    
    public init(inputStream : NSInputStream) {
        self.textureName = Streams.readString(inputStream)
        self.columns = Streams.readInt(inputStream)
        self.rawTileSize = Streams.readInt(inputStream)
        self.rawPadding = Streams.readInt(inputStream)
        
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
            self.texture = try textureForResource(textureName + "-32", extension: "png")
        } catch let error as NSError {
            NSLog("Erreur lors du chargement de la texture %@-32.png : %@", textureName, error)
        }
    }
    
}
