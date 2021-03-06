//
//  TouchController.swift
//  MeltedIce
//
//  Created by Raphaël Calabro on 30/09/2015.
//  Copyright © 2015 Raphaël Calabro. All rights reserved.
//

import GLKit

/// Contrôle avec un pad virtuel sur l'écran tactile.
public class TouchController : Controller {
    
    static public let instance = TouchController()
    
    let padButtonFrame = 2
    let jumpButtonFrame = 0
    
    public var direction: GLfloat = 0
    public var touches: [UnsafeRawPointer : Point<GLfloat>] = [:]
    var buttons = [GamePadButton : Button]()
    
    private var touchCount = 0
    private var previousTouchCount = 0
    
    public func pressed(_ button: GamePadButton) -> Bool {
        return buttons[button]?.pressed() ?? false
    }
    
    public func pressing(_ button: GamePadButton) -> Bool {
        return buttons[button]?.pressing() ?? false
    }
    
    public func touchedScreen() -> Bool {
        return touchCount > previousTouchCount
    }
    
    public func updateWith(_ touches: [UnsafeRawPointer : Point<GLfloat>]) {
        self.touches = touches
        self.previousTouchCount = touchCount
        self.touchCount = touches.count
        
        for button in buttons.values {
            button.updateWith(touches)
        }
        
        if buttons[.right] != nil && buttons[.right]!.pressing() {
            self.direction = 1
        } else if buttons[.left] != nil && buttons[.left]!.pressing() {
            self.direction = -1
        } else {
            self.direction = 0
        }
    }
    
    public func createButtonsWith(_ factory: SpriteFactory, definition: Int) {
        let zoom = View.instance.width / GLfloat(UIScreen.main.bounds.width)
        let shoulderButtonSize = Size<GLfloat>(width: 48, height: 32)
        let padY = View.instance.height - 48
        
        let leftButton = Button(factory: factory, definition: definition, left: 10, y: padY, frameIndex: padButtonFrame, zoom: zoom)
        let rightButton = Button(factory: factory, definition: definition, left: leftButton.sprite!.frame.right + 24, y: padY, frameIndex: padButtonFrame, zoom: zoom)
        let jumpButton = Button(factory: factory, definition: definition, right: View.instance.width - 10, y: padY, frameIndex: jumpButtonFrame, zoom: zoom)
        
        leftButton.sprite!.direction = .left
        
        buttons[.left] = leftButton
        buttons[.right] = rightButton
        buttons[.jump] = jumpButton
        buttons[.l] = Button(left: 0, top: 0, size: shoulderButtonSize, zoom: zoom)
        buttons[.r] = Button(right: View.instance.width, top: 0, size: shoulderButtonSize, zoom: zoom)
        buttons[.start] = Button(x: View.instance.width / 2, top: 0, size: shoulderButtonSize, zoom: zoom)
        
        factory.updateWith(0)
    }
    
}

/// Zone tactile sur l'écran servant de bouton
class Button {
    
    let zoom: GLfloat
    
    let hitbox: Hitbox
    let sprite: Sprite?
    let frameIndex: Int
    
    var state = false
    var previousState = false
    
    init(factory: SpriteFactory, definition: Int, left: GLfloat? = nil, right: GLfloat? = nil, y: GLfloat, frameIndex: Int, zoom: GLfloat) {
        let sprite = factory.sprite(definition)
        
        sprite.animation = SingleFrameAnimation(definition: sprite.animation.definition)
        sprite.animation.frameIndex = frameIndex
        
        var frame = Rectangle(center: Point(x: 0, y: y), size: sprite.animation.frame.size * zoom)
        if let left = left {
            frame.left = left
        }
        if let right = right {
            frame.right = right
        }
        
        sprite.frame = frame
        
        let margin = 32 * zoom
        
        self.sprite = sprite
        self.zoom = zoom
        self.hitbox = StaticHitbox(frame: Rectangle(center: sprite.frame.center, size: sprite.frame.size + margin))
        
        self.frameIndex = frameIndex
    }
    
    init(x: GLfloat? = nil, left: GLfloat? = nil, right: GLfloat? = nil, top: GLfloat, size: Size<GLfloat>, zoom: GLfloat) {
        self.sprite = nil
        self.frameIndex = 0
        self.zoom = zoom
        
        var frame = Rectangle(size: size)
        frame.top = top
        if let x = x {
            frame.x = x
        }
        if let left = left {
            frame.left = left
        }
        if let right = right {
            frame.right = right
        }
        self.hitbox = StaticHitbox(frame: frame)
    }
    
    deinit {
        sprite?.destroy()
    }
    
    func updateWith(_ touches: [UnsafeRawPointer : Point<GLfloat>]) {
        self.previousState = state
        self.state = false
        
        for touch in touches.values {
            self.state = state || hitbox.collides(with: touch * zoom)
        }
        
        if let sprite = self.sprite {
            if !state {
                sprite.animation.frameIndex = frameIndex
            } else {
                sprite.animation.frameIndex = frameIndex + 1
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
