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
    
    static let instance = Director()
    
    static let fadeDuration: NSTimeInterval = 0.5
    static let fullProgress: Float = 1
    static let halfProgress: Float = 0.5
    
    var audio: Audio = NoAudio()
    
    var scene: Scene = EmptyScene()
    var nextScene: Scene?
    
    var fade: Fade = NoFade()
    
    public func startWith(scene: Scene) {
        View.instance.applyZoom()
        
        self.fade = FadeScene()
        self.scene = scene
        scene.load()
        scene.willAppear()
    }
    
    public func restart() {
        scene.reload()
    }
    
    public func updateWithTimeSinceLastUpdate(timeSinceLastUpdate: NSTimeInterval) {
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
