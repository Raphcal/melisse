//
//  HasFrame.swift
//  Melisse
//
//  Created by Raphaël Calabro on 29/08/2017.
//  Copyright © 2017 Raphaël Calabro. All rights reserved.
//

import Foundation
import GLKit

public protocol HasFrame {
    var frame: Rectangle<GLfloat> { get }
}
