//
//  MouseController.swift
//  Melisse-Mac
//
//  Created by Raphaël Calabro on 24/10/2017.
//  Copyright © 2017 Raphaël Calabro. All rights reserved.
//

import Foundation
import AppKit
import GLKit

public class MouseController : Controller {
    
    static public let instance = MouseController()
    
    public var direction: GLfloat = 0
    
    public func pressed(_ button: GamePadButton) -> Bool {
        return button == GamePadButton.jump && !wasMouseDown && isMouseDown
    }
    
    public func pressing(_ button: GamePadButton) -> Bool {
        return button == GamePadButton.jump && isMouseDown
    }
    
    public var mouseLocation = Point<GLfloat>()
    public var isMouseDown = false
    public var wasMouseDown = false
    
    public func update(mouseLocation: Point<GLfloat>, isMouseDown: Bool) {
        self.mouseLocation = mouseLocation
        self.wasMouseDown = self.isMouseDown
        self.isMouseDown = isMouseDown
    }
}

public typealias TouchController = MouseController

public extension TouchController {
    
    var touches: [UnsafeRawPointer : Point<GLfloat>] {
        if isMouseDown {
            var touches: [UnsafeRawPointer : Point<GLfloat>] = [:]
            touches[Unmanaged.passUnretained(self).toOpaque()] = mouseLocation
            return touches
        } else {
            return [:]
        }
    }
    
}
