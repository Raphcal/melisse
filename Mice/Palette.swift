//
//  Palette.swift
//  MeltedIce
//
//  Created by Raphaël Calabro on 26/06/2015.
//  Copyright (c) 2015 Raphaël Calabro. All rights reserved.
//

import GLKit

class Palette : NSObject {
    
    static let fileExtension = "pal"
    
    let textureName : String
    let tileSize : Int
    let columns : Int
    let padding : Int
    let functions : [[UInt8]?]
    
    var tileWidth : GLfloat = 0
    var tileHeight : GLfloat = 0
    var paddingX : GLfloat = 0
    var paddingY : GLfloat = 0
    
    var texture = GLKTextureInfo() {
        didSet {
            self.tileWidth = GLfloat(tileSize) / GLfloat(texture.width)
            self.tileHeight = GLfloat(tileSize) / GLfloat(texture.height)
            self.paddingX = GLfloat(padding) / GLfloat(texture.width)
            self.paddingY = GLfloat(padding) / GLfloat(texture.width)
        }
    }
    
    override init() {
        self.textureName = ""
        self.tileSize = 0
        self.columns = 0
        self.padding = 0
        self.functions = []
        
        super.init()
    }
    
    init(inputStream : NSInputStream) {
        self.textureName = Streams.readString(inputStream)
        self.columns = Streams.readInt(inputStream)
        self.tileSize = Streams.readInt(inputStream)
        self.padding = Streams.readInt(inputStream)
        
        let size = Streams.readInt(inputStream)
        var functions : [[UInt8]?] = []
        
        for _ in 0..<size {
            functions.append(Streams.readNullableByteArray(inputStream))
        }
        self.functions = functions
    }
    
    convenience init?(resource : String) {
        if let url = NSBundle.mainBundle().URLForResource(resource, withExtension: Palette.fileExtension), let inputStream = NSInputStream(URL: url) {
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
    
    func loadTexture() {
        do {
            self.texture = try Resources.textureForResource(textureName + "-32", withExtension: "png")
        } catch let error as NSError {
            NSLog("Erreur lors du chargement de la texture %@-32.png : %@", textureName, error)
        }
    }
    
    func tileLocation(tile : Int) -> Spot {
        return Spot(x: GLfloat(tile % columns), y: GLfloat(tile / columns))
    }
    
}