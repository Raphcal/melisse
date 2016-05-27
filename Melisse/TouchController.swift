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
    public var touches: [UnsafePointer<Void> : Point<GLfloat>] = [:]
    var buttons = [GamePadButton : Button]()
    
    public let zoom: GLfloat
    
    private var touchCount = 0
    private var previousTouchCount = 0
    
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
    
    public func touchedScreen() -> Bool {
        return touchCount > previousTouchCount
    }
    
    public func updateWith(touches: [UnsafePointer<Void> : Point<GLfloat>]) {
        self.touches = touches
        self.previousTouchCount = touchCount
        self.touchCount = touches.count
        
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
    }
    
    public func createButtonsWith(factory: SpriteFactory, definition: Int) {
        let defaultSize: GLfloat = 48
        let padY = View.instance.height - 48
        
        let leftButton = Button(factory: factory, definition: definition, left: 10, y: padY, frameIndex: padButtonFrame, zoom: zoom)
        let rightButton = Button(factory: factory, definition: definition, left: leftButton.sprite!.frame.right + 24, y: padY, frameIndex: padButtonFrame, zoom: zoom)
        let jumpButton = Button(factory: factory, definition: definition, right: View.instance.width - 10, y: padY, frameIndex: jumpButtonFrame, zoom: zoom)
        
        leftButton.sprite!.direction = .Left
        
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
    let frameIndex: Int
    
    var state = false
    var previousState = false
    
    init(factory: SpriteFactory, definition: Int, center: Point<GLfloat>, frame: Int, zoom: GLfloat) {
        let sprite = factory.sprite(definition)
        
        sprite.animation = SingleFrameAnimation(definition: sprite.animation.definition)
        sprite.animation.frameIndex = frame
        
        sprite.frame = Rectangle(center: center, size: sprite.animation.frame.size * zoom)
        
        let margin: GLfloat = 16
        
        self.sprite = sprite
        self.zoom = zoom
        self.hitbox = StaticHitbox(frame: Rectangle(center: sprite.frame.center, size: Size(width: sprite.frame.width + margin, height: sprite.frame.height + margin)))
     
        self.frameIndex = frame
    }
    
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
        self.hitbox = StaticHitbox(frame: Rectangle(center: sprite.frame.center, size: Size(width: sprite.frame.width + margin, height: sprite.frame.height + margin)))
        
        self.frameIndex = frameIndex
    }
    
    init(left: GLfloat, top: GLfloat, width: GLfloat, height: GLfloat, zoom: GLfloat) {
        self.sprite = nil
        self.frameIndex = 0
        self.zoom = zoom
        self.hitbox = StaticHitbox(frame: Rectangle(left: left, top: top, width: width, height: height))
    }
    
    deinit {
        sprite?.destroy()
    }
    
    func updateWith(touches: [UnsafePointer<Void> : Point<GLfloat>]) {
        self.previousState = state
        self.state = false
        
        for touch in touches.values {
            self.state = state || hitbox.collidesWith(touch * zoom)
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
