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
public class Text {
    
    let zero = Text.integerFromCharacter("0")
    let nine = Text.integerFromCharacter("9")
    let upperCaseA = Text.integerFromCharacter("A")
    let upperCaseZ = Text.integerFromCharacter("Z")
    let lowerCaseA = Text.integerFromCharacter("a")
    let lowerCaseZ = Text.integerFromCharacter("z")
    let semicolon = Text.integerFromCharacter(":")
    let space = Text.integerFromCharacter(" ")
    
    public var origin: Point<GLfloat> {
        didSet {
            moveTo(origin)
        }
    }
    public private(set) var size: Size<GLfloat>
    
    public var alignment = TextAlignment.Left {
        didSet {
            moveTo(Point(x: frame.left, y: frame.y))
        }
    }
    
    public var frame: Rectangle<GLfloat> {
        get {
            switch alignment {
            case .Left:
                return Rectangle(left: origin.x, top: origin.y, width: size.width, height: size.height)
            case .Center:
                return Rectangle(left: origin.x - size.width / 2, top: origin.y, width: size.width, height: size.height)
            case .Right:
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
    
    public static func display(text: String, font: Font, factory: SpriteFactory, at point: Point<GLfloat>) {
        let _ = Text(factory: factory, font: font, text: text, point: point)
    }
    
    public init(text: String = "", font: Font = NoFont(), factory: SpriteFactory = SpriteFactory(), point: Point<GLfloat> = Point()) {
        self.factory = factory
        self.font = font
        self.value = text
        self.origin = point
        self.size = Size()
        
        displayText()
    }
    
    public func setBlinking(blinking: Bool) {
        for sprite in sprites {
            sprite.setBlinking(blinking)
        }
    }
    
    public func setBlinkingWithRate(blinkRate: NSTimeInterval) {
        for sprite in sprites {
            sprite.setBlinkingWith(rate: blinkRate)
        }
    }

    private func moveTo(point: Point<GLfloat>) {
        let difference = point - origin
        
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
        for c in value.utf8 {
            if Int8(c) == space {
                width += font.spaceWidth
            } else {
                // Création d'un sprite par lettre pour afficher le texte donné.
                let sprite = spriteFor(index)
                setFrameOf(sprite, toCharacter: Int8(c))
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
    
    private func spriteFor(index: Int) -> Sprite {
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
    
}