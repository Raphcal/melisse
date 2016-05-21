//
//  Sound.swift
//  MeltedIce
//
//  Created by Raphaël Calabro on 16/11/2015.
//  Copyright © 2015 Raphaël Calabro. All rights reserved.
//

import Foundation

/// Ensemble de sons lus à la suite.
public class SoundSet {
    
    public var sound: Sound {
        get {
            let sound = sounds[current]
            current = (current + 1) % sounds.count
            return sound
        }
    }
    
    private let sounds: [Sound]
    private var current = 0
    
    public init(sounds: [Sound]) {
        self.sounds = sounds
    }
    
}