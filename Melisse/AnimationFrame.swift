//
//  AnimationFrame.swift
//  Melisse
//
//  Created by Raphaël Calabro on 07/05/2016.
//  Copyright © 2016 Raphaël Calabro. All rights reserved.
//

import GLKit

public struct AnimationFrame : Equatable {
    
    /// Emplacement de l'image dans l'atlas.
    ///
    /// La propriété `center` du rectangle représente le coin en haut à gauche.
    public var frame: Rectangle<Int>
    
    /// Zone de collision à l'intérieur de cette étape d'animation.
    public var hitbox: Rectangle<GLfloat>
	
    /// Taille de l'image.
    ///
    /// Peut être différent de `frame.size` si l'atlas est retina.
	public var size: Size<GLfloat>
    
    public init(x: Int = 0, y: Int = 0, width: Int = 0, height: Int = 0, hitbox: Rectangle<GLfloat> = Rectangle()) {
        self.frame = Rectangle(x: x, y: y, width: width, height: height)
		self.size = Size(width: GLfloat(width), height: GLfloat(height))
        self.hitbox = hitbox
    }
    
    public init(frame: Rectangle<Int>, size: Size<GLfloat>, hitbox: Rectangle<GLfloat> = Rectangle()) {
        self.frame = frame
        self.size = size
        self.hitbox = hitbox
    }
    
    public init(inputStream : InputStream) {
        let x = Streams.readInt(inputStream)
        let y = Streams.readInt(inputStream)
        let width = Streams.readInt(inputStream)
        let height = Streams.readInt(inputStream)
        self.frame = Rectangle(x: x, y: y, width: width, height: height)
		self.size = Size(width: GLfloat(width), height: GLfloat(height))
        
        if Streams.readBoolean(inputStream) {
            let left = GLfloat(Streams.readInt(inputStream))
            let top = GLfloat(Streams.readInt(inputStream))
            let width = GLfloat(Streams.readInt(inputStream))
            let height = GLfloat(Streams.readInt(inputStream))
            
            self.hitbox = Rectangle(left: left, top: top, width: width, height: height)
        } else {
            self.hitbox = Rectangle()
        }
    }
    
    public func draw(_ sprite: Sprite) {
        sprite.texCoordSurface.setQuadWith(left: frame.x, top: frame.y, width: frame.width, height: frame.height, direction: sprite.direction, texture: sprite.factory.textureAtlas)
    }
    
    public func frameChunksFor(width: Int, direction: Direction = .right) -> [AnimationFrame] {
        let start = frame.width * Int(direction.mirror)
        let end = frame.width * (1 - Int(direction.mirror))
        let width = width * Int(direction.value)
        
        return stride(from: start, to: end, by: width).map { left in
            AnimationFrame(x: frame.x + left, y: frame.y, width: width, height: frame.height)
        }
    }
    
}

public func ==(left: AnimationFrame, right: AnimationFrame) -> Bool {
    return left.frame == right.frame && left.hitbox == right.hitbox
}
