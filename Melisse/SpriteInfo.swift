//
//  SpriteInfo.swift
//  Melisse
//
//  Created by Raphaël Calabro on 08/05/2016.
//  Copyright © 2016 Raphaël Calabro. All rights reserved.
//

import Foundation

protocol SpriteInfo : Equatable {
    
}

/*
/// Information à propos d'un sprite.
struct SpriteInfo : Equatable {
    
    let index : Int
    let definition : SpriteDefinition
    let x : GLfloat
    let y : GLfloat
    
    let initializationScript : [UInt8]?
    var motion : Motion
    
    var taken : Bool
    let reload : Bool
    
    var sprite : Sprite?
    
    init(inputStream : NSInputStream, spriteFactory : SpriteFactory, index: Int) {
        self.index = index
        self.definition = spriteFactory.definitions[Streams.readInt(inputStream)]
        let x = Streams.readInt(inputStream)
        let y = Streams.readInt(inputStream)
        self.x = GLfloat(x)
        self.y = GLfloat(y)
        self.reload = !Streams.readBoolean(inputStream)
        self.initializationScript = Streams.readNullableByteArray(inputStream)
        self.taken = false
        self.motion = NoMotion.instance
    }
    
    func createSprite(spriteFactory: SpriteFactory, gameScene: GameScene) {
        if(self.sprite != nil || taken) {
            return;
        }
        
        let sprite = spriteFactory.sprite(definition, info: self)
        sprite.topLeft = Spot(x: x, y: y)
        sprite.motion = motion
        
        motion.load(sprite)
        Operation.execute(initializationScript, sprite: sprite)
        
        self.sprite = sprite
    }
    
    func releaseSprite(spriteFactory: SpriteFactory) {
        if let sprite = self.sprite {
            if !sprite.removed {
                spriteFactory.removeSprite(sprite)
                taken = sprite.dead
            } else {
                taken = definition.type == SpriteType.Collectable || !reload
            }
            
            self.sprite = nil
        }
    }
    
}

func == (left: SpriteInfo, right: SpriteInfo) -> Bool {
    return left.definition == right.definition && left.x == right.x && left.y == right.y
}
*/