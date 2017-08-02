//
//  Random.swift
//  MeltedIce
//
//  Created by Raphaël Calabro on 06/07/2015.
//  Copyright (c) 2015 Raphaël Calabro. All rights reserved.
//

import GLKit

fileprivate let maximumValue : Int64 = 0x100000000

/// Renvoi un nombre décimal compris entre 0.0 et range - 0.0...1
public func random(_ range: GLfloat) -> GLfloat {
    return GLfloat(Double(arc4random()) / Double(maximumValue)) * range
}

/// Renvoi un nombre décimal compris entre 0.0 et range - 0.0...1
public func random(_ range: TimeInterval) -> TimeInterval {
    return TimeInterval(Double(arc4random()) / Double(maximumValue)) * range
}

/// Renvoi un entier généré pseudo aléatoirement entre 0 et range - 1
public func random(_ range: Int) -> Int {
    return Int(arc4random() % UInt32(range))
}

/// Renvoi un nombre décimal compris entre lower et upper - 0.0...1
public func random(from lower: GLfloat, to upper: GLfloat) -> GLfloat {
    return random(upper - lower) + lower
}

/// Renvoi un nombre décimal compris entre lower et upper - 0.0...1
public func random(from lower: TimeInterval, to upper: TimeInterval) -> TimeInterval {
    return random(upper - lower) + lower
}

/// Renvoi un entier généré pseudo aléatoirement entre lower et upper (inclus).
public func random(from lower: Int, to upper: Int) -> Int {
    return random(upper - lower + 1) + lower
}

/// Renvoi aléatoire l'un des éléments du tableau donné.
public func random<T>(itemFrom array: [T]) -> T {
    return array[random(array.count)]
}

public extension Array {
    /// Renvoi et supprime un élément tiré aléatoirement dans le tableau.
    mutating func removeAtRandom() -> Element {
        return self.remove(at: random(count))
    }
}
