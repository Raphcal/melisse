//
//  Pool.swift
//  MeltedIce
//
//  Created by Raphaël Calabro on 19/01/2016.
//  Copyright © 2016 Raphaël Calabro. All rights reserved.
//

import Foundation

public class ReferencePool {
    
    var available: [Int]
    
    public init() {
        self.available = []
    }
    
    public init(capacity: Int) {
        var available = [Int]()
        
        for index in 1...capacity {
            available.append(capacity - index)
        }

        self.available = available
    }
    
    public init(from: Int, to: Int) {
        let count = abs(to - from)
        let step = (to - from) / count
        
        var available = [Int]()
        var reference = to
        for _ in 0..<count {
            available.append(reference)
            reference -= step
        }
        
        self.available = available
    }
    
    public static func pools(capacities: [Int]) -> [ReferencePool] {
        var end = 0
        return capacities.map {
            let start = end
            end = start + $0
            return ReferencePool(from: start, to: end)
        }
    }
    
    public func next(_ other: Int?) -> Int {
        if let reference = other {
            return nextAfter(reference)
        } else {
            return next()
        }
    }
    
    public func next() -> Int {
        return available.removeLast()
    }
    
    public func nextAfter(_ other: Int) -> Int {
        for index in 1...available.count {
            let reference = available[available.count - index]
            
            if reference > other {
                available.remove(at: available.count - index)
                return reference
            }
        }
        
        return next()
    }
    
    public func release(_ reference: Int) {
        available.append(reference)
    }
    
}
