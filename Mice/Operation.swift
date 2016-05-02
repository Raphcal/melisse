//
//  Operation.swift
//  MeltedIce
//
//  Created by Raphaël Calabro on 30/06/2015.
//  Copyright (c) 2015 Raphaël Calabro. All rights reserved.
//

import GLKit

enum ByteCode : UInt8 {
    case Add = 0x2b
    case Substract = 0x2d
    case Multiply = 0x2a
    case Divide = 0x2f
    case Negative = 0x6e
    case Constant = 0x43
    case X = 0x78
    case Pi = 0x70
    case E = 0x65
    case Minimum = 0x6d
    case Maximum = 0x4d
    case Cosinus = 0x63
    case Sinus = 0x73
    case SquareRoot = 0x53
    case Zoom = 0x7a
    case SpriteVariable = 0x76
    case SpriteDirection = 0x64
    case SpriteHitboxTop = 0x68
}

class Operation {
    
    class func execute(operation: [UInt8]?, x: GLfloat) -> GLfloat {
        if let bytes = operation {
            var stack = execute(bytes, x: x, sprite: nil)
            return stack.removeLast()
        } else {
            return 0
        }
    }
    
    class func execute(operation: [UInt8]?, sprite: Sprite) {
        if let bytes = operation {
            execute(bytes, x: 0, sprite: sprite)
        }
    }
    
    private class func execute(bytes: [UInt8], x: GLfloat, sprite: Sprite?) -> [GLfloat] {
        var index = 0
        var stack = [GLfloat]()
        stack.reserveCapacity(bytes.count)
        
        while index < bytes.count {
            if let b = ByteCode(rawValue: bytes[index]) {
                index += 1
                switch b  {
                case .Add:
                    stack.append(stack.removeLast() + stack.removeLast())
                    
                case .Substract:
                    let substracted = stack.removeLast()
                    stack.append(stack.removeLast() - substracted)
                    
                case .Multiply:
                    stack.append(stack.removeLast() * stack.removeLast())
                    
                case .Divide:
                    let divisor = stack.removeLast()
                    stack.append(stack.removeLast() / divisor)
                    
                case .Negative:
                    stack.append(-stack.removeLast())
                    
                case .Constant:
                    let value = Streams.readFloatFromByteArray(bytes, atIndex: index)
                    stack.append(value.float)
                    index += value.readCount
                    
                case .X:
                    stack.append(x)
                    
                case .Pi:
                    stack.append(GLfloat(M_PI))
                    
                case .E:
                    stack.append(GLfloat(M_E))
                    
                case .Minimum:
                    stack.append(min(stack.removeLast(), stack.removeLast()))
                    
                case .Maximum:
                    stack.append(max(stack.removeLast(), stack.removeLast()))
                    
                case .Cosinus:
                    stack.append(cos(stack.removeLast()))
                    
                case .Sinus:
                    stack.append(sin(stack.removeLast()))
                    
                case .SquareRoot:
                    let last = stack.removeLast()
                    if last >= 0 {
                        stack.append(sqrt(last))
                    } else {
                        stack.append(-1)
                    }
                     
                case .Zoom:
                    break
                    
                case .SpriteVariable:
                    let value = Streams.readStringFromByteArray(bytes, atIndex: index)
                    sprite!.variables[value.string] = stack.removeLast()
                    index += value.readCount
                    
                case .SpriteDirection:
                    sprite!.direction = Direction(rawValue: Int(stack.removeLast()))!
                    
                case .SpriteHitboxTop:
                    let hitboxTop = stack.removeLast()
                    
                    if let hitbox = sprite!.hitbox as? SimpleHitbox {
                        hitbox.height -= hitboxTop
                        hitbox.offset.y = hitboxTop
                    }
                }
            }
        }
        
        return stack
    }
    
    class func description(operation: [UInt8]?) -> String {
        if let bytes = operation {
            var index = 0
            var stack = [String]()
            
            while index < bytes.count {
                if let b = ByteCode(rawValue: bytes[index]) {
                    index += 1
                    switch b  {
                    case .Add:
                        let added = stack.removeLast()
                        stack.append("\(stack.removeLast()) + \(added)")
                        
                    case .Substract:
                        let substracted = stack.removeLast()
                        stack.append("\(stack.removeLast()) - \(substracted)")
                        
                    case .Multiply:
                        let multiplicated = stack.removeLast()
                        stack.append("\(stack.removeLast()) * \(multiplicated)")
                        
                    case .Divide:
                        let divisor = stack.removeLast()
                        stack.append("\(stack.removeLast()) / \(divisor)")
                        
                    case .Negative:
                        stack.append("-\(stack.removeLast())")
                        
                    case .Constant:
                        let value = Streams.readFloatFromByteArray(bytes, atIndex: index)
                        stack.append("\(value.float)")
                        index += value.readCount
                        
                    case .X:
                        stack.append("x")
                        
                    case .Pi:
                        stack.append("π")
                        
                    case .E:
                        stack.append("e")
                        
                    case .Minimum:
                        let minRight = stack.removeLast()
                        stack.append("min(\(stack.removeLast()), \(minRight))")
                        
                    case .Maximum:
                        let maxRight = stack.removeLast()
                        stack.append("max(\(stack.removeLast()), \(maxRight))")
                        
                    case .Cosinus:
                        stack.append("cos(\(stack.removeLast()))")
                        
                    case .Sinus:
                        stack.append("sin(\(stack.removeLast()))")
                        
                    case .SquareRoot:
                        stack.append("sqrt(\(stack.removeLast()))")
                        
                    case .Zoom:
                        stack.append("zoom(\(stack.removeLast()))")
                        
                    case .SpriteVariable:
                        let value = Streams.readStringFromByteArray(bytes, atIndex: index)
                        stack.append("sprite.variables[\(value.string)] = \(stack.removeLast())")
                        index += value.readCount
                        
                    case .SpriteDirection:
                        stack.append("sprite.direction = \(stack.removeLast())")
                        
                    case .SpriteHitboxTop:
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