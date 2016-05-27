//
//  Input.swift
//  MeltedIce
//
//  Created by Raphaël Calabro on 02/07/2015.
//  Copyright (c) 2015 Raphaël Calabro. All rights reserved.
//

import GLKit

public class Input : Controller {
    
    static public let instance = Input()
    
    public var controller: Controller
    
    public var direction: GLfloat {
        get {
            return controller.direction
        }
    }
    
    private var touchCount = 0
    private var previousTouchCount = 0
    
    public init() {
        #if os(iOS)
            self.controller = TouchController.instance
        #else
            self.controller = KeyboardController()
        #endif
    }
    
    public func touchedScreen() -> Bool {
        #if os(iOS)
            return TouchController.instance.touchedScreen()
        #else
            return false
        #endif
    }
    
    public func pressed(button: GamePadButton) -> Bool {
        // TODO: Inverser le fonctionnement de cette méthode. Enregistrer des listeners par scène plutôt que de faire du polling.
        return controller.pressed(button)
    }
    
    public func pressing(button: GamePadButton) -> Bool {
        return controller.pressing(button)
    }
    
}



