//
//  GamepadController.swift
//  MeltedIce
//
//  Created by Raphaël Calabro on 30/09/2015.
//  Copyright © 2015 Raphaël Calabro. All rights reserved.
//

import GameController

/// Contrôle avec une manette externe.
public class GamepadController : Controller {
    
    public let controller: GCController
    public var direction: GLfloat {
        get {
            if let xAxisValue = controller.gamepad?.dpad.xAxis.value {
                if xAxisValue < 0 {
                    return -1
                } else if xAxisValue > 0 {
                    return 1
                }
            }
            return 0
        }
    }
    
    private var states = [GamePadButton : Bool]()
    
    public init(controller: GCController) {
        self.controller = controller
    }
    
    public func pressed(_ button: GamePadButton) -> Bool {
        let previous = states[button]
        let current = pressing(button)
        
        states[button] = current
        
        return (previous == nil || previous == false) && current
    }
    
    public func pressing(_ button: GamePadButton) -> Bool {
        if let gamepad = controller.gamepad {
            switch button {
            case .up:
                return gamepad.dpad.up.isPressed
            case .down:
                return gamepad.dpad.down.isPressed
            case .left:
                return gamepad.dpad.left.isPressed
            case .right:
                return gamepad.dpad.right.isPressed
            case .jump:
                return gamepad.buttonA.isPressed || gamepad.buttonB.isPressed
            case .l:
                return gamepad.leftShoulder.isPressed
            case .r:
                return gamepad.rightShoulder.isPressed
            case .start:
                // TODO: Utiliser controller.controllerPausedHandler pour la pause
                return gamepad.buttonY.isPressed
            }
        } else {
            return false
        }
    }
    
}
