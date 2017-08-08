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
    case left, center, right
}

fileprivate func integerFromCharacter(_ c: Character) -> UInt16 {
    return String(c).utf16.first!
}

fileprivate let zero = integerFromCharacter("0")
fileprivate let nine = integerFromCharacter("9")
fileprivate let upperCaseA = integerFromCharacter("A")
fileprivate let upperCaseZ = integerFromCharacter("Z")
fileprivate let lowerCaseA = integerFromCharacter("a")
fileprivate let lowerCaseZ = integerFromCharacter("z")
fileprivate let hiraganaあ = integerFromCharacter("あ")
fileprivate let hiraganaゟ = integerFromCharacter("ゟ")
fileprivate let katakanaア = integerFromCharacter("あ")
fileprivate let katakanaヿ = integerFromCharacter("ヿ")
fileprivate let semicolon = integerFromCharacter(":")
fileprivate let space = integerFromCharacter(" ")

/// Affiche un texte aligné en haut à gauche en utilisant un sprite par lettre.
public class Text {
    
    public var origin: Point<GLfloat> {
        didSet {
            moveBy(origin - oldValue)
        }
    }
    public private(set) var size: Size<GLfloat>
    
    public var alignment = TextAlignment.left {
        didSet {
            moveBy(Point(x: frame.left, y: frame.top) - origin)
        }
    }
    
    public var frame: Rectangle<GLfloat> {
        get {
            switch alignment {
            case .left:
                return Rectangle(left: origin.x, top: origin.y, width: size.width, height: size.height)
            case .center:
                return Rectangle(left: origin.x - size.width / 2, top: origin.y, width: size.width, height: size.height)
            case .right:
                return Rectangle(left: origin.x - size.width, top: origin.y, width: size.width, height: size.height)
            }
        }
    }
    
    public var font: Font {
        didSet {
            displayText()
        }
    }
    public let factory: SpriteFactory
    
    private var sprites = [Sprite]()
    public var value = "" {
        didSet {
            if value != oldValue {
                displayText()
            }
        }
    }
    
    public static func display(_ text: String, font: Font, factory: SpriteFactory, at point: Point<GLfloat>) {
        let _ = Text(text: text, font: font, factory: factory, point: point)
    }
    
    public init(text: String = "", font: Font = NoFont(), factory: SpriteFactory = SpriteFactory(), point: Point<GLfloat> = Point()) {
        self.factory = factory
        self.font = font
        self.value = text
        self.origin = point
        self.size = Size()
        
        displayText()
    }
    
    public func setBlinking(_ blinking: Bool) {
        for sprite in sprites {
            sprite.setBlinking(blinking)
        }
    }
    
    public func setBlinkingWithRate(_ blinkRate: TimeInterval) {
        for sprite in sprites {
            sprite.setBlinkingWith(rate: blinkRate)
        }
    }

    private func moveBy(_ difference: Point<GLfloat>) {
        for sprite in sprites {
            sprite.frame.center += difference
        }
    }
    
    private func displayText() {
        let left = origin.x
        let top = origin.y
        var width: GLfloat = 0
        var height: GLfloat = 0
        
        var sprites = [Sprite]()
        
        var index = 0
        for character in value.utf16 {
            if character == space {
                width += font.spaceWidth
            } else {
                // Création d'un sprite par lettre pour afficher le texte donné.
                let sprite = spriteFor(index)
                setFrameOf(sprite, toCharacter: character)
                sprite.frame.topLeft = Point(x: left + width, y: top)
                
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
        
        self.size = Size(width: width, height: height)
        self.sprites = sprites
    }
    
    private func spriteFor(_ index: Int) -> Sprite {
        let sprite : Sprite
        
        if index < sprites.count {
            sprite = sprites[index]
        } else {
            sprite = factory.sprite(font.definition)
            sprites.append(sprite)
        }
        
        return sprite
    }
    
    private func setFrameOf(_ sprite: Sprite, toCharacter value: UInt16) {
        // Chiffre.
        if value >= zero && value <= nine {
            configure(sprite, animation: font.digitAnimation, frameIndex: Int(value - zero))
        }
        // Lettre majuscule.
        else if value >= upperCaseA && value <= upperCaseZ {
            configure(sprite, animation: font.upperCaseAnimation, frameIndex: Int(value - upperCaseA))
        }
        // Lettre minuscule.
        else if value >= lowerCaseA && value <= lowerCaseZ {
            configure(sprite, animation: font.lowerCaseAnimation, frameIndex: Int(value - lowerCaseA))
        }
        // "Deux points".
        else if value == semicolon {
            configure(sprite, animation: font.semicolonAnimation, frameIndex: 0)
        }
        // Hiragana.
        else if value >= hiraganaあ && value <= hiraganaゟ {
            configure(sprite, animation: font.hiraganaAnimation, frameIndex: Int(value - hiraganaあ))
        }
        // Katakana.
        else if value >= katakanaア && value <= katakanaヿ {
            configure(sprite, animation: font.katakanaAnimation, frameIndex: Int(value - katakanaア))
        }
        // Lettre non supportée.
        else {
            sprite.animation = NoAnimation()
        }
    }
    
    private func configure(_ sprite: Sprite, animation: AnimationName, frameIndex: Int) {
        sprite.animation = SingleFrameAnimation(definition: sprite.definition.animations[animation.name]!)
        sprite.animation.frameIndex = frameIndex
        sprite.frame.size = sprite.animation.frame.size
    }
    
}
