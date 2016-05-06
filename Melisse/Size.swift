//
//  Size.swift
//  Melisse
//
//  Created by Raphaël Calabro on 04/05/2016.
//  Copyright © 2016 Raphaël Calabro. All rights reserved.
//

import Foundation

protocol Size {
    
    associatedtype Coordinate : Numeric
    
    var width: Coordinate { get set }
    var height: Coordinate { get set }
    
}