//
//  Counter.swift
//  MeltedIce
//
//  Created by Raphaël Calabro on 01/07/2015.
//  Copyright (c) 2015 Raphaël Calabro. All rights reserved.
//

import GLKit

// TODO: Revoir cette classe.

/// Compteur affichant une valeur alignée en haut à droite en utilisant un sprite par chiffre.
public class Counter {
    
    public var frame: Rectangle<GLfloat>
    
    public let factory: SpriteFactory
    public var value: Int = 0 {
        didSet {
            self.digits = value.digits
            displayValue()
        }
    }
    
    var digits = [Int]()
    var sprites = [Sprite]()
    
    init() {
        self.frame = Rectangle()
        self.factory = SpriteFactory()
    }
    
    init(factory: SpriteFactory, x: GLfloat, y: GLfloat) {
        self.factory = factory
        self.value = 0
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
            sprites.append(createDigit())
        }
        
        for index in 0..<digits.count {
            let sprite = sprites[index]
            
            // Pour l'alignement à gauche, utiliser "+ index * sprite.width".
            sprite.topLeft = Point(x: self.x - GLfloat(index) * sprite.width, y: self.y)
            
            // Pour l'alignement à gauche, utiliser "digits.count - index - 1".
            sprite.animation.frameIndex = digits[index]
        }
    }
    
    private func createDigit() -> Sprite {
        let sprite = factory.sprite(Sprite.countGUIDefinition)
        
        let definition = sprite.animation.definition
        let animation = SingleFrameAnimation(definition: definition)
        
        sprite.animation = animation
        return sprite
    }
    
}
