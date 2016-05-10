//
//  FadeScene.swift
//  MeltedIce
//
//  Created by Raphaël Calabro on 02/09/2015.
//  Copyright (c) 2015 Raphaël Calabro. All rights reserved.
//

import GLKit

class FadeScene : Fade {
    
    let halfProgress: GLfloat = 0.5
    let fullProgress: GLfloat = 1
    
    var backgroundColor: Color<GLfloat> = Color()
    
    var previousScene: Scene = EmptyScene()
    var nextScene: Scene = EmptyScene()
    
    var firstScene: Bool = true
    
    var progress: GLfloat = 0
    var time : NSTimeInterval = 0
    let duration : NSTimeInterval = 1
    
    let plane = Plane(capacity: 1)
    var mask: ColoredQuadrilateral
    
    init() {
        self.mask = plane.coloredQuadrilateral()
        mask.quadrilateral = Quadrilateral(rectangle: Rectangle(left: 0, top: 0, width: View.instance.width, height: View.instance.height))
    }
    
    func load() {
        self.time = 0
        self.firstScene = true
        self.backgroundColor = previousScene.backgroundColor
    }
    
    func updateWith(timeSinceLastUpdate: NSTimeInterval) {
        self.time += timeSinceLastUpdate
        self.progress = min(GLfloat(time / duration), fullProgress)
        
        if !firstScene && progress >= fullProgress {
            Director.instance.nextScene = nextScene
            
        } else if firstScene && progress >= halfProgress {
            firstScene = false
            // TODO: Charger ici la seconde scène ?
            nextScene.willAppear()
            nextScene.updateWith(0)
            self.backgroundColor = nextScene.backgroundColor
        }
    }
    
    func draw() {
        let darkness : GLfloat
        if firstScene {
            darkness = min(progress, halfProgress) * 2
            previousScene.draw()
        } else {
            darkness = max(1 - (progress - halfProgress) * 2, 0)
            nextScene.draw()
        }
        
        mask.color = Color(white: 0, alpha: GLubyte(darkness * 255))
        plane.draw()
    }
    
}