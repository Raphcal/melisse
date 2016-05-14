//
//  Input.swift
//  MeltedIce
//
//  Created by Raphaël Calabro on 02/07/2015.
//  Copyright (c) 2015 Raphaël Calabro. All rights reserved.
//

import GLKit

// TODO: Revoir cette classe.

enum GamePadButton {
    case Up, Down, Left, Right, Jump, L, R, Start
    
    static let values = [Up, Down, Left, Right, Jump, L, R, Start]
}

protocol Controller {
    
    var direction : GLfloat { get }
    
    func pressed(button: GamePadButton) -> Bool
    func pressing(button: GamePadButton) -> Bool
    func draw()
    func updateWithTouches(touches: [Int:Point<GLfloat>])
    
}

class Input : NSObject, Controller {
    
    static let instance = Input()
    
    var touches = [Int:Point<GLfloat>]()
    var controller : Controller
    
    var direction : GLfloat {
        get {
            return controller.direction
        }
    }
    
    private var touchCount = 0
    private var previousTouchCount = 0
    
    override init() {
        #if os(iOS)
            self.controller = TouchController.instance
        #else
            self.controller = KeyboardController()
        #endif
    }
    
    func touchedScreen() -> Bool {
        return touchCount > previousTouchCount
    }
    
    func updateWithTouches(touches: [Int:Point<GLfloat>]) {
        self.touches = touches
        self.previousTouchCount = touchCount
        self.touchCount = touches.count
        
        controller.updateWithTouches(touches)
    }
    
    func pressed(button: GamePadButton) -> Bool {
        // TODO: Inverser le fonctionnement de cette méthode. Enregistrer des listeners par scène plutôt que de faire du polling.
        return controller.pressed(button)
    }
    
    func pressing(button: GamePadButton) -> Bool {
        return controller.pressing(button)
    }
    
    func draw() {
        controller.draw()
    }
    
}



