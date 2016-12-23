//
//  Operation.swift
//  MeltedIce
//
//  Created by Raphaël Calabro on 30/06/2015.
//  Copyright (c) 2015 Raphaël Calabro. All rights reserved.
//

import GLKit

enum ByteCode : UInt8 {
    case add = 0x2b
    case substract = 0x2d
    case multiply = 0x2a
    case divide = 0x2f
    case pow = 0x5e
    case negative = 0x6e
    case constant = 0x43
    case x = 0x78
    case pi = 0x70
    case e = 0x65
    case minimum = 0x6d
    case maximum = 0x4d
    case cosinus = 0x63
    case sinus = 0x73
    case squareRoot = 0x53
    case zoom = 0x7a
    case spriteVariable = 0x76
    case spriteDirection = 0x64
    case spriteHitboxTop = 0x68
}

public struct Operation {
    
    public static func execute(_ operation: [UInt8]?, x: GLfloat, or defaultValue: GLfloat = 0) -> GLfloat {
        if let bytes = operation {
            var stack = execute(bytes, x: x, sprite: nil)
            return stack.removeLast()
        } else {
            return defaultValue
        }
    }
    
    public static func execute(_ operation: [UInt8]?, sprite: Sprite) {
        if let bytes = operation {
            _ = execute(bytes, x: 0, sprite: sprite)
        }
    }
    
    private static func execute(_ bytes: [UInt8], x: GLfloat, sprite: Sprite?) -> [GLfloat] {
        var index = 0
        var stack = [GLfloat]()
        stack.reserveCapacity(bytes.count)
        
        while index < bytes.count {
            if let b = ByteCode(rawValue: bytes[index]) {
                index += 1
                switch b  {
                case .add:
                    stack.append(stack.removeLast() + stack.removeLast())
                    
                case .substract:
                    let substracted = stack.removeLast()
                    stack.append(stack.removeLast() - substracted)
                    
                case .multiply:
                    stack.append(stack.removeLast() * stack.removeLast())
                    
                case .divide:
                    let divisor = stack.removeLast()
                    stack.append(stack.removeLast() / divisor)
                    
                case .pow:
                    let exponent = stack.removeLast()
                    stack.append(pow(stack.removeLast(), exponent))
                    
                case .negative:
                    stack.append(-stack.removeLast())
                    
                case .constant:
                    let value = Streams.readFloatFromByteArray(bytes, atIndex: index)
                    stack.append(value.float)
                    index += value.readCount
                    
                case .x:
                    stack.append(x)
                    
                case .pi:
                    stack.append(GLfloat(M_PI))
                    
                case .e:
                    stack.append(GLfloat(M_E))
                    
                case .minimum:
                    stack.append(min(stack.removeLast(), stack.removeLast()))
                    
                case .maximum:
                    stack.append(max(stack.removeLast(), stack.removeLast()))
                    
                case .cosinus:
                    stack.append(cos(stack.removeLast()))
                    
                case .sinus:
                    stack.append(sin(stack.removeLast()))
                    
                case .squareRoot:
                    let last = stack.removeLast()
                    if last >= 0 {
                        stack.append(sqrt(last))
                    } else {
                        stack.append(-1)
                    }
                     
                case .zoom:
                    break
                    
                case .spriteVariable:
                    let value = Streams.readStringFromByteArray(bytes, atIndex: index)
                    sprite!.variables[value.string] = stack.removeLast()
                    index += value.readCount
                    
                case .spriteDirection:
                    sprite!.direction = Direction(rawValue: Int(stack.removeLast()))!
                    
                case .spriteHitboxTop:
                    /*
                    let hitboxTop = stack.removeLast()
                    
                    if let hitbox = sprite!.hitbox as? SimpleHitbox {
                        hitbox.height -= hitboxTop
                        hitbox.offset.y = hitboxTop
                    }
                     */
                    print("SpriteHitboxTop is not supported yet.")
                }
            }
        }
        
        return stack
    }
    
    public static func description(_ operation: [UInt8]?) -> String {
        if let bytes = operation {
            var index = 0
            var stack = [String]()
            
            while index < bytes.count {
                if let b = ByteCode(rawValue: bytes[index]) {
                    index += 1
                    switch b  {
                    case .add:
                        let added = stack.removeLast()
                        stack.append("\(stack.removeLast()) + \(added)")
                        
                    case .substract:
                        let substracted = stack.removeLast()
                        stack.append("\(stack.removeLast()) - \(substracted)")
                        
                    case .multiply:
                        let multiplicated = stack.removeLast()
                        stack.append("\(stack.removeLast()) * \(multiplicated)")
                        
                    case .divide:
                        let divisor = stack.removeLast()
                        stack.append("\(stack.removeLast()) / \(divisor)")
                        
                    case .pow:
                        let exponent = stack.removeLast()
                        stack.append("\(stack.removeLast()) ^ \(exponent)")
                        
                    case .negative:
                        stack.append("-\(stack.removeLast())")
                        
                    case .constant:
                        let value = Streams.readFloatFromByteArray(bytes, atIndex: index)
                        stack.append("\(value.float)")
                        index += value.readCount
                        
                    case .x:
                        stack.append("x")
                        
                    case .pi:
                        stack.append("π")
                        
                    case .e:
                        stack.append("e")
                        
                    case .minimum:
                        let minRight = stack.removeLast()
                        stack.append("min(\(stack.removeLast()), \(minRight))")
                        
                    case .maximum:
                        let maxRight = stack.removeLast()
                        stack.append("max(\(stack.removeLast()), \(maxRight))")
                        
                    case .cosinus:
                        stack.append("cos(\(stack.removeLast()))")
                        
                    case .sinus:
                        stack.append("sin(\(stack.removeLast()))")
                        
                    case .squareRoot:
                        stack.append("sqrt(\(stack.removeLast()))")
                        
                    case .zoom:
                        stack.append("zoom(\(stack.removeLast()))")
                        
                    case .spriteVariable:
                        let value = Streams.readStringFromByteArray(bytes, atIndex: index)
                        stack.append("sprite.variables[\(value.string)] = \(stack.removeLast())")
                        index += value.readCount
                        
                    case .spriteDirection:
                        stack.append("sprite.direction = \(stack.removeLast())")
                        
                    case .spriteHitboxTop:
                        stack.append("sprite.hitbox.top = \(stack.removeLast())")
                    }
                }
            }
            
            var result = "";
            for instruction in stack {
                if result != "" {
                    result += "; "
                }
                result += instruction
            }
            
            return result
        } else {
            return ""
        }
    }
    
}
