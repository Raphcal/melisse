//
//  NoAudio.swift
//  Melisse
//
//  Created by Raphaël Calabro on 09/05/2016.
//  Copyright © 2016 Raphaël Calabro. All rights reserved.
//

import Foundation

public struct NoAudio: Audio {
    
    public func load(sound: Sound) {
        // Pas d'effet.
    }
    
    public func play(sound: Sound) {
        // Pas d'effet.
    }
    
    public func play(streamFrom URL: NSURL) {
        // Pas d'effet.
    }
    
    public func playOnce(streamFrom URL: NSURL, completionBlock: () -> Void) {
        completionBlock()
    }
    
    public func stopStream() {
        // Pas d'effet.
    }
    
}
