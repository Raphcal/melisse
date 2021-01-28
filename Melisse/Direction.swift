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
    private static let angles   = [GLfloat.pi, 0, GLfloat.pi * 1.5, GLfloat.pi / 2]

    /// Returns the angle in radians.
    public var angle: GLfloat {
        get {
            return Direction.angles[rawValue]
        }
    }

    /// Returns the axe of this direction (`horizontal` or `vertical`).
    public var axe: Axe {
        return Direction.axes[rawValue]
    }

    /// Returns `1` if direction is `right` or `bottom`, `-1` if direction is `left` or `up`.
    public var value: GLfloat {
        get {
            return Direction.values[rawValue]
        }
    }

    /// Returns the opposite direction. For example: `left` if the direction is `right`, `up` if the direction is `down`.
    public var reverseDirection: Direction {
        get {
            return Direction.reverses[rawValue]
        }
    }

    /// Returns 1 if this direction needs the sprite to be mirrored (`left`), 0 otherwise.
    public var mirror: GLfloat {
        get {
            return Direction.mirror[rawValue]
        }
    }

    /// Returns `true` if the direction is `left`, `false` otherwise.
    public var isMirror: Bool {
        get {
            return self == .left
        }
    }

    /// Returns `true` if the given value has the same sign has `value` (meaning it will point toward the same direction).
    public func isSameValue(_ value: GLfloat) -> Bool {
        return value * self.value >= 0
    }
    
    public func point(of rectangle: Rectangle<GLfloat>) -> Point<GLfloat> {
        switch self {
        case .left:
            return Point(x: rectangle.left, y: rectangle.center.y)
        case .right:
            return Point(x: rectangle.right, y: rectangle.center.y)
        case .up:
            return Point(x: rectangle.center.x, y: rectangle.top)
        case .down:
            return Point(x: rectangle.center.x, y: rectangle.bottom)
        }
    }
    
    public static func directionFromSprite(_ from: Sprite, toSprite to: Sprite) -> Direction {
        if from.frame.x <= to.frame.x {
            return .right
        } else {
            return .left
        }
    }
    
}
