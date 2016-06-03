//
//  MelisseViewController-iOS.swift
//  Melisse
//
//  Created by Raphaël Calabro on 02/06/2016.
//  Copyright © 2016 Raphaël Calabro. All rights reserved.
//

import Foundation
import GLKit

public class MelisseViewController : GLKViewController, MelisseViewControllerType {
    
    public let director = Director()
    
    public var viewSize: Size<GLfloat> {
        get {
            let screenBounds = UIScreen.mainScreen().bounds
            return Size(width: GLfloat(screenBounds.width), height: GLfloat(screenBounds.height))
        }
    }
    
    var context: EAGLContext?
    var touches: [UnsafePointer<Void> : Point<GLfloat>] = [:]
    
    public func createGLContext() {
        self.context = EAGLContext(API: .OpenGLES1)
        self.preferredFramesPerSecond = 60
        
        EAGLContext.setCurrentContext(context)
        
        let view = self.view as! GLKView
        view.context = self.context!
        view.drawableDepthFormat = .Format16
    }
    
    public func directorDidStart() {
        // Pas d'action.
    }
    
    public func initialScene() -> Scene {
        return EmptyScene()
    }
    
    public func update() {
        TouchController.instance.updateWith(touches)
        director.updateWith(self.timeSinceLastUpdate)
    }
    
    override public func glkView(view: GLKView, drawInRect rect: CGRect) {
        director.draw()
    }
    
    // MARK: - Gestion du multi-touch
    
    override public func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        setPointsFor(touches)
    }
    
    override public func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        setPointsFor(touches)
    }
    
    override public func touchesCancelled(touches: Set<UITouch>?, withEvent event: UIEvent?) {
        if let touches = touches {
            removePointsFor(touches)
        }
    }
    
    override public func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        removePointsFor(touches)
    }
    
    private func setPointsFor(touches: Set<UITouch>) {
        for touch in touches {
            let location = touch.locationInView(self.view)
            self.touches[unsafeAddressOf(touch)] = Point<GLfloat>(x: GLfloat(location.x), y: GLfloat(location.y))
        }
    }
    
    private func removePointsFor(touches: Set<UITouch>) {
        for touch in touches {
            self.touches.removeValueForKey(unsafeAddressOf(touch))
        }
    }
    
}
