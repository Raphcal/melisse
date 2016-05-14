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
class TouchController : Controller {
    
    static let instance = TouchController()
    
    static let padButtonFrame = 2
    static let jumpButtonFrame = 0
    
    private let factory = SpriteFactory(capacity: 5)
    
    var direction : GLfloat = 0
    var buttons = [GamePadButton:Button]()
    
    let zoom : GLfloat
    
    init() {
        self.zoom = View.instance.width / GLfloat(UIScreen.mainScreen().bounds.width)
        
        let leftButton = Button(factory: factory, frame: TouchController.padButtonFrame, zoom: zoom)
        let rightButton = Button(factory: factory, frame: TouchController.padButtonFrame, zoom: zoom)
        let jumpButton = Button(factory: factory, frame: TouchController.jumpButtonFrame, zoom: zoom)
        
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
        
        factory.updateWithTimeSinceLastUpdate(0)
    }
    
    func pressed(button: GamePadButton) -> Bool {
        if let b = buttons[button] {
            return b.pressed()
        } else {
            return false
        }
    }
    
    func pressing(button: GamePadButton) -> Bool {
        if let b = buttons[button] {
            return b.pressing()
        } else {
            return false
        }
    }
    
    func draw() {
        factory.drawUntranslated()
    }
    
    func updateWithTouches(touches: [Int:Point<GLfloat>]) {
        for button in buttons.values {
            button.updateWithTouches(touches)
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
    
}

/// Zone tactile sur l'écran servant de bouton
class Button {
    
    let zoom : GLfloat
    
    let hitbox : Hitbox
    let sprite : Sprite?
    let frame : Int
    
    var state = false
    var previousState = false
    
    init(factory: SpriteFactory, frame: Int, zoom: GLfloat) {
        let sprite = factory.sprite(Sprite.buttonGUIDefinition)
        
        sprite.animation = SingleFrameAnimation(definition: sprite.animation.definition)
        sprite.animation.frameIndex = frame
        
        sprite.width = GLfloat(sprite.animation.frame.width) * zoom
        sprite.height = GLfloat(sprite.animation.frame.height) * zoom
        
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
    
    func updateWithTouches(touches: [Int:Point<GLfloat>]) {
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
