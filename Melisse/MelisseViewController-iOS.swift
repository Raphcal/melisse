//
//  MelisseViewController-iOS.swift
//  Melisse
//
//  Created by Raphaël Calabro on 02/06/2016.
//  Copyright © 2016 Raphaël Calabro. All rights reserved.
//

import Foundation
import GLKit

open class MelisseViewController : GLKViewController, MelisseViewControllerType {
    
    public let director = Director()
    public var updater = Director()
    
    public var viewSize: Size<GLfloat> {
        get {
            let screenBounds = UIScreen.main().bounds
            return Size(width: GLfloat(screenBounds.width), height: GLfloat(screenBounds.height))
        }
    }
    
    var context: EAGLContext?
    var touches: [UnsafePointer<Void> : Point<GLfloat>] = [:]
    
    public func createGLContext() {
        self.context = EAGLContext(api: .openGLES1)
        self.preferredFramesPerSecond = 60
        
        EAGLContext.setCurrent(context)
        
        let view = self.view as! GLKView
        view.context = self.context!
        view.drawableDepthFormat = .format16
    }
    
    public func directorDidStart() {
        updater = director
    }
    
    open func initialScene() -> Scene {
        return EmptyScene()
    }
    
    public func update() {
        TouchController.instance.updateWith(touches)
        updater.updateWith(self.timeSinceLastUpdate)
    }
    
    override public func glkView(_ view: GLKView, drawIn rect: CGRect) {
        director.draw()
    }
    
    // MARK: - Gestion du multi-touch
    
    override public func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        setPointsFor(touches)
    }
    
    override public func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        setPointsFor(touches)
    }
    
    override public func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        removePointsFor(touches)
    }
    
    override public func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        removePointsFor(touches)
    }
    
    private func setPointsFor(_ touches: Set<UITouch>) {
        for touch in touches {
            let location = touch.location(in: self.view)
            self.touches[unsafeAddress(of: touch)] = Point<GLfloat>(x: GLfloat(location.x), y: GLfloat(location.y))
        }
    }
    
    private func removePointsFor(_ touches: Set<UITouch>) {
        for touch in touches {
            self.touches.removeValue(forKey: unsafeAddress(of: touch))
        }
    }
    
}
