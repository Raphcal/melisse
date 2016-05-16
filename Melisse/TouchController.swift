//
//  TouchController.swift
//  MeltedIce
//
//  Created by Raphaël Calabro on 30/09/2015.
//  Copyright © 2015 Raphaël Calabro. All rights reserved.
//

import GLKit

// TODO: Revoir cette classe.

/// Contrôle avec un pad virtuel sur l'écran tactile.
public class TouchController : Controller {
    
    static public let instance = TouchController()
    
    let padButtonFrame = 2
    let jumpButtonFrame = 0
    
    private let factory = SpriteFactory(capacity: 5)
    
    public var direction: GLfloat = 0
    public var buttons = [GamePadButton:Button]()
    
    public let zoom: GLfloat
    
    public init() {
        self.zoom = View.instance.width / GLfloat(UIScreen.mainScreen().bounds.width)
    }
    
    public func pressed(button: GamePadButton) -> Bool {
        if let b = buttons[button] {
            return b.pressed()
        } else {
            return false
        }
    }
    
    public func pressing(button: GamePadButton) -> Bool {
        if let b = buttons[button] {
            return b.pressing()
        } else {
            return false
        }
    }
    
    public func draw() {
        factory.draw()
    }
    
    public func updateWith(touches: [UnsafePointer<Void> : Point<GLfloat>]) {
        for button in buttons.values {
            button.updateWith(touches)
        }
        
        if buttons[.Right] != nil && buttons[.Right]!.pressing() {
            self.direction = 1
        } else if buttons[.Left] != nil && buttons[.Left]!.pressing() {
            self.direction = -1
        } else {
            self.direction = 0
        }
        factory.updateWithTimeSinceLastUpdate(0)
    }
    
    public func createButtonsWith(definition: Int) {
        let leftButton = Button(factory: factory, frame: padButtonFrame, zoom: zoom)
        let rightButton = Button(factory: factory, frame: padButtonFrame, zoom: zoom)
        let jumpButton = Button(factory: factory, frame: jumpButtonFrame, zoom: zoom)
        
        leftButton.sprite!.direction = .Left
        
        let defaultSize = 48 * zoom
        let padY = View.instance.height - 64 * zoom
        
        leftButton.sprite!.center = Point(x: 40 * zoom, y: padY)
        rightButton.sprite!.center = Point(x: 120 * zoom, y: padY)
        jumpButton.sprite!.center = Point(x: View.instance.width - defaultSize, y: padY)
        
        buttons[.Left] = leftButton
        buttons[.Right] = rightButton
        buttons[.Jump] = jumpButton
        buttons[.L] = Button(left: 0, top: 0, width: defaultSize, height: defaultSize, zoom: zoom)
        buttons[.R] = Button(left: GLfloat(View.instance.width - defaultSize), top: 0, width: defaultSize, height: defaultSize, zoom: zoom)
        buttons[.Start] = Button(left: GLfloat(View.instance.width - defaultSize) / 2, top: 0, width: defaultSize, height: defaultSize, zoom: zoom)
        
        factory.updateWith(0)
    }
    
}

/// Zone tactile sur l'écran servant de bouton
class Button {
    
    let zoom: GLfloat
    
    let hitbox: Hitbox
    let sprite: Sprite?
    let frame: Int
    
    var state = false
    var previousState = false
    
    init(factory: SpriteFactory, definition: Int, frame: Int, zoom: GLfloat) {
        let sprite = factory.sprite(definition)
        
        sprite.animation = SingleFrameAnimation(definition: sprite.animation.definition)
        sprite.animation.frameIndex = frame
        
        sprite.frame.size = Size(width: GLfloat(sprite.animation.frame.width) * zoom, height: GLfloat(sprite.animation.frame.height) * zoom)
        
        let margin = 32 * zoom
        
        self.sprite = sprite
        self.zoom = zoom
        self.hitbox = SimpleHitbox(center: sprite, width: sprite.width + margin, height: sprite.height + margin)
        self.frame = frame
    }
    
    init(left: GLfloat, top: GLfloat, width: GLfloat, height: GLfloat, zoom: GLfloat) {
        self.sprite = nil
        self.frame = 0
        self.zoom = zoom
        self.hitbox = SimpleHitbox(center: Point(x: left + width / 2, y: top + width / 2), width: width, height: height)
    }
    
    deinit {
        sprite?.destroy()
    }
    
    func updateWith(touches: [UnsafePointer<Void> : Point<GLfloat>]) {
        self.previousState = state
        self.state = false
        
        for touch in touches.values {
            self.state = state || hitbox.collidesWith(touch.x * zoom, y: touch.y * zoom)
        }
        
        if let sprite = self.sprite {
            if !state {
                sprite.animation.frameIndex = frame
            } else {
                sprite.animation.frameIndex = frame + 1
            }
        }
    }
    
    func pressed() -> Bool {
        return state && !previousState
    }
    
    func pressing() -> Bool {
        return state
    }
    
}
