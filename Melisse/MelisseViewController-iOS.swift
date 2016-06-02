//
//  MelisseViewController-iOS.swift
//  Melisse
//
//  Created by Raphaël Calabro on 02/06/2016.
//  Copyright © 2016 Raphaël Calabro. All rights reserved.
//

import Foundation
import GLKit

class MelisseViewController : GLKViewController, GLViewController {
    
    let director = Director()
    
    var context: EAGLContext?
    var touches: [UnsafePointer<Void> : Point<GLfloat>] = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.context = EAGLContext(API: .OpenGLES1)
        self.preferredFramesPerSecond = 60;
        
        EAGLContext.setCurrentContext(context)
        
        let view = self.view as! GLKView
        view.context = self.context!
        view.drawableDepthFormat = .Format16
        
        setupGL()
        
        let screenBounds = UIScreen.mainScreen().bounds
        View.instance.setSize(Size(width: GLfloat(screenBounds.width), height: GLfloat(screenBounds.height)))
        
        director.makeCurrent()
    }
    
    func update() {
        TouchController.instance.updateWith(touches)
        director.updateWith(self.timeSinceLastUpdate)
    }
    
    override func glkView(view: GLKView, drawInRect rect: CGRect) {
        director.draw()
    }
    
    // MARK: - Gestion du multi-touch
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        setPointsFor(touches)
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        setPointsFor(touches)
    }
    
    override func touchesCancelled(touches: Set<UITouch>?, withEvent event: UIEvent?) {
        if let touches = touches {
            removePointsFor(touches)
        }
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
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
