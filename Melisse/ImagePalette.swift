//
//  ImagePalette.swift
//  Melisse
//
//  Created by Raphaël Calabro on 10/05/2016.
//  Copyright © 2016 Raphaël Calabro. All rights reserved.
//

import GLKit

open class ImagePalette : Palette {
    
    static let fileExtension = "pal"
    
    public var texture = GLKTextureInfo() {
        didSet {
            if texture.width > 0 {
                self.textureTileSize = GLfloat(tileSize) / GLfloat(texture.width)
                self.texturePadding = GLfloat(padding) / GLfloat(texture.width)
            } else {
                self.textureTileSize = 0
                self.texturePadding = 0
            }
        }
    }
    
    public var name = ""
    public let textureName: String
    public var textureTileSize: GLfloat = 0
    public var texturePadding: GLfloat = 0
    public var columns: Int
    
    public var tileSize: Int
    public var padding: Int
    
    public let functions: [Melisse.Operation?]
    
    public let parentPath: String?
    
    public init() {
        self.textureName = ""
        self.tileSize = 0
        self.padding = 0
        self.columns = 0
        self.functions = []
        self.parentPath = nil
    }
    
    public init(inputStream: InputStream, parentPath: String? = nil) {
        self.textureName = Streams.readString(inputStream)
        self.columns = Streams.readInt(inputStream)
        self.tileSize = Streams.readInt(inputStream)
        self.padding = Streams.readInt(inputStream)
        self.parentPath = parentPath
        
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
            if let parentPath = parentPath {
                self.texture = try textureAt(path: parentPath + "/" + textureName + "-32.png")
            } else {
                self.texture = try textureFor(resource: textureName + "-32", extension: "png")
            }
        } catch let error as NSError {
            NSLog("Erreur lors du chargement de la texture %@-32.png : %@", textureName, error)
        }
    }
    
}
