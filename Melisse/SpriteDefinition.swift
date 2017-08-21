//
//  Definition.swift
//  MeltedIce
//
//  Created by Raphaël Calabro on 28/06/2015.
//  Copyright (c) 2015 Raphaël Calabro. All rights reserved.
//

import Foundation

public struct SpriteDefinition : Equatable {
    
    static let defaultExtension = "sprites"
    
    public var index: Int
    public var name: String?
    public var type: SpriteType
    public var animations: [String:AnimationDefinition]
    public var motionName: String?
    public var distance: PoolIndex
    
    public init() {
        self.index = -1
        self.name = ""
        self.type = DefaultSpriteType.decoration
        self.animations = [:]
        self.motionName = nil
        self.distance = Distance.behind
    }
    
    public init(type: SpriteType, width: Int, height: Int, animations: [String:AnimationDefinition]) {
        self.index = -1
        self.name = ""
        self.type = type
        self.animations = animations
        self.motionName = nil
        self.distance = Distance.behind
    }
    
    /// Créé une copie de la définition donnée en ne gardant qu'une seule frame de l'animation donnée en tant qu'animation principale.
    public init(definition: SpriteDefinition, type: SpriteType, animation: AnimationName, frame frameIndex: Int) {
        let animation = definition.animations[animation.name]!
        let frame = animation.frames[frameIndex]
        let singleFrameAnimation = AnimationDefinition(frames: [frame])
        
        self.index = -1
        self.name = ""
        self.type = type
        self.animations = [DefaultAnimationName.normal.name: singleFrameAnimation]
        self.motionName = nil
        self.distance = definition.distance
    }
    
    public init(inputStream : InputStream, index: Int, types: [SpriteType] = [], animationNames: [AnimationName] = []) {
        self.index = index
        self.name = Streams.readNullableString(inputStream)
        let _ = Streams.readInt(inputStream) // width
        let _ = Streams.readInt(inputStream) // height
        let type = Streams.readInt(inputStream)
        
        if type >= 0 && type < types.count {
            self.type = types[type]
        } else {
            self.type = DefaultSpriteType.decoration
        }
        
        if let distance = Distance(rawValue: Streams.readInt(inputStream)) {
            self.distance = distance
        } else {
            self.distance = Distance.behind
        }
        
        self.motionName = Streams.readNullableString(inputStream)
        
        // Animations
        let animationCount = Streams.readInt(inputStream)
        var animations = [String:AnimationDefinition]()
        
        for index in 0..<animationCount {
            // TODO: Éviter de charger toutes les animations.
            let animation = animationNames[index].name
            animations[animation] = AnimationDefinition(inputStream: inputStream)
        }
        
        self.animations = animations
    }
    
    public static func definitionsFrom(_ inputStream : InputStream, types: [SpriteType] = [], animationNames: [AnimationName] = []) -> [SpriteDefinition] {
        var definitions : [SpriteDefinition] = []
        
        let definitionCount = Streams.readInt(inputStream)
        for index in 0..<definitionCount {
            definitions.append(SpriteDefinition(inputStream: inputStream, index: index, types: types, animationNames: animationNames))
        }
        
        return definitions
    }
    
    public static func definitionsFrom(_ resource: String, extension ext: String = defaultExtension, types: [SpriteType] = [], animationNames: [AnimationName] = []) -> [SpriteDefinition]? {
        if let url = Bundle.main.url(forResource: resource, withExtension: ext), let inputStream = InputStream(url: url) {
            inputStream.open()
            let definitions = definitionsFrom(inputStream, types: types, animationNames: animationNames)
            inputStream.close()
            
            return definitions
            
        } else {
            return nil
        }
    }
    
}

public func ==(left: SpriteDefinition, right: SpriteDefinition) -> Bool {
    return left.index == right.index
}
