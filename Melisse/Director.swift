//
//  Director.swift
//  MeltedIce
//
//  Created by Raphaël Calabro on 30/06/2015.
//  Copyright (c) 2015 Raphaël Calabro. All rights reserved.
//

import Foundation
#if os(iOS)
import GLKit
#else
import OpenGL.GL
#endif

public class Director {
    
    static public weak var instance: Director?
    
    static let fadeDuration: NSTimeInterval = 0.5
    static let fullProgress: Float = 1
    static let halfProgress: Float = 0.5
    
    public var audio: Audio = NoAudio()
    
    public var scene: Scene = EmptyScene()
    public var nextScene: Scene?
    
    public var fade: Fade = NoFade()
    
    public init() {
        // Public initializer.
    }
    
    public func makeCurrent() {
        Director.instance = self
    }
    
    public func startWith(scene: Scene) {
        View.instance.applyZoom()
        
        self.scene = scene
        scene.load()
        scene.willAppear()
    }
    
    public func restart() {
        scene.reload()
    }
    
    public func updateWith(timeSinceLastUpdate: NSTimeInterval) {
        if var nextScene = self.nextScene {
            if !(self.scene is Fade) {
                audio.stopStream()
                
                // TODO: Voir comment faire le unload ailleurs.
                nextScene.load()
                
                fade.previousScene = scene
                fade.nextScene = nextScene
                fade.load()
                
                nextScene = fade
            } else {
                fade.previousScene.unload()
                fade.previousScene = EmptyScene()
                fade.nextScene = EmptyScene()
            }

            self.scene = nextScene
            self.nextScene = nil
            
        } else {
            scene.updateWith(timeSinceLastUpdate)
        }
    }
    
    public func draw() {
        let top = View.instance.height
        Draws.clearWith(scene.backgroundColor)
        glTranslatef(0, top, 0)
        scene.draw()
        glTranslatef(0, -top, 0)
    }
    
}
