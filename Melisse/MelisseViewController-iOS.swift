//
//  MelisseViewController-iOS.swift
//  Melisse
//
//  Created by Raphaël Calabro on 02/06/2016.
//  Copyright © 2016 Raphaël Calabro. All rights reserved.
//

import Foundation
import GLKit

open class MelisseViewController : GLKViewController, GLKViewControllerDelegate, MelisseViewControllerType {
    
    public let director = Director()
    public var updater = Director()
    
    public var viewSize: Size<GLfloat> {
        get {
            let screenBounds = UIScreen.main.bounds
            return Size(width: GLfloat(screenBounds.width), height: GLfloat(screenBounds.height))
        }
    }
    
    var context: EAGLContext?
    var touches: [UnsafeRawPointer : Point<GLfloat>] = [:]
    
    public func createGLContext() {
        self.delegate = self
        self.preferredFramesPerSecond = 60
        self.context = EAGLContext(api: .openGLES1)
        
        guard let context = context, EAGLContext.setCurrent(context) else {
            NSLog("Failed to create ES context")
            return
        }
        
        let view = self.view as! GLKView
        view.context = context
        view.drawableDepthFormat = .format16
    }
    
    public func directorDidStart() {
        director.viewController = self
        updater = director
    }
    
    open func initialScene() -> Scene {
        return EmptyScene()
    }
    
    public func glkViewControllerUpdate(_ controller: GLKViewController) {
        TouchController.instance.updateWith(touches)
        updater.updateWith(self.timeSinceLastUpdate)
    }
    
    open override func glkView(_ view: GLKView, drawIn rect: CGRect) {
        director.draw()
    }
    
    // MARK: - Gestion du multi-touch
    
    override open func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        setPointsFor(touches)
    }
    
    override open func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        setPointsFor(touches)
    }
    
    override open func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        removePointsFor(touches)
    }
    
    override open func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        removePointsFor(touches)
    }
    
    private func setPointsFor(_ touches: Set<UITouch>) {
        for touch in touches {
            let location = touch.location(in: self.view)
            self.touches[Unmanaged.passUnretained(touch).toOpaque()] = Point<GLfloat>(x: GLfloat(location.x), y: GLfloat(location.y))
        }
    }
    
    private func removePointsFor(_ touches: Set<UITouch>) {
        for touch in touches {
            self.touches.removeValue(forKey: Unmanaged.passUnretained(touch).toOpaque())
        }
    }
    
}
