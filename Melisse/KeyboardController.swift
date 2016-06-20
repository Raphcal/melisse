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
    case r = 15
    case enter = 36
    case l = 37
    case space = 49
    case left = 123
    case right = 124
    case down = 125
    case up = 126
    
    case a = 12
    case c = 8
    case d = 2
    case f = 3
    case q = 0
    case v = 9
    case w = 6
    case x = 7
}

/// Reçoit les événements du clavier et les dispatch vers le bon contrôleur.
public class KeyboardInputSource {

    static public let instance = KeyboardInputSource()

    public var listeners = [UInt16 : KeyboardController]()
    
    public func keyDown(_ keyCode: UInt16) {
        listeners[keyCode]?.keyDown(keyCode)
    }
    
    public func keyUp(_ keyCode: UInt16) {
        listeners[keyCode]?.keyUp(keyCode)
    }

}

/// Contrôle au clavier.
public class KeyboardController : Controller {
    
    var buttonForKeyCode = [UInt16:GamePadButton]()
    
    var buttons = Set<GamePadButton>()
    var previousStates = [GamePadButton:Bool]()
    
    public var direction: GLfloat {
        if pressing(.right) {
            return 1
        } else if pressing(.left) {
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
            .up: .up,
            .down: .down,
            .left: .left,
            .right: .right,
            .space: .jump,
            .enter: .start,
            .l: .l,
            .r: .r,
        ])
    }
    
    public func pressed(_ button: GamePadButton) -> Bool {
        let wasPressed = previousStates[button]!
        let pressed = buttons.contains(button)
        previousStates[button] = pressed
        
        return pressed && !wasPressed
    }
    
    public func pressing(_ button: GamePadButton) -> Bool {
        return buttons.contains(button)
    }
    
    func keyDown(_ keyCode: UInt16) {
        if let button = buttonForKeyCode[keyCode] {
            previousStates[button] = buttons.contains(button)
            buttons.insert(button)
        }
    }
    
    func keyUp(_ keyCode: UInt16) {
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
            KeyboardInputSource.instance.listeners.removeValue(forKey: keyCode)
        }
    }
    
    private func key(_ keyCode: KeyCode) -> UInt16 {
        return keyCode.rawValue
    }
    
}

/// État d'une touche.
class KeyState {
    
    var pushed = false
    var wasPushed = false
    
    func update(_ pushed: Bool) {
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
