//
//  MelisseViewController-Mac.swift
//  Melisse
//
//  Created by Raphaël Calabro on 02/06/2016.
//  Copyright © 2016 Raphaël Calabro. All rights reserved.
//

import Foundation
import Cocoa
import OpenGL.GL

open class MelisseViewController : NSViewController, MelisseViewControllerType {
    
    @IBOutlet weak public var gameView: GameView?
    public let director = Director()
    public var updater = Director()
    
    public var viewSize: Size<GLfloat> {
        get {
            return Size(width: GLfloat(gameView!.bounds.width), height: GLfloat(gameView!.bounds.height))
        }
    }
    
    public func createGLContext() {
        UIScreen.main.bounds = gameView!.frame
        guard let context = gameView?.openGLContext else {
            NSLog("Erreur de chargement du contexte OpenGL")
            return
        }
        context.makeCurrentContext()
        gameView!.controller = self
    }
    
    public func directorDidStart() {
        updater = director
        gameView!.initializeDisplayLink()
    }
    
    open func initialScene() -> Scene {
        return EmptyScene()
    }
    
}

public class GameView: NSOpenGLView {
    
    var controller: MelisseViewControllerType?
    var displayLink: CVDisplayLink?
    
    var previousTime: TimeInterval?
    
    var target: GameView?
    
    var isMouseDown = false
    
    func initializeDisplayLink() {
        var swapInt: GLint = 1
        openGLContext?.setValues(&swapInt, for: NSOpenGLContext.Parameter.swapInterval)
        prepareOpenGL()
        
        CVDisplayLinkCreateWithActiveCGDisplays(&displayLink)
        
        target = self
        CVDisplayLinkSetOutputCallback(displayLink!, { (displayLink, now, outputTime, flagsIn, flagsOut, displayLinkContext) -> CVReturn in
            if let gameViewRef = displayLinkContext?.assumingMemoryBound(to: GameView.self) {
                return gameViewRef[0].frameForTime(outputTime[0])
            } else {
                return kCVReturnError
            }
        }, &target)
        
        CVDisplayLinkSetCurrentCGDisplayFromOpenGLContext(displayLink!, openGLContext!.cglContextObj!, pixelFormat!.cglPixelFormatObj!)
        
        CVDisplayLinkStart(displayLink!)
    }
    
    func frameForTime(_ outputTime: CVTimeStamp) -> CVReturn {
        updateMouseLocation()
        
        if let controller = controller {
            controller.updater.updateWith(timeSinceLastUpdate(outputTime))
            
            DispatchQueue.main.sync {
                openGLContext?.makeCurrentContext()
                CGLLockContext(openGLContext!.cglContextObj!)
                controller.director.draw()
                CGLFlushDrawable(openGLContext!.cglContextObj!)
                CGLUnlockContext(openGLContext!.cglContextObj!)
            }
        }
        
        return kCVReturnSuccess
    }
    
    func timeSinceLastUpdate(_ outputTime: CVTimeStamp) -> TimeInterval {
        let now = TimeInterval(outputTime.videoTime) / TimeInterval(outputTime.videoTimeScale)
        let before = self.previousTime
        
        self.previousTime = now
        
        if before != nil {
            return now - before!
        } else {
            return 0
        }
    }
    
    open override func mouseDown(with event: NSEvent) {
        isMouseDown = true
    }
    
    open override func mouseUp(with event: NSEvent) {
        isMouseDown = false
    }
    
    private func updateMouseLocation() {
        DispatchQueue.main.async {
            let window = self.window!
            let location = window.mouseLocationOutsideOfEventStream
            
            MouseController.instance.update(mouseLocation: Point<GLfloat>(x: GLfloat(location.x), y: GLfloat(window.frame.height - location.y)), isMouseDown: self.isMouseDown)
        }
    }
    
}
