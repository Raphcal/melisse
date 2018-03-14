//
//  Loader.swift
//  MeltedIce
//
//  Created by Raphaël Calabro on 29/06/2015.
//  Copyright (c) 2015 Raphaël Calabro. All rights reserved.
//

import GLKit

// TODO: Revoir cette classe.

// TODO: Diviser les sprites en grilles de "grandes tailles" (160x160 par exemple -- tester avec des tailles plus petites) et charger les sprites par bloc. Stocker plusieurs sprites par bloc. Charger seulement les blocs visibles (ou dans un champ de vision proche).

// Voir SpriteGrid et Feeder en bas de ce fichier.

/// Charge les sprites en fonction de la position x du joueur.
class Loader {
    
    static let fileExtension = "sprites"
    static let distance : GLfloat = 480
    
    let spriteFactory : SpriteFactory
    let motions : [String : Motion]
    var infos : [SpriteInfo]
    
    var player : Sprite?
    
    var oldX : GLfloat = 0
    var firstIndex : Int = 0
    var lastIndex : Int = 0
    
    init() {
        self.spriteFactory = SpriteFactory()
        self.motions = [:]
        self.infos = []
    }
    
    init(spriteFactory: SpriteFactory, gameScene: GameScene) {
        self.spriteFactory = spriteFactory
        self.infos = []
        self.motions = Loader.motionsWithGameScene(gameScene)
    }
    
    init(inputStream : NSInputStream, spriteFactory : SpriteFactory, gameScene: GameScene, onStartPoint: (_ startPoint: Point) -> ()) {
        self.spriteFactory = spriteFactory
        
        let motions = Loader.motionsWithGameScene(gameScene)
        var infos : [SpriteInfo] = []
        let infoCount = Streams.readInt(inputStream)
        
        for index in 0..<infoCount {
            let info = SpriteInfo(inputStream: inputStream, spriteFactory: spriteFactory, index: index)
            let definition = info.definition
            
            if(definition.type == .Player) {
                onStartPoint(startPoint: Point(x: info.x, y: info.y))
            } else {
                if(definition.type == .Collectable) {
                    info.motion = BubbleMotion.instance
                } else if let motionName = definition.motionScriptFile, let motion = motions[motionName] {
                    info.motion = motion
                } else if definition.type == .Decoration {
                    info.motion = NoMotion.instance
                } else {
                    info.motion = SimplePlatform()
                }
                
                infos.append(info)
            }
        }
        self.infos = infos
        self.motions = motions
    }
    
    convenience init?(resource : String, spriteFactory: SpriteFactory, gameScene: GameScene, onStartPoint: (_ startPoint: Point) -> ()) {
        if let url = NSBundle.mainBundle().URLForResource(resource, withExtension: Loader.fileExtension), let inputStream = NSInputStream(URL: url) {
            inputStream.open()
            self.init(inputStream: inputStream, spriteFactory: spriteFactory, gameScene: gameScene, onStartPoint: onStartPoint)
            inputStream.close()
            
        } else {
            self.init()
            return nil
        }
    }
    
    func loadInfosFromResource(resource: String) {
        if let url = NSBundle.mainBundle().URLForResource(resource, withExtension: Loader.fileExtension), let inputStream = NSInputStream(URL: url) {
            inputStream.open()
            loadInfosFromInputStream(inputStream)
            inputStream.close()
        }
    }
    
    func loadInfosFromInputStream(inputStream: NSInputStream) {
        var infos : [SpriteInfo] = []
        let infoCount = Streams.readInt(inputStream)
        
        for index in 0..<infoCount {
            let info = SpriteInfo(inputStream: inputStream, spriteFactory: spriteFactory, index: index)
            let definition = info.definition
            
            if(definition.type == .Player) {
                let sprite = spriteFactory.sprite(definition, info: info)
                sprite.frame.topLeft = Point(x: info.x, y: info.y)
                self.player = sprite
                
            } else {
                if(definition.type == .Collectable) {
                    info.motion = BubbleMotion.instance
                } else if let motionName = definition.motionScriptFile, let motion = motions[motionName] {
                    info.motion = motion
                } else if definition.type == .Decoration {
                    info.motion = NoMotion.instance
                } else {
                    info.motion = SimplePlatform()
                }
                
                infos.append(info)
            }
        }
        
        self.infos = infos
    }
    
    /// Créé ou supprime les sprites en fonction de la position de la caméra.
    func update(gameScene: GameScene) {
        let left = gameScene.camera.x - Loader.distance
        let right = gameScene.camera.x + Loader.distance
        let comparison = gameScene.camera.x - oldX
        
        if comparison < 0 {
            movedLeft(gameScene, left: left, right: right)
        } else {
            movedRight(gameScene, left: left, right: right)
        }
        
        self.oldX = gameScene.camera.x
    }
    
