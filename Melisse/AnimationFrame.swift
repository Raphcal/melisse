//
//  AnimationFrame.swift
//  Melisse
//
//  Created by Raphaël Calabro on 07/05/2016.
//  Copyright © 2016 Raphaël Calabro. All rights reserved.
//

import GLKit

public struct AnimationFrame : Equatable {
    
    public var frame: Rectangle<GLshort>
    public var hitbox: Rectangle<GLfloat>
    
    public init() {
        self.frame = Rectangle()
        self.hitbox = Rectangle()
    }
    
    public init(width: GLshort, height: GLshort) {
        self.frame = Rectangle(x: 0, y: 0, width: width, height: height)
        self.hitbox = Rectangle()
    }
    
    public init(x: GLshort, y: GLshort, width: GLshort, height: GLshort) {
        self.frame = Rectangle(left: x, top: y, width: width, height: height)
        self.hitbox = Rectangle()
    }
    
    public init(inputStream : NSInputStream) {
        let x = GLshort(Streams.readInt(inputStream))
        let y = GLshort(Streams.readInt(inputStream))
        let width = GLshort(Streams.readInt(inputStream))
        let height = GLshort(Streams.readInt(inputStream))
        self.frame = Rectangle(left: x, top: y, width: width, height: height)
        
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
    
    public func draw(sprite: Sprite) {
        sprite.texCoordSurface.setQuadWith(left: frame.x, top: frame.y, width: frame.width, height: frame.height, direction: sprite.direction, texture: sprite.factory.textureAtlas)
    }
    
    public func frameChunksFor(width width: GLshort, direction: Direction = .Right) -> [AnimationFrame] {
        let start = frame.width * GLshort(direction.mirror)
        let end = frame.width * (1 - GLshort(direction.mirror))
        let width = GLshort(width) * GLshort(direction.value)
        
        return start.stride(to: end, by: Int(width)).map { left in
            AnimationFrame(x: frame.x + left, y: frame.y, width: width, height: frame.height)
        }
    }
    
}

public func ==(left: AnimationFrame, right: AnimationFrame) -> Bool {
    return left.frame == right.frame && left.hitbox == right.hitbox
}