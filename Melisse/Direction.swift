//
//  Direction.swift
//  MeltedIce
//
//  Created by Raphaël Calabro on 29/06/2015.
//  Copyright (c) 2015 Raphaël Calabro. All rights reserved.
//

import GLKit

public enum Direction : Int {
    
    case left = 0, right, up, down
    
    private static let values: [GLfloat] = [-1, 1, -1, 1]
    private static let mirror: [GLfloat] = [1, 0, 0, 0]
    private static let reverses: [Direction] = [.right, .left, .down, .up]
    private static let axes: [Axe] = [.horizontal, .horizontal, .vertical, .vertical]
    private static let angles: [GLfloat] = [GLfloat(M_PI), 0, GLfloat(M_PI + M_PI_2), GLfloat(M_PI_2)]
    
    public var angle: GLfloat {
        get {
            return Direction.angles[rawValue]
        }
    }
    
    public var axe: Axe {
        return Direction.axes[rawValue]
    }
    
    public var value: GLfloat {
        get {
            return Direction.values[rawValue]
        }
    }
    
    public var reverseDirection: Direction {
        get {
            return Direction.reverses[rawValue]
        }
    }
    
    public var mirror: GLfloat {
        get {
            return Direction.mirror[rawValue]
        }
    }
    
    public var isMirror: Bool {
        get {
            return self == .left
        }
    }
    
    public func isSameValue(_ value: GLfloat) -> Bool {
        return value * self.value >= 0
    }
    
    public static func directionFromSprite(_ from: Sprite, toSprite to: Sprite) -> Direction {
        if from.frame.x <= to.frame.x {
            return .right
        } else {
            return .left
        }
    }
    
}
