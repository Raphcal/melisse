//
//  Random.swift
//  MeltedIce
//
//  Created by Raphaël Calabro on 06/07/2015.
//  Copyright (c) 2015 Raphaël Calabro. All rights reserved.
//

import GLKit

class Random {
	
	let maximumValue : Int64 = 0x100000000
	
    /// Renvoi un nombre décimal compris entre 0.0 et range - 0.0...1
	func next(range: GLfloat) -> GLfloat {
		return GLfloat(Double(arc4random()) / Double(maximumValue)) * range
	}
	
    /// Renvoi un nombre décimal compris entre 0.0 et range - 0.0...1
	func next(range: NSTimeInterval) -> NSTimeInterval {
		return NSTimeInterval(Double(arc4random()) / Double(maximumValue)) * range
	}
    
    /// Renvoi un entier généré pseudo aléatoirement entre 0 et range - 1
    func next(range: Int) -> Int {
        return Int(arc4random() % UInt32(range))
    }
	
}