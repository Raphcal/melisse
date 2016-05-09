//
//  Fade.swift
//  Melisse
//
//  Created by Raphaël Calabro on 09/05/2016.
//  Copyright © 2016 Raphaël Calabro. All rights reserved.
//

import Foundation

public protocol Fade: Scene {
    
    var progress : Float { get set }
    var previousScene : Scene { get set }
    var nextScene : Scene { get set }
    
}
