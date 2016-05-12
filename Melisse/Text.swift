//
//  Text.swift
//  MeltedIce
//
//  Created by Raphaël Calabro on 11/02/2016.
//  Copyright © 2016 Raphaël Calabro. All rights reserved.
//

import GLKit

/// Alignement typographique de la valeur d'un objet Text.
/// L'alignement se fait par rapport à la position x de l'objet.
public enum TextAlignment {
    case Left, Center, Right
}

/// Affiche un texte aligné en haut à gauche en utilisant un sprite par lettre.
public struct Text {
    
    let zero = Text.integerFromCharacter("0")
    let nine = Text.integerFromCharacter("9")
    let upperCaseA = Text.integerFromCharacter("A")
    let upperCaseZ = Text.integerFromCharacter("Z")
    let lowerCaseA = Text.integerFromCharacter("a")
    let lowerCaseZ = Text.integerFromCharacter("z")
    let semicolon = Text.integerFromCharacter(":")
    let space = Text.integerFromCharacter(" ")
    
    var frame: Rectangle<GLfloat>
    var font: Font
    let factory: SpriteFactory
    
    var sprites = [Sprite]()
    var value = "" {
        didSet {
            if value != oldValue {
                displayText()
            }
        }
    }
    
    var alignment = TextAlignment.Left {
        didSet {
//            switch alignment {
//            case .Left:
//                reflowTextFrom(x)
//            case .Center:
//                reflowTextFrom(x - width / 2)
//            case .Right:
//                reflowTextFrom(x - width)
//            }
        }
    }
    
//    var top : GLfloat {
//        get {
//            return y
//        }
//    }
//    
//    var bottom : GLfloat {
//        get {
//            return y + height
//        }
//    }
//    
//    var left : GLfloat {
//        get {
//            switch alignment {
//            case .Left:
//                return x
//            case .Center:
//                return x - width / 2
//            case .Right:
//                return x - width
//            }
//        }
//    }
//    
//    var right : GLfloat {
//        get {
//            switch alignment {
//            case .Left:
//                return x + width
//            case .Center:
//                return x + width / 2
//            case .Right:
//                return x
//            }
//        }
//    }
    
    public static func display(text: String, font: Font, factory: SpriteFactory, at point: Point<GLfloat>) {
        let _ = Text(factory: factory, font: font, text: text, point: point)
    }
    
    public init(factory: SpriteFactory = SpriteFactory(), font: Font = NoFont(), text: String = "", point: Point<GLfloat> = Point()) {
        self.factory = factory
        self.font = font
        self.value = text
        self.frame = Rectangle(center: point)
        
        displayText()
    }
    
//    func setBlinking(blinking: Bool) {
//        for sprite in sprites {
//            sprite.setBlinking(blinking)
//        }
//    }
//    
//    func setBlinkingWithRate(blinkRate: NSTimeInterval) {
//        for sprite in sprites {
//            sprite.setBlinkingWithRate(blinkRate)
//        }
//    }
//    
//    func moveToLocation(location: Spot) {
//        let differenceX = location.x - x
//        let differenceY = location.y - y
//        
//        for sprite in sprites {
//            sprite.x += differenceX
//            sprite.y += differenceY
//            sprite.updateLocation()
//        }
//        
//        self.x = location.x
//        self.y = location.y
//    }
    
    private mutating func displayText() {
        var width: GLfloat = 0
        var height: GLfloat = 0
        
        var sprites = [Sprite]()
        
        var index = 0
        for c in value.utf8 {
            if Int8(c) == space {
                width += font.spaceWidth
            } else {
                // Création d'un sprite par lettre pour afficher le texte donné.
                let sprite = spriteFor(index)
                setFrameOf(sprite, toCharacter: Int8(c))
                sprite.frame.topLeft = Point(x: frame.x + width, y: frame.y)
                
                sprites.append(sprite)
                
                index += 1
                width += sprite.frame.width
                height = max(sprite.frame.height, height)
            }
        }
        
        for _ in index ..< self.sprites.count {
            let sprite = self.sprites.removeLast()
            sprite.destroy()
        }
        
        self.frame.size = Size(width: width, height: height)
        self.sprites = sprites
    }
    
    private mutating func spriteFor(index: Int) -> Sprite {
        let sprite : Sprite
        
        if index < sprites.count {
            sprite = sprites[index]
        } else {
            sprite = factory.sprite(font.definition)
            sprites.append(sprite)
        }
        
        return sprite
    }
    
    private func setFrameOf(sprite: Sprite, toCharacter value: Int8) {
        if value >= zero && value <= nine {
            // Chiffre.
            sprite.animation = SingleFrameAnimation(definition: sprite.definition.animations[font.digitAnimation.name]!)
            sprite.animation.frameIndex = value - zero
            
            resize(sprite)
            
        } else if value >= upperCaseA && value <= upperCaseZ {
            // Lettre majuscule.
            sprite.animation = SingleFrameAnimation(definition: sprite.definition.animations[font.upperCaseAnimation.name]!)
            sprite.animation.frameIndex = value - upperCaseA
            
            resize(sprite)
            
        } else if value >= lowerCaseA && value <= lowerCaseZ {
            // Lettre minuscule.
            sprite.animation = SingleFrameAnimation(definition: sprite.definition.animations[font.lowerCaseAnimation.name]!)
            sprite.animation.frameIndex = value - lowerCaseA
            
            resize(sprite)
            
        } else if value == semicolon {
            // "Deux points".
            sprite.animation = SingleFrameAnimation(definition: sprite.definition.animations[font.semicolonAnimation.name]!)
            sprite.animation.frameIndex = 0
            
            resize(sprite)
            
        } else {
            // Espace ou lettre non supportée.
            sprite.animation = NoAnimation()
        }
    }
    
    private func resize(sprite: Sprite) {
        let frame = sprite.animation.frame.frame
        sprite.frame.size = Size(width: GLfloat(frame.width), height: GLfloat(frame.height))
    }
    
    private static func integerFromCharacter(c: Character) -> Int8 {
        let string = String(c)
        let nsString = NSString(string: string)
        let utf8Pointer = nsString.UTF8String
        
        return utf8Pointer[0]
    }
    
    private func reflowTextFrom(x: GLfloat) {
        let difference = sprites[0].frame.x - x
        
        for sprite in sprites {
            sprite.frame.x -= difference
        }
    }
    
}