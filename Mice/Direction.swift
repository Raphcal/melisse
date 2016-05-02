//
//  Direction.swift
//  MeltedIce
//
//  Created by Raphaël Calabro on 29/06/2015.
//  Copyright (c) 2015 Raphaël Calabro. All rights reserved.
//

import GLKit

enum Direction : Int {
    case Left = 0, Right, Up, Down
    
    private static let values : [GLfloat] = [-1, 1, -1, 1]
    private static let mirror : [GLfloat] = [1, 0, 0, 0]
    private static let reverses : [Direction] = [.Right, .Left, .Down, .Up]
    private static let axes : [Axe] = [.Horizontal, .Horizontal, .Vertical, .Vertical]
    private static let angles : [GLfloat] = [GLfloat(M_PI), 0, GLfloat(M_PI + M_PI_2), GLfloat(M_PI_2)]
    
    var angle : GLfloat {
        get {
            return Direction.angles[rawValue]
        }
    }
    
    var axe : Axe {
        return Direction.axes[rawValue]
    }
    
    var value : GLfloat {
        get {
            return Direction.values[rawValue]
        }
    }
    
    var reverseDirection : Direction {
        get {
            return Direction.reverses[rawValue]
        }
    }
    
    var mirror : GLfloat {
        get {
            return Direction.mirror[rawValue]
        }
    }
    
    var isMirror : Bool {
        get {
            return self == .Left
        }
    }
    
    func isSameValue(value: GLfloat) -> Bool {
        return value * self.value >= 0
    }
    
    static func directionFromSprite(from: Sprite, toSprite to: Sprite) -> Direction {
        if from.x <= to.x {
            return .Right
        } else {
            return .Left
        }
    }
}

enum Axe {
    case Horizontal, Vertical
    
    static let count = 2
}