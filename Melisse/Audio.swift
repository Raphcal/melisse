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
    
    /// Nom de la ressource correspondant au son.
    var ext: String? { get }
    
    /// Index du son.
    var rawValue: Int { get }
    
}

public protocol Audio {
    
    /// Charge le son donné.
    ///
    /// - parameter sound: Son à charger.
    func load(_ sound: Sound)
    
    func play(_ sound: Sound)
    
    func play(_ set: SoundSet)
    
    func play(streamFrom URL: URL)
    
    func playOnce(streamFrom URL: URL, completionBlock: @escaping () -> Void)
    
    func stopStream()
    
}

public extension Audio {
    
    func play(_ set: SoundSet) {
        play(set.sound)
    }
    
}
