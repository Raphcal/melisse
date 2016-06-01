//
//  SpriteFactory.swift
//  MeltedIce
//
//  Created by Raphaël Calabro on 09/12/2015.
//  Copyright © 2015 Raphaël Calabro. All rights reserved.
//

import GLKit

public enum Distance : Int {
    case Behind, Middle, Front
}

/// Gère la création, l'affichage et la mise à jour d'un ensemble de sprites.
public class SpriteFactory {
    
    public let capacity: Int
    
    let textureAtlas: GLKTextureInfo
    
    let pools: [ReferencePool]
    public var sprites = [Sprite]()
    public var collidables = [Sprite]()
    private var removalPending = [Sprite]()
    
    public let definitions: [SpriteDefinition]
    
    public let vertexPointer: SurfaceArray<GLfloat>
    public let texCoordPointer: SurfaceArray<GLfloat>
    
    var collisions = [Sprite]()
    
    public init() {
        self.capacity = 0
        self.textureAtlas = GLKTextureInfo()
        self.pools = []
        self.definitions = []
        self.vertexPointer = SurfaceArray()
        self.texCoordPointer = SurfaceArray()
    }
    
    public init(capacity: Int, spriteAtlas: SpriteAtlas, useMultiplePools: Bool = false) {
        self.capacity = capacity
        self.definitions = spriteAtlas.definitions
        self.textureAtlas = spriteAtlas.texture
        
        if useMultiplePools {
            let middle = (capacity * 3) / 4
            self.pools = [
                ReferencePool(from: 0, to: middle),
                ReferencePool(from: middle, to: middle + 2),
                ReferencePool(from: middle + 2, to: capacity)
            ]
        } else {
            let pool = ReferencePool(capacity: capacity)
            self.pools = [pool, pool, pool]
        }
        
        let vertices = capacity * vertexesByQuad
        self.vertexPointer = SurfaceArray(capacity: vertices, coordinates: coordinatesByVertex)
        self.texCoordPointer = SurfaceArray(capacity: vertices, coordinates: coordinatesByTexture)
        
        // Mise à 0 des pointeurs
        vertexPointer.clear()
        texCoordPointer.clear()
    }
    
    convenience public init(capacity: Int, useMultiplePools: Bool = false) {
        self.init(capacity: capacity, spriteAtlas: SpriteAtlas.currentAtlas!, useMultiplePools: useMultiplePools)
    }
    
    // MARK: Gestion des mises à jour
    
    public func updateWith(timeSinceLastUpdate: NSTimeInterval) {
        for sprite in sprites {
            sprite.updateWith(timeSinceLastUpdate)
        }
        commitRemoval()
    }
    
    public func updateCollisionsForSprite(player: Sprite) {
        self.collisions = collidables.flatMap { (sprite) -> Sprite? in
            return sprite !== player && sprite.hitbox.collidesWith(player.hitbox) ? sprite : nil
        }
    }
    
    // MARK: Gestion de l'affichage
    
    /// Dessine les sprites de cette factory.
    public func draw(at translation: Point<GLfloat> = Point()) {
        Draws.bindTexture(textureAtlas)
        Draws.translateTo(translation)
        Draws.drawWith(vertexPointer.memory, texCoordPointer: texCoordPointer.memory, count: GLsizei(capacity * vertexesByQuad))
    }
    
    public func drawWith(tint: Color<GLubyte>, at translation: Point<GLfloat> = Point()) {
        Draws.bindTexture(textureAtlas)
        Draws.translateTo(translation)
        Draws.drawWith(vertexPointer.memory, texCoordPointer: texCoordPointer.memory, count: GLsizei(capacity * vertexesByQuad))
    }
    
    // MARK: Création de sprites
    
    public func sprite(definition: Int) -> Sprite {
        return sprite(definitions[definition])
    }
    
    public func sprite(definition: Int?) -> Sprite? {
        if let definition = definition {
            return sprite(definitions[definition])
        } else {
            return nil
        }
    }
    
    public func sprite(definition: Int, topLeft: Point<GLfloat>) -> Sprite {
        let sprite = self.sprite(definition)
        sprite.frame.topLeft = topLeft
        return sprite
    }
    
    /// Créé un sprite non animé à partir des informations données.
    ///
    /// - parameter parent: Sprite contenant la définition à utiliser.
    /// - parameter animation: Nom de l'animation à sélectionner.
    /// - parameter frame: Indice de l'étape d'animation à utiliser. La taille du nouveau sprite sera celle de l'étape d'animation.
    /// - returns: Un nouveau sprite.
    public func sprite(parent: Sprite, animation: AnimationName, frame: Int) -> Sprite {
        let sprite = self.sprite(parent.definition, info: nil, after: parent)
        
        sprite.animation = SingleFrameAnimation(definition: parent.definition.animations[animation.name]!)
        sprite.animation.frameIndex = frame
        
        sprite.frame.size = sprite.animation.frame.size
        
        return sprite
    }
    
    /// Créé un sprite à partir de la définition donnée et lie le sprite à l'information donnée (si non nil).
    ///
    /// Il s'agit de la méthode principale pour créer un sprite. Elle est appelée par toute les autres méthodes de création.
    ///
    /// - parameter definition: Définition du sprite.
    /// - parameter info: Informations du loader sur le sprite à créer.
    /// - parameter after: Si non nil, la référence du nouveau sprite sera (si possible) supérieur à celle du sprite donné.
    /// - returns: Un nouveau sprite.
    public func sprite(definition: SpriteDefinition, info: SpriteInfo? = nil, after: Sprite? = nil) -> Sprite {
        let reference = pools[definition.distance.rawValue].next(after?.reference)
        let sprite = Sprite(definition: definition, reference: reference, factory: self, info: info)
        self.sprites.append(sprite)
        
        if definition.type.isCollidable {
            collidables.append(sprite)
        }
        
        return sprite
    }
    
    // MARK: Suppression de sprites
    
    public func removeSprite(sprite: Sprite) {
        sprite.removed = true
        
        if let index = sprites.indexOf({ sprite === $0 }) {
            sprites.removeAtIndex(index)
            removalPending.append(sprite)
        }
        
        if sprite.definition.type.isCollidable, let index = collidables.indexOf({ sprite === $0 }) {
            collidables.removeAtIndex(index)
        }
    }
    
    public func removeOrphanSprites() {
        for sprite in sprites {
            if sprite.info == nil && !sprite.removed {
                removeSprite(sprite)
            }
        }
    }
    
    public func commitRemoval() {
        for sprite in removalPending {
            sprite.motion.unload(sprite)
            sprite.vertexSurface.clear()
            sprite.texCoordSurface.clear()
            pools[sprite.definition.distance.rawValue].release(sprite.reference)
        }
        removalPending = []
    }
    
    public func clear() {
        for sprite in sprites {
            removeSprite(sprite)
        }
    }
    
}
