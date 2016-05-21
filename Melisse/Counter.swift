//
//  Counter.swift
//  MeltedIce
//
//  Created by Raphaël Calabro on 01/07/2015.
//  Copyright (c) 2015 Raphaël Calabro. All rights reserved.
//

import GLKit

/// Compteur affichant une valeur alignée en haut à droite en utilisant un sprite par chiffre.
public class Counter {
    
    public var topLeft: Point<GLfloat>
    
    public let factory: SpriteFactory
    public var font: Font
    public var value: Int = 0 {
        didSet {
            self.digits = value.digits
            displayValue()
        }
    }
    
    private var digits = [Int]()
    private var sprites = [Sprite]()
    
    public init() {
        self.topLeft = Point()
        self.factory = SpriteFactory()
        self.font = NoFont()
    }
    
    public init(factory: SpriteFactory, font: Font, topLeft: Point<GLfloat> = Point()) {
        self.factory = factory
        self.font = font
        self.topLeft = topLeft
        
        displayValue()
    }
    
    deinit {
        for sprite in sprites {
            sprite.destroy()
        }
    }
    
    private func displayValue() {
        while sprites.count > digits.count {
            sprites[sprites.count - 1].destroy()
            sprites.removeAtIndex(sprites.count - 1)
        }
        while sprites.count < digits.count {
            sprites.append(digit())
        }
        
        for index in 0 ..< digits.count {
            let sprite = sprites[index]
            
            // Pour l'alignement à gauche, utiliser "+ index * sprite.frame.width".
            sprite.frame.topLeft = Point(x: topLeft.x - GLfloat(index) * sprite.frame.width, y: topLeft.y)
            
            // Pour l'alignement à gauche, utiliser "digits.count - index - 1".
            sprite.animation.frameIndex = digits[index]
        }
    }
    
    private func digit() -> Sprite {
        let sprite = factory.sprite(font.definition)
        
        let definition = sprite.definition.animations[font.digitAnimation.name]
        let animation = SingleFrameAnimation(definition: definition!)
        
        sprite.animation = animation
        return sprite
    }
    
}
