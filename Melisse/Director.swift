//
//  Director.swift
//  MeltedIce
//
//  Created by Raphaël Calabro on 30/06/2015.
//  Copyright (c) 2015 Raphaël Calabro. All rights reserved.
//

import GLKit

class Director : NSObject {
    
    static let instance = Director()
    
    static let fadeDuration : NSTimeInterval = 0.5
    static let fullProgress : Float = 1
    static let halfProgress : Float = 0.5
    
    static let audio : Audio = OpenALAudio()
    
    var scene : Scene = EmptyScene()
    var nextScene : Scene?
    
    var fade : Fade = NoFade()
    
    let gameCenter = GameCenter()
    
    func start() {
        View.instance.applyZoom()
        
        // gameCenter.authenticate()
        
        self.fade = FadeScene()
        self.scene = TitleScene()
        scene.load?()
        scene.willAppear?()
    }
    
    func restart() {
        scene.reload?()
    }
    
    func updateWithTimeSinceLastUpdate(timeSinceLastUpdate: NSTimeInterval) {
        if var nextScene = self.nextScene {
            if !(self.scene is Fade) {
                Director.audio.stopStream()
                
                // TODO: Voir comment faire le unload ailleurs.
                nextScene.load?()
                
                fade.previousScene = scene
                fade.nextScene = nextScene
                fade.load?()
                
                nextScene = fade
            } else {
                fade.previousScene.unload?()
                fade.previousScene = EmptyScene()
                fade.nextScene = EmptyScene()
            }

            self.scene = nextScene
            self.nextScene = nil
            
        } else {
            scene.updateWithTimeSinceLastUpdate(timeSinceLastUpdate)
        }
    }
    
    func draw() {
        // TODO : Faire la translation qu'une fois.
        let top = View.instance.height
        Draws.clearWithColor(scene.backgroundColor)
        glTranslatef(0, top, 0)
        scene.draw()
        glTranslatef(0, -top, 0)
    }
    
}

class NoAudio : NSObject, Audio {
    
    func loadSound(sound: Sound, fromResource name: String) {
        // Pas de chargement.
    }
    
    func playSound(sound: Sound) {
        // Pas de lecture.
    }
    
    func playStreamAtURL(url: NSURL) {
        // Pas de lecture.
    }
    
    func playOnceStreamAtURL(url: NSURL, withCompletionBlock block: () -> Void) {
        // Pas de lecture.
    }
    
    func stopStream() {
        // Pas de lecture.
    }

}