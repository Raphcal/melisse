//
//  AnimationName.swift
//  Melisse
//
//  Created by Raphaël Calabro on 07/05/2016.
//  Copyright © 2016 Raphaël Calabro. All rights reserved.
//

import Foundation

protocol AnimationName {
    var rawValue: Int { get }
}

enum DefaultAnimationName: Int, AnimationName {
    case Normal, Disappear
}