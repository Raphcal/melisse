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

class MelisseViewController : NSViewController, GLViewController {
    
    @IBOutlet weak var gameView: GameView?
    let director = Director()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let context = gameView!.openGLContext {
            context.makeCurrentContext()
        } else {
            NSLog("Erreur de chargement du contexte OpenGL")
        }
        
        View.instance.setSize(Size(width: GLfloat(gameView!.bounds.width), height: GLfloat(gameView!.bounds.height)))
        
        setupGL()
        
        gameView!.director = director
        director.makeCurrent()
        
        gameView!.initializeDisplayLink()
    }
    
}

class GameView: NSOpenGLView {
    
    var director: Director?
    var displayLink: CVDisplayLink?
    
    var previousTime: NSTimeInterval?
    
    var target: GameView?
    
    override func prepareOpenGL() {
        super.prepareOpenGL()
    }
    
    func initializeDisplayLink() {
        var swapInt: GLint = 1
        openGLContext?.setValues(&swapInt, forParameter: NSOpenGLContextParameter.GLCPSwapInterval)
        
        CVDisplayLinkCreateWithActiveCGDisplays(&displayLink)
        
        target = self
        CVDisplayLinkSetOutputCallback(displayLink!, { (displayLink: CVDisplayLink, now: UnsafePointer<CVTimeStamp>, outputTime: UnsafePointer<CVTimeStamp>, flagsIn: CVOptionFlags, flagsOut: UnsafeMutablePointer<CVOptionFlags>, displayLinkContext: UnsafeMutablePointer<Void>) -> CVReturn in
            let gameViewRef = UnsafeMutablePointer<GameView>(displayLinkContext)
            return gameViewRef[0].frameForTime(outputTime[0])
            }, &target)
        
        CVDisplayLinkSetCurrentCGDisplayFromOpenGLContext(displayLink!, openGLContext!.CGLContextObj, pixelFormat!.CGLPixelFormatObj)
        
        CVDisplayLinkStart(displayLink!)
    }
    
    func frameForTime(outputTime: CVTimeStamp) -> CVReturn {
        openGLContext?.makeCurrentContext()
        
        CGLLockContext(openGLContext!.CGLContextObj)
        
        director?.updateWith(timeSinceLastUpdate(outputTime))
        director?.draw()
        
        CGLFlushDrawable(openGLContext!.CGLContextObj);
        CGLUnlockContext(openGLContext!.CGLContextObj);
        
        return kCVReturnSuccess
    }
    
    func timeSinceLastUpdate(outputTime: CVTimeStamp) -> NSTimeInterval {
        let now = NSTimeInterval(outputTime.videoTime) / NSTimeInterval(outputTime.videoTimeScale)
        let before = self.previousTime
        
        self.previousTime = now
        
        if before != nil {
            return now - before!
        } else {
            return 0
        }
    }
    
}
