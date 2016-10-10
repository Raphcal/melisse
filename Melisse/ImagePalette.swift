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
            self.textureTileSize = GLfloat(tileSize) / GLfloat(texture.width)
            self.texturePadding = GLfloat(padding) / GLfloat(texture.width)
        }
    }
    
    public var name = ""
    public let textureName: String
    public var textureTileSize: GLfloat = 0
    public var texturePadding: GLfloat = 0
    public var columns: Int
    
    public var tileSize: Int
    public var padding: Int
    
    public let functions: [[UInt8]?]
    
    public init() {
        self.textureName = ""
        self.tileSize = 0
        self.padding = 0
        self.columns = 0
        self.functions = []
    }
    
    public init(inputStream : InputStream) {
        self.textureName = Streams.readString(inputStream)
        self.columns = Streams.readInt(inputStream)
        self.tileSize = Streams.readInt(inputStream)
        self.padding = Streams.readInt(inputStream)
        
        let size = Streams.readInt(inputStream)
        self.functions = (0 ..< size).map { _ in
            Streams.readNullableByteArray(inputStream)
        }
    }
    
    convenience public init?(resource : String) {
        if let url = Bundle.main.url(forResource: resource, withExtension: ImagePalette.fileExtension), let inputStream = InputStream(url: url) {
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
