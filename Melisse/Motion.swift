//
//  Motion.swift
//  MeltedIce
//
//  Created by Raphaël Calabro on 29/06/2015.
//  Copyright (c) 2015 Raphaël Calabro. All rights reserved.
//

import Foundation

/// Description d'un gestionnaire de mouvements.
protocol Motion {
    
    /// Initialisation du mouvement pour le sprite donné.
    func load(sprite : Sprite)
    
    /// Calcul et application du mouvement pour le sprite donné.
    func updateWithTimeSinceLastUpdate(timeSinceLastUpdate: NSTimeInterval, sprite: Sprite)
    
}

protocol Unloadable {
    func unload(sprite: Sprite)
}

protocol Platform {
    /// Position `y` du sprite `sprite` quand posé sur la plateforme `platform`.
    func locationForSprite(sprite: Sprite, onPlatform platform: Sprite) -> GLfloat
    /// Atterrissage et rattachement du sprite `sprite` sur la plateforme `platform`.
    func landOnPlatform(platform: Sprite, sprite: Sprite)
    /// Détachement du sprite `sprite` de la plateforme `platform`.
    func takeOff(platform: Sprite, sprite: Sprite)
}

protocol Collidable {
    func onCollision(sprite: Sprite, playerMotion: PlayerMotion)
    func onCollision(sprite: Sprite, characterMotion: CharacterMotion)
}

// MARK: - Wall

protocol Wall : Collidable {
    // Pas de méthodes.
}

extension Wall {
    
    func actAsWall(sprite: Sprite, playerMotion: PlayerMotion) {
        if playerMotion.isOnGround() && playerMotion.isLookingTowardSprite(sprite) {
            playerMotion.speed = 0
            playerMotion.speeds.x = 0
            
            let player = playerMotion.sprite
            player.x = sprite.x - (sprite.width / 2 + player.hitbox.width / 2) * player.direction.value
        }
    }
    
    func actAsWall(sprite: Sprite, characterMotion: CharacterMotion) {
        if characterMotion.state is OnGroundState && characterMotion.sprite.isLookingTowardPoint(sprite) {
            characterMotion.stop()
            
            let player = characterMotion.sprite
            player.x = sprite.x - (sprite.width / 2 + player.hitbox.width / 2) * player.direction.value
        }
    }
    
}

// MARK: - Pushable

protocol Pushable : Collidable {
    // Pas de méthodes.
}

extension Pushable {
    
    func actAsPushable(sprite: Sprite, characterMotion: CharacterMotion) {
        // TODO: Rendre l'objet poussable.
        if characterMotion.state is OnGroundState && characterMotion.sprite.isLookingTowardPoint(sprite) && characterMotion.speed > 0 {
            let player = characterMotion.sprite
            player.x = sprite.x - (sprite.width / 2 + player.hitbox.width / 2) * player.direction.value
            characterMotion.transitionToState("push", withValue: sprite)
        }
    }
    
}

// MARK: - Bad Guy

/// Protocol expérimental pour gérer les méchants en tant que Collidable.
protocol BadGuy : Collidable {
    // Pas de méthodes.
}

extension BadGuy {
    
    func onCollision(sprite: Sprite, playerMotion: PlayerMotion) {
        if playerMotion.jumpType == .Spin {
            Director.audio.playSound(.Explosion)
            playerMotion.bounceFromSprite(sprite)
            sprite.explode()
        } else {
            playerMotion.hitOrDie()
        }
    }
    
}

// MARK: - No Motion

/// Gestionnaire vide, aucun mouvement.
class NoMotion : Motion, Collidable {
    
    static let instance = NoMotion()
    
    func load(sprite: Sprite) {
        // Pas de chargement.
    }
    
    func updateWithTimeSinceLastUpdate(timeSinceLastUpdate: NSTimeInterval, sprite: Sprite) {
        // Pas de mouvement.
    }
    
    func onCollision(sprite: Sprite, playerMotion: PlayerMotion) {
        // Pas de collision.
    }
    
    func onCollision(sprite: Sprite, characterMotion: CharacterMotion) {
        // Pas de collision.
    }
    
}







