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

public class MelisseViewController : NSViewController, MelisseViewControllerType {
    
    @IBOutlet weak public var gameView: GameView?
    public let director = Director()
    
    public var viewSize: Size<GLfloat> {
        get {
            return Size(width: GLfloat(gameView!.bounds.width), height: GLfloat(gameView!.bounds.height))
        }
    }
    
    public func createGLContext() {
        if let context = gameView!.openGLContext {
            context.makeCurrentContext()
        } else {
            NSLog("Erreur de chargement du contexte OpenGL")
        }
        gameView!.director = director
    }
    
    public func directorDidStart() {
        gameView!.initializeDisplayLink()
    }
    
    public func initialScene() -> Scene {
        return EmptyScene()
    }
    
}

public class GameView: NSOpenGLView {
    
    var director: Director?
    var displayLink: CVDisplayLink?
    
    var previousTime: TimeInterval?
    
    var target: GameView?
    
    func initializeDisplayLink() {
        var swapInt: GLint = 1
        openGLContext?.setValues(&swapInt, for: NSOpenGLContextParameter.swapInterval)
        
        CVDisplayLinkCreateWithActiveCGDisplays(&displayLink)
        
        target = self
        CVDisplayLinkSetOutputCallback(displayLink!, { (displayLink, now, outputTime, flagsIn, flagsOut, displayLinkContext) -> CVReturn in
            let gameViewRef = UnsafeMutablePointer<GameView>(displayLinkContext!)
            return gameViewRef[0].frameForTime(outputTime[0])
            }, &target)
        
        CVDisplayLinkSetCurrentCGDisplayFromOpenGLContext(displayLink!, openGLContext!.cglContextObj!, pixelFormat!.cglPixelFormatObj!)
        
        CVDisplayLinkStart(displayLink!)
    }
    
    func frameForTime(_ outputTime: CVTimeStamp) -> CVReturn {
        openGLContext?.makeCurrentContext()
        
        CGLLockContext(openGLContext!.cglContextObj!)
        
        director?.updateWith(timeSinceLastUpdate(outputTime))
        director?.draw()
        
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
