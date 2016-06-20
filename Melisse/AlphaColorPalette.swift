//
//  AlphaColorPalette.swift
//  Melisse
//
//  Created by Raphaël Calabro on 10/05/2016.
//  Copyright © 2016 Raphaël Calabro. All rights reserved.
//

import GLKit

public class AlphaColorPalette : ColorPalette {
    
    static let defaultPalette = AlphaColorPalette()
    
    static let colors = [
        Color<GLubyte>(red: 0, green: 0, blue: 6, alpha: 255),
        Color<GLubyte>(red: 232, green: 250, blue: 255, alpha: 255),
        Color<GLubyte>(red: 235, green: 233, blue: 248, alpha: 255),
        Color<GLubyte>(red: 255, green: 238, blue: 238, alpha: 255),
        Color<GLubyte>(red: 253, green: 255, blue: 214, alpha: 255),
        Color<GLubyte>(red: 196, green: 255, blue: 217, alpha: 255),
        Color<GLubyte>(red: 0, green: 246, blue: 245, alpha: 255),
        Color<GLubyte>(red: 229, green: 254, blue: 216, alpha: 255),
        Color<GLubyte>(red: 210, green: 0, blue: 0, alpha: 255),
        Color<GLubyte>(red: 205, green: 245, blue: 255, alpha: 255),
        Color<GLubyte>(red: 219, green: 214, blue: 245, alpha: 255),
        Color<GLubyte>(red: 255, green: 207, blue: 208, alpha: 255),
        Color<GLubyte>(red: 250, green: 255, blue: 127, alpha: 255),
        Color<GLubyte>(red: 153, green: 248, blue: 181, alpha: 255),
        Color<GLubyte>(red: 0, green: 230, blue: 228, alpha: 255),
        Color<GLubyte>(red: 217, green: 254, blue: 216, alpha: 255),
        Color<GLubyte>(red: 0, green: 179, blue: 0, alpha: 255),
        Color<GLubyte>(red: 185, green: 240, blue: 255, alpha: 255),
        Color<GLubyte>(red: 202, green: 195, blue: 235, alpha: 255),
        Color<GLubyte>(red: 255, green: 172, blue: 172, alpha: 255),
        Color<GLubyte>(red: 248, green: 255, blue: 0, alpha: 255),
        Color<GLubyte>(red: 83, green: 238, blue: 150, alpha: 255),
        Color<GLubyte>(red: 0, green: 211, blue: 210, alpha: 255),
        Color<GLubyte>(red: 196, green: 255, blue: 217, alpha: 255),
        Color<GLubyte>(red: 161, green: 175, blue: 0, alpha: 255),
        Color<GLubyte>(red: 153, green: 234, blue: 255, alpha: 255),
        Color<GLubyte>(red: 189, green: 181, blue: 231, alpha: 255),
        Color<GLubyte>(red: 255, green: 139, blue: 141, alpha: 255),
        Color<GLubyte>(red: 251, green: 255, blue: 0, alpha: 255),
        Color<GLubyte>(red: 0, green: 229, blue: 112, alpha: 255),
        Color<GLubyte>(red: 0, green: 192, blue: 190, alpha: 255),
        Color<GLubyte>(red: 196, green: 254, blue: 231, alpha: 255),
        Color<GLubyte>(red: 45, green: 0, blue: 183, alpha: 255),
        Color<GLubyte>(red: 127, green: 228, blue: 255, alpha: 255),
        Color<GLubyte>(red: 173, green: 159, blue: 228, alpha: 255),
        Color<GLubyte>(red: 255, green: 83, blue: 88, alpha: 255),
        Color<GLubyte>(red: 242, green: 250, blue: 0, alpha: 255),
        Color<GLubyte>(red: 0, green: 218, blue: 70, alpha: 255),
        Color<GLubyte>(red: 0, green: 172, blue: 170, alpha: 255),
        Color<GLubyte>(red: 196, green: 253, blue: 239, alpha: 255),
        Color<GLubyte>(red: 212, green: 0, blue: 179, alpha: 255),
        Color<GLubyte>(red: 0, green: 219, blue: 254, alpha: 255),
        Color<GLubyte>(red: 156, green: 142, blue: 216, alpha: 255),
        Color<GLubyte>(red: 255, green: 0, blue: 0, alpha: 255),
        Color<GLubyte>(red: 235, green: 233, blue: 0, alpha: 255),
        Color<GLubyte>(red: 0, green: 213, blue: 0, alpha: 255),
        Color<GLubyte>(red: 0, green: 149, blue: 148, alpha: 255),
        Color<GLubyte>(red: 185, green: 253, blue: 246, alpha: 255),
        Color<GLubyte>(red: 0, green: 172, blue: 170, alpha: 255),
        Color<GLubyte>(red: 0, green: 198, blue: 251, alpha: 255),
        Color<GLubyte>(red: 143, green: 126, blue: 211, alpha: 255),
        Color<GLubyte>(red: 255, green: 0, blue: 0, alpha: 255),
        Color<GLubyte>(red: 231, green: 212, blue: 0, alpha: 255),
        Color<GLubyte>(red: 0, green: 200, blue: 0, alpha: 255),
        Color<GLubyte>(red: 0, green: 124, blue: 123, alpha: 255),
        Color<GLubyte>(red: 192, green: 246, blue: 253, alpha: 255),
        Color<GLubyte>(red: 217, green: 217, blue: 217, alpha: 255),
        Color<GLubyte>(red: 0, green: 185, blue: 234, alpha: 255),
        Color<GLubyte>(red: 129, green: 105, blue: 198, alpha: 255),
        Color<GLubyte>(red: 255, green: 0, blue: 0, alpha: 255),
        Color<GLubyte>(red: 233, green: 192, blue: 0, alpha: 255),
        Color<GLubyte>(red: 0, green: 186, blue: 0, alpha: 255),
        Color<GLubyte>(red: 0, green: 96, blue: 93, alpha: 255),
        Color<GLubyte>(red: 205, green: 233, blue: 248, alpha: 255),
        Color<GLubyte>(red: 202, green: 237, blue: 214, alpha: 255),
        Color<GLubyte>(red: 0, green: 173, blue: 215, alpha: 255),
        Color<GLubyte>(red: 113, green: 83, blue: 194, alpha: 255),
        Color<GLubyte>(red: 255, green: 0, blue: 0, alpha: 255),
        Color<GLubyte>(red: 225, green: 171, blue: 0, alpha: 255),
        Color<GLubyte>(red: 0, green: 172, blue: 0, alpha: 255),
        Color<GLubyte>(red: 255, green: 246, blue: 216, alpha: 255),
        Color<GLubyte>(red: 210, green: 227, blue: 250, alpha: 255),
        Color<GLubyte>(red: 169, green: 221, blue: 255, alpha: 255),
        Color<GLubyte>(red: 0, green: 158, blue: 203, alpha: 255),
        Color<GLubyte>(red: 103, green: 70, blue: 187, alpha: 255),
        Color<GLubyte>(red: 255, green: 0, blue: 0, alpha: 255),
        Color<GLubyte>(red: 215, green: 155, blue: 0, alpha: 255),
        Color<GLubyte>(red: 0, green: 155, blue: 0, alpha: 255),
        Color<GLubyte>(red: 255, green: 242, blue: 201, alpha: 255),
        Color<GLubyte>(red: 215, green: 221, blue: 244, alpha: 255),
        Color<GLubyte>(red: 154, green: 255, blue: 218, alpha: 255),
        Color<GLubyte>(red: 0, green: 145, blue: 182, alpha: 255),
        Color<GLubyte>(red: 88, green: 64, blue: 164, alpha: 255),
        Color<GLubyte>(red: 233, green: 0, blue: 0, alpha: 255),
        Color<GLubyte>(red: 202, green: 139, blue: 0, alpha: 255),
        Color<GLubyte>(red: 0, green: 139, blue: 0, alpha: 255),
        Color<GLubyte>(red: 255, green: 242, blue: 193, alpha: 255),
        Color<GLubyte>(red: 255, green: 250, blue: 154, alpha: 255),
        Color<GLubyte>(red: 98, green: 252, blue: 213, alpha: 255),
        Color<GLubyte>(red: 0, green: 118, blue: 162, alpha: 255),
        Color<GLubyte>(red: 72, green: 60, blue: 138, alpha: 255),
        Color<GLubyte>(red: 210, green: 0, blue: 0, alpha: 255),
        Color<GLubyte>(red: 191, green: 120, blue: 0, alpha: 255),
        Color<GLubyte>(red: 0, green: 129, blue: 0, alpha: 255),
        Color<GLubyte>(red: 255, green: 237, blue: 178, alpha: 255),
        Color<GLubyte>(red: 253, green: 246, blue: 135, alpha: 255),
        Color<GLubyte>(red: 31, green: 248, blue: 207, alpha: 255),
        Color<GLubyte>(red: 0, green: 102, blue: 134, alpha: 255),
        Color<GLubyte>(red: 67, green: 44, blue: 120, alpha: 255),
        Color<GLubyte>(red: 183, green: 0, blue: 0, alpha: 255),
        Color<GLubyte>(red: 176, green: 102, blue: 0, alpha: 255),
        Color<GLubyte>(red: 0, green: 112, blue: 0, alpha: 255),
        Color<GLubyte>(red: 255, green: 231, blue: 169, alpha: 255),
        Color<GLubyte>(red: 255, green: 239, blue: 124, alpha: 255),
        Color<GLubyte>(red: 0, green: 235, blue: 210, alpha: 255),
        Color<GLubyte>(red: 0, green: 79, blue: 117, alpha: 255),
        Color<GLubyte>(red: 42, green: 0, blue: 89, alpha: 255),
        Color<GLubyte>(red: 153, green: 0, blue: 0, alpha: 255),
        Color<GLubyte>(red: 163, green: 80, blue: 0, alpha: 255),
        Color<GLubyte>(red: 0, green: 87, blue: 0, alpha: 255),
        Color<GLubyte>(red: 255, green: 225, blue: 162, alpha: 255),
        Color<GLubyte>(red: 255, green: 234, blue: 96, alpha: 255),
        Color<GLubyte>(red: 0, green: 229, blue: 212, alpha: 255),
        Color<GLubyte>(red: 0, green: 54, blue: 87, alpha: 255),
        Color<GLubyte>(red: 8, green: 0, blue: 66, alpha: 255),
        Color<GLubyte>(red: 117, green: 0, blue: 0, alpha: 255),
        Color<GLubyte>(red: 143, green: 67, blue: 0, alpha: 255),
        Color<GLubyte>(red: 0, green: 63, blue: 0, alpha: 255),
        Color<GLubyte>(red: 255, green: 219, blue: 145, alpha: 255),
        Color<GLubyte>(red: 255, green: 229, blue: 59, alpha: 255),
        Color<GLubyte>(red: 0, green: 223, blue: 214, alpha: 255),
        Color<GLubyte>(red: 0, green: 23, blue: 43, alpha: 255),
        Color<GLubyte>(red: 5, green: 0, blue: 26, alpha: 255),
        Color<GLubyte>(red: 74, green: 0, blue: 0, alpha: 255),
        Color<GLubyte>(red: 133, green: 56, blue: 0, alpha: 255),
        Color<GLubyte>(red: 0, green: 46, blue: 0, alpha: 255),
        Color<GLubyte>(red: 255, green: 212, blue: 134, alpha: 255),
        Color<GLubyte>(red: 255, green: 223, blue: 0, alpha: 255),
        Color<GLubyte>(red: 255, green: 255, blue: 255, alpha: 255),
        Color<GLubyte>(red: 230, green: 238, blue: 255, alpha: 255),
        Color<GLubyte>(red: 255, green: 229, blue: 255, alpha: 255),
        Color<GLubyte>(red: 255, green: 235, blue: 202, alpha: 255),
        Color<GLubyte>(red: 225, green: 255, blue: 229, alpha: 255),
        Color<GLubyte>(red: 209, green: 255, blue: 116, alpha: 255),
        Color<GLubyte>(red: 255, green: 206, blue: 124, alpha: 255),
        Color<GLubyte>(red: 255, green: 216, blue: 0, alpha: 255),
        Color<GLubyte>(red: 245, green: 245, blue: 245, alpha: 255),
        Color<GLubyte>(red: 211, green: 227, blue: 255, alpha: 255),
        Color<GLubyte>(red: 255, green: 202, blue: 251, alpha: 255),
        Color<GLubyte>(red: 255, green: 219, blue: 163, alpha: 255),
        Color<GLubyte>(red: 200, green: 250, blue: 202, alpha: 255),
        Color<GLubyte>(red: 183, green: 255, blue: 75, alpha: 255),
        Color<GLubyte>(red: 255, green: 194, blue: 105, alpha: 255),
        Color<GLubyte>(red: 255, green: 204, blue: 0, alpha: 255),
        Color<GLubyte>(red: 233, green: 233, blue: 233, alpha: 255),
        Color<GLubyte>(red: 187, green: 214, blue: 255, alpha: 255),
        Color<GLubyte>(red: 255, green: 182, blue: 247, alpha: 255),
        Color<GLubyte>(red: 255, green: 200, blue: 114, alpha: 255),
        Color<GLubyte>(red: 174, green: 240, blue: 182, alpha: 255),
        Color<GLubyte>(red: 169, green: 245, blue: 0, alpha: 255),
        Color<GLubyte>(red: 255, green: 171, blue: 100, alpha: 255),
        Color<GLubyte>(red: 255, green: 189, blue: 0, alpha: 255),
        Color<GLubyte>(red: 223, green: 223, blue: 223, alpha: 255),
        Color<GLubyte>(red: 162, green: 201, blue: 255, alpha: 255),
        Color<GLubyte>(red: 254, green: 158, blue: 237, alpha: 255),
        Color<GLubyte>(red: 255, green: 180, blue: 0, alpha: 255),
        Color<GLubyte>(red: 142, green: 230, blue: 160, alpha: 255),
        Color<GLubyte>(red: 147, green: 241, blue: 0, alpha: 255),
        Color<GLubyte>(red: 255, green: 165, blue: 89, alpha: 255),
        Color<GLubyte>(red: 255, green: 181, blue: 0, alpha: 255),
        Color<GLubyte>(red: 211, green: 211, blue: 211, alpha: 255),
        Color<GLubyte>(red: 132, green: 188, blue: 255, alpha: 255),
        Color<GLubyte>(red: 243, green: 143, blue: 226, alpha: 255),
        Color<GLubyte>(red: 255, green: 156, blue: 0, alpha: 255),
        Color<GLubyte>(red: 113, green: 226, blue: 131, alpha: 255),
        Color<GLubyte>(red: 107, green: 230, blue: 0, alpha: 255),
        Color<GLubyte>(red: 251, green: 148, blue: 83, alpha: 255),
        Color<GLubyte>(red: 255, green: 166, blue: 0, alpha: 255),
        Color<GLubyte>(red: 193, green: 193, blue: 193, alpha: 255),
        Color<GLubyte>(red: 116, green: 171, blue: 255, alpha: 255),
        Color<GLubyte>(red: 243, green: 115, blue: 215, alpha: 255),
        Color<GLubyte>(red: 255, green: 127, blue: 0, alpha: 255),
        Color<GLubyte>(red: 54, green: 215, blue: 115, alpha: 255),
        Color<GLubyte>(red: 83, green: 218, blue: 0, alpha: 255),
        Color<GLubyte>(red: 239, green: 133, blue: 76, alpha: 255),
        Color<GLubyte>(red: 255, green: 147, blue: 0, alpha: 255),
        Color<GLubyte>(red: 180, green: 180, blue: 180, alpha: 255),
        Color<GLubyte>(red: 72, green: 157, blue: 255, alpha: 255),
        Color<GLubyte>(red: 232, green: 91, blue: 210, alpha: 255),
        Color<GLubyte>(red: 255, green: 129, blue: 0, alpha: 255),
        Color<GLubyte>(red: 0, green: 204, blue: 92, alpha: 255),
        Color<GLubyte>(red: 49, green: 205, blue: 0, alpha: 255),
        Color<GLubyte>(red: 227, green: 114, blue: 65, alpha: 255),
        Color<GLubyte>(red: 255, green: 255, blue: 249, alpha: 255),
        Color<GLubyte>(red: 167, green: 167, blue: 167, alpha: 255),
        Color<GLubyte>(red: 55, green: 137, blue: 255, alpha: 255),
        Color<GLubyte>(red: 220, green: 66, blue: 197, alpha: 255),
        Color<GLubyte>(red: 255, green: 120, blue: 0, alpha: 255),
        Color<GLubyte>(red: 0, green: 191, blue: 68, alpha: 255),
        Color<GLubyte>(red: 0, green: 199, blue: 0, alpha: 255),
        Color<GLubyte>(red: 213, green: 105, blue: 52, alpha: 255),
        Color<GLubyte>(red: 193, green: 193, blue: 193, alpha: 255),
        Color<GLubyte>(red: 152, green: 152, blue: 152, alpha: 255),
        Color<GLubyte>(red: 0, green: 133, blue: 239, alpha: 255),
        Color<GLubyte>(red: 215, green: 1, blue: 184, alpha: 255),
        Color<GLubyte>(red: 255, green: 112, blue: 0, alpha: 255),
        Color<GLubyte>(red: 0, green: 178, blue: 31, alpha: 255),
        Color<GLubyte>(red: 0, green: 255, blue: 0, alpha: 255),
        Color<GLubyte>(red: 209, green: 81, blue: 42, alpha: 255),
        Color<GLubyte>(red: 167, green: 167, blue: 167, alpha: 255),
        Color<GLubyte>(red: 137, green: 137, blue: 137, alpha: 255),
        Color<GLubyte>(red: 1, green: 117, blue: 220, alpha: 255),
        Color<GLubyte>(red: 199, green: 0, blue: 171, alpha: 255),
        Color<GLubyte>(red: 238, green: 104, blue: 0, alpha: 255),
        Color<GLubyte>(red: 0, green: 163, blue: 0, alpha: 255),
        Color<GLubyte>(red: 0, green: 244, blue: 0, alpha: 255),
        Color<GLubyte>(red: 192, green: 72, blue: 18, alpha: 255),
        Color<GLubyte>(red: 255, green: 0, blue: 0, alpha: 255),
        Color<GLubyte>(red: 120, green: 120, blue: 120, alpha: 255),
        Color<GLubyte>(red: 0, green: 112, blue: 192, alpha: 255),
        Color<GLubyte>(red: 184, green: 0, blue: 163, alpha: 255),
        Color<GLubyte>(red: 225, green: 79, blue: 0, alpha: 255),
        Color<GLubyte>(red: 0, green: 147, blue: 0, alpha: 255),
        Color<GLubyte>(red: 0, green: 233, blue: 0, alpha: 255),
        Color<GLubyte>(red: 177, green: 60, blue: 0, alpha: 255),
        Color<GLubyte>(red: 0, green: 255, blue: 0, alpha: 255),
        Color<GLubyte>(red: 103, green: 103, blue: 103, alpha: 255),
        Color<GLubyte>(red: 0, green: 96, blue: 170, alpha: 255),
        Color<GLubyte>(red: 175, green: 0, blue: 147, alpha: 255),
        Color<GLubyte>(red: 205, green: 54, blue: 0, alpha: 255),
        Color<GLubyte>(red: 0, green: 138, blue: 0, alpha: 255),
        Color<GLubyte>(red: 0, green: 219, blue: 0, alpha: 255),
        Color<GLubyte>(red: 160, green: 15, blue: 0, alpha: 255),
        Color<GLubyte>(red: 255, green: 255, blue: 0, alpha: 255),
        Color<GLubyte>(red: 81, green: 81, blue: 81, alpha: 255),
        Color<GLubyte>(red: 0, green: 71, blue: 147, alpha: 255),
        Color<GLubyte>(red: 156, green: 0, blue: 129, alpha: 255),
        Color<GLubyte>(red: 190, green: 0, blue: 0, alpha: 255),
        Color<GLubyte>(red: 0, green: 120, blue: 0, alpha: 255),
        Color<GLubyte>(red: 0, green: 207, blue: 0, alpha: 255),
        Color<GLubyte>(red: 141, green: 0, blue: 0, alpha: 255),
        Color<GLubyte>(red: 0, green: 0, blue: 255, alpha: 255),
        Color<GLubyte>(red: 43, green: 43, blue: 43, alpha: 255),
        Color<GLubyte>(red: 0, green: 65, blue: 120, alpha: 255),
        Color<GLubyte>(red: 131, green: 0, blue: 120, alpha: 255),
        Color<GLubyte>(red: 162, green: 0, blue: 0, alpha: 255),
        Color<GLubyte>(red: 0, green: 101, blue: 0, alpha: 255),
        Color<GLubyte>(red: 0, green: 193, blue: 0, alpha: 255),
        Color<GLubyte>(red: 130, green: 0, blue: 0, alpha: 255),
        Color<GLubyte>(red: 255, green: 0, blue: 255, alpha: 255),
        Color<GLubyte>(red: 2, green: 2, blue: 2, alpha: 255),
        Color<GLubyte>(red: 0, green: 34, blue: 89, alpha: 255),
        Color<GLubyte>(red: 119, green: 0, blue: 99, alpha: 255),
        Color<GLubyte>(red: 141, green: 0, blue: 0, alpha: 255),
        Color<GLubyte>(red: 0, green: 78, blue: 0, alpha: 255),
        Color<GLubyte>(red: 0, green: 180, blue: 0, alpha: 255),
        Color<GLubyte>(red: 104, green: 0, blue: 0, alpha: 255),
        Color<GLubyte>(red: 0, green: 255, blue: 255, alpha: 255),
        Color<GLubyte>(red: 0, green: 0, blue: 6, alpha: 255),
        Color<GLubyte>(red: 5, green: 0, blue: 48, alpha: 255),
        Color<GLubyte>(red: 92, green: 0, blue: 74, alpha: 255),
        Color<GLubyte>(red: 117, green: 0, blue: 0, alpha: 255),
        Color<GLubyte>(red: 0, green: 46, blue: 0, alpha: 255),
        Color<GLubyte>(red: 0, green: 163, blue: 0, alpha: 255),
        Color<GLubyte>(red: 74, green: 0, blue: 0, alpha: 255),
        Color<GLubyte>(red: 255, green: 255, blue: 255, alpha: 255)
    ]
    static let alphas: [GLubyte] = [255, 224, 192, 160, 128, 96, 64, 32]
    static let mask = 1000
    
