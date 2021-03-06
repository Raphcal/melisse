//
//  TranslucentSpriteFactory.swift
//  Melisse
//
//  Created by Raphaël Calabro on 28/07/2017.
//  Copyright © 2017 Raphaël Calabro. All rights reserved.
//

import GLKit

/// Version spécifique de `SpriteFactory` permettant de rendre semi-transparent et de teinter les sprites.
public class TranslucentSpriteFactory : SpriteFactory {
    
    /// Surface stockant la couleur des sprites.
    public let colorPointer: SurfaceArray<GLubyte>
    
    override public init() {
        self.colorPointer = SurfaceArray()
        super.init()
    }
    
    override public init(capacity: Int, spriteAtlas: SpriteAtlas, useMultiplePools: Bool = false) {
        self.colorPointer = SurfaceArray(capacity: capacity * vertexesByQuad, coordinates: coordinatesByColor)
        super.init(capacity: capacity, spriteAtlas: spriteAtlas, useMultiplePools: useMultiplePools)
    }
    
    public init(spriteAtlas: SpriteAtlas, pools: [ReferencePool], vertexPointer: SurfaceArray<GLfloat>? = nil, texCoordPointer: SurfaceArray<GLfloat>? = nil, colorPointer: SurfaceArray<GLubyte>? = nil) {
        let capacity = pools.reduce(0) { $0 + $1.available.count }
        self.colorPointer = colorPointer ?? SurfaceArray(capacity: capacity * vertexesByQuad, coordinates: coordinatesByColor)
        super.init(spriteAtlas: spriteAtlas, pools: pools)
    }
    
    public func alpha(of sprite: Sprite) -> GLubyte {
        return colorPointer.surface(at: sprite.reference).memory[3]
    }
    
    /// Défini la transparence du sprite donné.
    /// - Parameter alpha: Valeur de la transparence. Entre 0 (invisible) et 255 (opaque).
    /// - Parameter sprite: Sprite à modifier.
    public func setAlpha(_ alpha: GLubyte, of sprite: Sprite) {
        colorPointer.surface(at: sprite.reference).setAlpha(alpha)
    }
    
    public func tint(of sprite: Sprite) -> Color<GLubyte> {
        let memory = colorPointer.surface(at: sprite.reference).memory
        return Color(red: memory[0], green: memory[1], blue: memory[2], alpha: memory[3])
    }
    
    /// Modifie la teinte d'un sprite donné.
    /// - Parameter tint: Teinte à appliquer.
    /// - Parameter sprite: Sprite à modifier.
    public func setTint(_ tint: Color<GLubyte>, of sprite: Sprite) {
        colorPointer.surface(at: sprite.reference).setColor(tint)
    }
    
    override public func sprite(_ definition: SpriteDefinition, info: SpriteInfo? = nil, after: Sprite? = nil) -> Sprite {
        let sprite = super.sprite(definition, info: info, after: after)
        colorPointer.surface(at: sprite.reference).setColor(with: 255, alpha: 255)
        return sprite
    }
    
    override public func draw(at translation: Point<GLfloat>) {
        Draws.bindTexture(textureAtlas)
        Draws.translateTo(translation)
        Draws.drawWith(vertexPointer.memory, texCoordPointer: texCoordPointer.memory, colorPointer: colorPointer.memory, count: GLsizei(capacity * vertexesByQuad))
    }
    
}
