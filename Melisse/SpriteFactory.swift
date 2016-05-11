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
    var removalPending = [Sprite]()
    
    public let definitions: [SpriteDefinition]
    
    public let vertexPointer: SurfaceArray<GLfloat>
    public let texCoordPointer: SurfaceArray<GLshort>
    
    var collisions = [Sprite]()
    
    init() {
        self.capacity = 0
        self.textureAtlas = GLKTextureInfo()
        self.pools = []
        self.definitions = []
        self.vertexPointer = SurfaceArray()
        self.texCoordPointer = SurfaceArray()
    }
    
    init(capacity: Int, textureAtlas: GLKTextureInfo, definitions: [SpriteDefinition], useMultiplePools: Bool = false) {
        self.capacity = capacity
        self.definitions = definitions
        self.textureAtlas = textureAtlas
        
        if useMultiplePools {
            let middle = (capacity * 3) / 4
            self.pools = [
                ReferencePool(from: 0, to: middle),
                ReferencePool(from: middle, to: middle + 2),
                ReferencePool(from: middle + 2, to: capacity)
            ]
        } else {
            self.pools = [ReferencePool(capacity: capacity)]
        }
        
        let vertices = capacity * vertexesByQuad
        self.vertexPointer = SurfaceArray(capacity: vertices, coordinates: coordinatesByVertex)
        self.texCoordPointer = SurfaceArray(capacity: vertices, coordinates: coordinatesByTexture)
        
        // Mise à 0 des pointeurs
        vertexPointer.clear()
        texCoordPointer.clear()
    }
    
    convenience init(capacity: Int, useMultiplePools: Bool = false) {
        self.init(capacity: capacity, textureAtlas: Resources.instance.textureAtlas, definitions: Resources.instance.definitions, useMultiplePools: useMultiplePools)
    }
    
    // MARK: Gestion des mises à jour
    
    func updateWith(timeSinceLastUpdate: NSTimeInterval) {
        for sprite in sprites {
            sprite.updateWith(timeSinceLastUpdate)
        }
        
        commitRemoval()
    }
    
    func updateCollisionsForSprite(player: Sprite) {
        self.collisions = collidables.flatMap { (sprite) -> Sprite? in
            return sprite !== player && sprite.hitbox.collidesWith(player.hitbox) ? sprite : nil
        }
    }
    
    // MARK: Gestion de l'affichage
    
    /// Dessine les sprites de cette factory.
    func draw(at translation: Point<GLfloat> = Camera.instance.frame.topLeft) {
        Draws.bindTexture(textureAtlas)
        Draws.translateTo(translation)
        Draws.drawWithVertexPointer(vertexPointer.memory, texCoordPointer: texCoordPointer.memory, count: GLsizei(capacity * vertexesByQuad))
    }
    
    /// Dessine les sprites de cette factory sans prendre en compte la camera.
    func drawUntranslated() {
        Draws.bindTexture(textureAtlas)
        Draws.drawWithVertexPointer(vertexPointer.memory, texCoordPointer: texCoordPointer.memory, count: GLsizei(capacity * vertexesByQuad))
    }
    
    // MARK: Création de sprites
    
    func sprite(definition: Int) -> Sprite {
        return sprite(definitions[definition])
    }
    
    func sprite(definition: Int, x: GLfloat, y: GLfloat) -> Sprite {
        let sprite = self.sprite(definitions[definition])
        sprite.topLeft = Point(x: x, y: y)
        return sprite
    }
    
    /// Créé un sprite non animé à partir des informations données.
    ///
    /// - parameter parent: Sprite contenant la définition à utiliser.
    /// - parameter animation: Nom de l'animation à sélectionner.
    /// - parameter frame: Indice de l'étape d'animation à utiliser. La taille du nouveau sprite sera celle de l'étape d'animation.
    /// - returns: Un nouveau sprite.
    func sprite(parent: Sprite, animation: AnimationName, frame: Int) -> Sprite {
        let sprite = self.sprite(parent.definition, info: nil, after: parent)
        
        sprite.animation = SingleFrameAnimation(definition: parent.definition.animations[animation]!)
        sprite.animation.frameIndex = frame
        
        let frame = sprite.animation.frame
        sprite.width = GLfloat(frame.width)
        sprite.height = GLfloat(frame.height)
        
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
    func sprite(definition: SpriteDefinition, info: SpriteInfo? = nil, after: Sprite? = nil) -> Sprite {
        let reference = pools[definition.distance.rawValue].next(after?.reference)
        let sprite = Sprite(reference: reference, definition: definition, info: info, parent: self)
        self.sprites.append(sprite)
        
        if definition.type == .Player {
            appendSprite(sprite, toType: .Player)
        } else if definition.type.hasCollisions {
            appendSprite(sprite, toType: .Collidable)
        }
        
        return sprite
    }
    
    // MARK: Suppression de sprites
    
    func removeSprite(sprite: Sprite) {
        sprite.removed = true
        removalPending.append(sprite)
        
        (sprite.motion as? Unloadable)?.unload(sprite)
        
        let definition = sprite.definition
        if definition.type == .Player {
            removeSprite(sprite, fromType: .Player)
        } else if definition.type.hasCollisions {
            removeSprite(sprite, fromType: .Collidable)
        }
    }
    
    func removeOrphanSprites() {
        for sprite in sprites {
            if sprite.info == nil && !sprite.removed {
                removeSprite(sprite)
            }
        }
    }
    
    func commitRemoval() {
        for sprite in removalPending {
            if let index = sprites.indexOf(sprite) {
                sprites.removeAtIndex(index)
                let reference = sprite.reference
                pools[sprite.definition.distance.rawValue].releaseReference(reference)
                vertexPointer.clearQuadAtIndex(reference)
                texCoordPointer.clearQuadAtIndex(reference)
            } else {
                NSLog("removalPending: Sprite \(sprite.reference) non trouvé.")
            }
        }
        removalPending.removeAll(keepCapacity: true)
    }
    
    func clear() {
        for sprite in sprites {
            removeSprite(sprite)
        }
    }
    
    // MARK: Gestion du tri des sprites par type
    
    private func appendSprite(sprite: Sprite, toType type: SpriteType) {
        var sprites = self.types[type]
        
        if sprites == nil {
            sprites = []
        }
        
        sprites!.append(sprite)
        self.types[type] = sprites
    }
    
    private func removeSprite(sprite: Sprite, fromType type: SpriteType) {
        var sprites = self.types[type]!
        
        if let index = sprites.indexOf(sprite) {
            sprites.removeAtIndex(index)
        }
        
        self.types[type] = sprites
    }
    
}
