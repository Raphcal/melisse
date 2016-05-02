//
//  GamepadController.swift
//  MeltedIce
//
//  Created by Raphaël Calabro on 30/09/2015.
//  Copyright © 2015 Raphaël Calabro. All rights reserved.
//

import GameController

/// Contrôle avec une manette externe.
class GamepadController : Controller {
    
    let controller : GCController
    var direction : GLfloat {
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
    
    private var states = [GamePadButton:Bool]()
    
    init(controller: GCController) {
        self.controller = controller
    }
    
    func pressed(button: GamePadButton) -> Bool {
        let previous = states[button]
        let current = pressing(button)
        
        states[button] = current
        
        return (previous == nil || previous == false) && current
    }
    
    func pressing(button: GamePadButton) -> Bool {
        if let gamepad = controller.gamepad {
            switch button {
            case .Up:
                return gamepad.dpad.up.pressed
            case .Down:
                return gamepad.dpad.down.pressed
            case .Left:
                return gamepad.dpad.left.pressed
            case .Right:
                return gamepad.dpad.right.pressed
            case .Jump:
                return gamepad.buttonA.pressed || gamepad.buttonB.pressed
            case .L:
                return gamepad.leftShoulder.pressed
            case .R:
                return gamepad.rightShoulder.pressed
            case .Start:
                // TODO: Utiliser controller.controllerPausedHandler pour la pause
                return gamepad.buttonY.pressed
            }
        } else {
            return false
        }
    }
    
    func draw() {
        // Pas d'affichage quand une manette est branchée.
    }
    
    func updateWithTouches(touches: [Int : Spot]) {
        // Pas de prise en compte de l'écran tactile.
    }
    
}