    /// Recharge tous les sprites.
    func reload(gameScene: GameScene) {
        for info in infos {
            info.releaseSprite(spriteFactory)
            
            if info.reload {
                info.taken = false
            }
        }
        
        self.oldX = 0
        
        self.firstIndex = findLeft()
        self.lastIndex = findRightFrom(firstIndex)
        
        for index in firstIndex..<lastIndex {
            infos[index].createSprite(spriteFactory, gameScene: gameScene)
        }
    }
    
    /// Renvoi les informations des sprites affichés actuellement.
    func visibleInfos() -> [SpriteInfo] {
        var visibleInfos = [SpriteInfo]()
        
        for index in firstIndex..<lastIndex {
            visibleInfos.append(infos[index])
        }
        
        return visibleInfos
    }
    
    private func movedLeft(gameScene: GameScene, left: GLfloat, right: GLfloat) {
        while firstIndex > 0 && infos[firstIndex].x > left {
            infos[firstIndex].createSprite(spriteFactory, gameScene: gameScene)
            #if SHOW_SPRITE_MANAGEMENT
            NSLog("< Création #\(firstIndex) : \(infos[firstIndex].x)")
            #endif
            firstIndex -= 1
        }
        
        self.lastIndex = max(firstIndex, lastIndex)
        
        while lastIndex - 1 > 0 && infos[lastIndex - 1].x >= right {
            infos[lastIndex - 1].releaseSprite(spriteFactory)
            #if SHOW_SPRITE_MANAGEMENT
            NSLog("< Libération #\(lastIndex - 1) : \(infos[lastIndex - 1].x)")
            #endif
            lastIndex -= 1
        }
    }
    
    private func movedRight(gameScene: GameScene, left: GLfloat, right: GLfloat) {
        while firstIndex < infos.count - 1 && infos[firstIndex].x <= left {
            infos[firstIndex].releaseSprite(spriteFactory)
            #if SHOW_SPRITE_MANAGEMENT
            NSLog("> Libération #\(firstIndex) : \(infos[firstIndex].x)")
            #endif
            firstIndex += 1
        }
        
        self.lastIndex = max(firstIndex, lastIndex)
        
        while lastIndex < infos.count && infos[lastIndex].x < right {
            infos[lastIndex].createSprite(spriteFactory, gameScene: gameScene)
            #if SHOW_SPRITE_MANAGEMENT
            NSLog("> Création #\(lastIndex) : \(infos[lastIndex].x)")
            #endif
            lastIndex += 1
        }
    }
    
    private func findLeft() -> Int {
        var index = 0
        let left = gameScene.camera.x - Loader.distance
        
        while index < infos.count && infos[index].x < left {
            index += 1
        }
        
        return index
    }
    
    private func findRightFrom(left: Int) -> Int {
        var index = left
        let right = gameScene.camera.x + Loader.distance
        
        while index < infos.count && infos[index].x < right {
            index += 1
        }
        
        return index
    }
    
    private static func motionsWithGameScene(gameScene: GameScene) -> [String : Motion] {
        // TODO: Instancier les mouvements en fonction du niveau.
        return [
            "tombe.lua" : FallingPlatform.instance,
            "platform-moving.lua" : MovingPlatform.instance,
            "platform-crumbling.lua" : CrumblingPlatform.instance,
            "platform-bridge.lua" : BridgePlatform.instance,
            "platform-rotative.lua" : RotativePlatform(),
            "breakable.lua" : BreakableMotion.instance,
            
            "spike.lua" : SpikeMotion.instance,
            "spike-falling.lua" : FallingSpikeMotion(gameScene: gameScene),
            
            "spring.lua" : SpringMotion.instance,
            "spring-horizontal.lua" : HorizontalSpringMotion.instance,
            
            "chest.lua" : ChestMotion.instance,
            "checkpoint.lua" : CheckpointMotion(gameScene: gameScene),
            "highstriker.lua" : HighStrikerMotion(gameScene: gameScene),
            
            "kyukyu.lua" : KyukyuMotion.instance,
            "penguin.lua" : PenguinMotion.instance,
            "rokettori.lua" : RokettoriMotion(gameScene: gameScene),
            "remolapin.lua" : RemolapinMotion.instance,
            "snowturrel.lua" : SnowTurretMotion(gameScene: gameScene),
            "sled.lua" : SledMotion.instance,
            "boss1.lua" : Boss1Motion.instance,
            
            "wagon.lua" : WagonMotion(),
            "taupe.lua" : TaupeMotion(),
            "mushroom.lua": MushroomMotion(gameScene: gameScene)
        ]
    }
    
}

// MARK: -

