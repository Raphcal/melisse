//
//  AnimationName.swift
//  Melisse
//
//  Created by Raphaël Calabro on 07/05/2016.
//  Copyright © 2016 Raphaël Calabro. All rights reserved.
//

import Foundation

public protocol AnimationName {
    var name: String { get }
}

public enum DefaultAnimationName: AnimationName {
    case normal, disappear
    
    public var name: String {
        get {
            switch self {
            case .normal:
                return "normal"
            case .disappear:
                return "disappear"
            }
        }
    }
}
