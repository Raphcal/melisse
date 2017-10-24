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
    
    var mouseLocation = Point<GLfloat>()
    var isMouseDown = false
    
    public func createGLContext() {
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
    
    open override func mouseDown(with event: NSEvent) {
        isMouseDown = true
    }
    
    open override func mouseUp(with event: NSEvent) {
        isMouseDown = false
    }
    
    open override func mouseMoved(with event: NSEvent) {
        let mouseEvent = NSEvent.mouseLocation
        mouseLocation = Point<GLfloat>(x: GLfloat(mouseEvent.x), y: GLfloat(mouseEvent.y))
    }
    
}

public class GameView: NSOpenGLView {
    
    var controller: MelisseViewControllerType?
    var displayLink: CVDisplayLink?
    
    var previousTime: TimeInterval?
    
    var target: GameView?
    
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
        openGLContext?.makeCurrentContext()
        CGLLockContext(openGLContext!.cglContextObj!)
        
        controller?.updater.updateWith(timeSinceLastUpdate(outputTime))
        controller?.director.draw()
        
        CGLFlushDrawable(openGLContext!.cglContextObj!);
        CGLUnlockContext(openGLContext!.cglContextObj!);
        
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
    
}
