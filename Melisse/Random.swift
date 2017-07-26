//
//  Random.swift
//  MeltedIce
//
//  Created by Raphaël Calabro on 06/07/2015.
//  Copyright (c) 2015 Raphaël Calabro. All rights reserved.
//

import GLKit

public struct Random {
	
	let maximumValue : Int64 = 0x100000000
	
    public init() {
        // Pas d'initialisation.
    }
    
    /// Renvoi un nombre décimal compris entre 0.0 et range - 0.0...1
	public func next(_ range: GLfloat) -> GLfloat {
		return GLfloat(Double(arc4random()) / Double(maximumValue)) * range
	}
	
    /// Renvoi un nombre décimal compris entre 0.0 et range - 0.0...1
	public func next(_ range: TimeInterval) -> TimeInterval {
		return TimeInterval(Double(arc4random()) / Double(maximumValue)) * range
	}
    
    /// Renvoi un entier généré pseudo aléatoirement entre 0 et range - 1
    public func next(_ range: Int) -> Int {
        return Int(arc4random() % UInt32(range))
    }
    
    /// Renvoi un nombre décimal compris entre lower et upper - 0.0...1
    public func next(between lower: GLfloat, and upper: GLfloat) -> GLfloat {
        return next(upper - lower) + lower
    }
    
    /// Renvoi un nombre décimal compris entre lower et upper - 0.0...1
    public func next(between lower: TimeInterval, and upper: TimeInterval) -> TimeInterval {
        return next(upper - lower) + lower
    }
    
    /// Renvoi un entier généré pseudo aléatoirement entre lower et upper
    public func next(between lower: Int, and upper: Int) -> Int {
        return next(upper - lower + 1) + lower
    }
	
}
