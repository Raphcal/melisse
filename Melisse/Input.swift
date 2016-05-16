//
//  Input.swift
//  MeltedIce
//
//  Created by Raphaël Calabro on 02/07/2015.
//  Copyright (c) 2015 Raphaël Calabro. All rights reserved.
//

import GLKit

// TODO: Revoir cette classe.

public class Input : Controller {
    
    static public let instance = Input()
    
    public var touches: [UnsafePointer<Void> : Point<GLfloat>] = [:]
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
    
    func touchedScreen() -> Bool {
        return touchCount > previousTouchCount
    }
    
    func updateWith(touches: [UnsafePointer<Void> : Point<GLfloat>]) {
        self.touches = touches
        self.previousTouchCount = touchCount
        self.touchCount = touches.count
        
        (controller as? TouchController)?.updateWith(touches)
    }
    
    public func pressed(button: GamePadButton) -> Bool {
        // TODO: Inverser le fonctionnement de cette méthode. Enregistrer des listeners par scène plutôt que de faire du polling.
        return controller.pressed(button)
    }
    
    public func pressing(button: GamePadButton) -> Bool {
        return controller.pressing(button)
    }
    
    public func draw() {
        controller.draw()
    }
    
}



