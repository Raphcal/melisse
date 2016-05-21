//
//  Audio.swift
//  Melisse
//
//  Created by Raphaël Calabro on 04/05/2016.
//  Copyright © 2016 Raphaël Calabro. All rights reserved.
//

import Foundation

public protocol Sound {
    
    /// Nom de la ressource correspondant au son.
    var resource: String { get }
    
}

public protocol Audio {
    
    /// Charge le son donné.
    ///
    /// - parameter sound: Son à charger.
    func load(sound: Sound)
    
    func play(sound: Sound)
    
    func play(set: SoundSet)
    
    func play(streamFrom URL: NSURL)
    
    func playOnce(streamFrom URL: NSURL, completionBlock: () -> Void)
    
    func stopStream()
    
}

public extension Audio {
    
    func play(set: SoundSet) {
        play(set.sound)
    }
    
}