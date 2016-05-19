//
//  KeyboardController.swift
//  MeltedIce
//
//  Created by Raphaël Calabro on 30/09/2015.
//  Copyright © 2015 Raphaël Calabro. All rights reserved.
//

import GLKit

/// Valeurs des touches du clavier.
public enum KeyCode : UInt16 {
    case R = 15
    case Enter = 36
    case L = 37
    case Space = 49
    case Left = 123
    case Right = 124
    case Down = 125
    case Up = 126
    
    case A = 12
    case C = 8
    case D = 2
    case F = 3
    case Q = 0
    case V = 9
    case W = 6
    case X = 7
}

/// Reçoit les événements du clavier et les dispatch vers le bon contrôleur.
public class KeyboardInputSource {

    static public let instance = KeyboardInputSource()

    public var listeners = [UInt16 : KeyboardController]()
    
    public func keyDown(keyCode: UInt16) {
        listeners[keyCode]?.keyDown(keyCode)
    }
    
    public func keyUp(keyCode: UInt16) {
        listeners[keyCode]?.keyUp(keyCode)
    }

}

/// Contrôle au clavier.
public class KeyboardController : Controller {
    
    var buttonForKeyCode = [UInt16:GamePadButton]()
    
    var buttons = Set<GamePadButton>()
    var previousStates = [GamePadButton:Bool]()
    
    public var direction: GLfloat {
        if pressing(.Right) {
            return 1
        } else if pressing(.Left) {
            return -1
        } else {
            return 0
        }
    }
    
    public init(buttons: [KeyCode : GamePadButton]) {
        for button in buttons {
            let keyCode = key(button.0)
            buttonForKeyCode[keyCode] = button.1
            previousStates[button.1] = false
            KeyboardInputSource.instance.listeners[keyCode] = self
        }
    }
    
    public convenience init() {
        self.init(buttons: [
            .Up: .Up,
            .Down: .Down,
            .Left: .Left,
            .Right: .Right,
            .Space: .Jump,
            .Enter: .Start,
            .L: .L,
            .R: .R,
        ])
    }
    
    public func pressed(button: GamePadButton) -> Bool {
        let wasPressed = previousStates[button]!
        let pressed = buttons.contains(button)
        previousStates[button] = pressed
        
        return pressed && !wasPressed
    }
    
    public func pressing(button: GamePadButton) -> Bool {
        return buttons.contains(button)
    }
    
    func keyDown(keyCode: UInt16) {
        if let button = buttonForKeyCode[keyCode] {
            previousStates[button] = buttons.contains(button)
            buttons.insert(button)
        }
    }
    
    func keyUp(keyCode: UInt16) {
        if let button = buttonForKeyCode[keyCode] {
            buttons.remove(button)
            previousStates[button] = false
        }
    }
    
    func addListenersForKeys() {
        for keyCode in self.buttonForKeyCode.keys {
            KeyboardInputSource.instance.listeners[keyCode] = self
        }
    }
    
    func removeListenersForKeys() {
        for keyCode in self.buttonForKeyCode.keys {
            KeyboardInputSource.instance.listeners.removeValueForKey(keyCode)
        }
    }
    
    private func key(keyCode: KeyCode) -> UInt16 {
        return keyCode.rawValue
    }
    
}

/// État d'une touche.
class KeyState {
    
    var pushed = false
    var wasPushed = false
    
    func update(pushed: Bool) {
        self.wasPushed = self.pushed
        self.pushed = pushed
    }
    
    func pressed() -> Bool {
        return pushed && !wasPushed
    }
    
    func pressing() -> Bool {
        return pushed
    }
    
}
