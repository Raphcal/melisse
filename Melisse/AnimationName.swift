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

public struct DefaultAnimationName: AnimationName {
    public static let normal = DefaultAnimationName(name: "normal")
    public static let disappear = DefaultAnimationName(name: "disappear")
    
    public let name: String
}
