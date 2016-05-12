//
//  Pool.swift
//  MeltedIce
//
//  Created by Raphaël Calabro on 19/01/2016.
//  Copyright © 2016 Raphaël Calabro. All rights reserved.
//

import Foundation

public class ReferencePool {
    
    private var available: [Int]
    
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
    
    public func next(other: Int?) -> Int {
        if let reference = other {
            return nextAfter(reference)
        } else {
            return next()
        }
    }
    
    public func next() -> Int {
        return available.removeLast()
    }
    
    public func nextAfter(other: Int) -> Int {
        for index in 1...available.count {
            let reference = available[available.count - index]
            
            if reference > other {
                available.removeAtIndex(available.count - index)
                return reference
            }
        }
        
        return next()
    }
    
    public func release(reference: Int) {
        available.append(reference)
    }
    
}