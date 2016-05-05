//
//  OffCenterRectangular.swift
//  Melisse
//
//  Created by Raphaël Calabro on 05/05/2016.
//  Copyright © 2016 Raphaël Calabro. All rights reserved.
//

import Foundation

protocol OffsettedRectangular : Rectangular {
    
    var offset: Point<Coordinate> { get set }
    
}

extension OffsettedRectangular {
    
    var x: Coordinate {
        return center.x + offset.x
    }
    
    var y: Coordinate {
        return center.y + offset.y
    }
    
    init(center: Point<Coordinate>, offset: Point<Coordinate>, size: Size<Coordinate>) {
        self.center = center
        self.offset = offset
        self.size = size
    }
    
}