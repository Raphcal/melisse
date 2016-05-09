//
//  ShapeLayer.swift
//  Melisse
//
//  Created by Raphaël Calabro on 08/05/2016.
//  Copyright © 2016 Raphaël Calabro. All rights reserved.
//

import Foundation

public class ShapeLayer : Equatable {
    
    public private(set) var count = 0
    
    let capacity: Int
    let vertexPointer: SurfaceArray<GLfloat>
    let colorPointer: SurfaceArray<GLubyte>
    
    init() {
        self.capacity = 0
        self.vertexPointer = SurfaceArray()
        self.colorPointer = SurfaceArray()
    }
    
}

public func ==(lhs: ShapeLayer, rhs: ShapeLayer) -> Bool {
    return false
}