    public var tileSize = 8
    var size = 4
    
    public var colors: [Color<GLubyte>]
    public let functions = [[UInt8]?]()
    
    public init(colors: [Color<GLubyte>] = AlphaColorPalette.colors) {
        self.colors = colors
    }
    
    public func colorFor(_ tile: Int) -> Color<GLubyte> {
        let colorIndex = colorIndexFromTile(tile)
        let alphaIndex = alphaIndexFromTile(tile)
        
        if isColorIndexInBounds(colorIndex) && isAlphaIndexInBounds(alphaIndex) {
            var color = colors[colorIndex]
            color.alpha = AlphaColorPalette.alphas[alphaIndex]
            return color
        } else {
            return Color()
        }
    }
    
    public func paint(_ tile: Int, in context: CGContext, rect: CGRect) {
        let baseColor = colorFor(tile)
        
        let red = CGFloat(baseColor.red) / 255
        let green = CGFloat(baseColor.green) / 255
        let blue = CGFloat(baseColor.blue) / 255
        let alpha = CGFloat(baseColor.alpha) / 255
        #if os(iOS)
            let color = UIColor(red: red, green: green, blue: blue, alpha: alpha)
        #else
            let color = NSColor(red: red, green: green, blue: blue, alpha: alpha)
        #endif
        context.setFillColor(color.cgColor)
        context.fill(rect)
    }
    
    private func alphaIndexFromTile(_ tile: Int) -> Int {
        return tile / AlphaColorPalette.mask
    }
    
    private func colorIndexFromTile(_ tile: Int) -> Int {
        return tile % AlphaColorPalette.mask
    }
    
    private func isColorIndexInBounds(_ colorIndex: Int) -> Bool {
        return colorIndex >= 0 && colorIndex < colors.count
    }
    
    private func isAlphaIndexInBounds(_ alphaIndex: Int) -> Bool {
        return alphaIndex >= 0 && alphaIndex < AlphaColorPalette.alphas.count
    }
    
}
