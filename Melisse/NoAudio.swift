//
//  NoAudio.swift
//  Melisse
//
//  Created by Raphaël Calabro on 09/05/2016.
//  Copyright © 2016 Raphaël Calabro. All rights reserved.
//

import Foundation

public struct NoAudio: Audio {
    
    public func load(_ sound: Sound) {
        // Pas d'effet.
    }
    
    public func play(_ sound: Sound) {
        // Pas d'effet.
    }
    
    public func play(streamFrom URL: Foundation.URL) {
        // Pas d'effet.
    }
    
    public func playOnce(streamFrom URL: Foundation.URL, completionBlock: @escaping () -> Void) {
        completionBlock()
    }
    
    public func stopStream() {
        // Pas d'effet.
    }
    
}
