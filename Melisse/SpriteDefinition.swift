//
//  Definition.swift
//  MeltedIce
//
//  Created by Raphaël Calabro on 28/06/2015.
//  Copyright (c) 2015 Raphaël Calabro. All rights reserved.
//

import Foundation

struct SpriteDefinition : Equatable {
    
    let defaultExtension = "sprites"
    
    var name: String?
    var type: SpriteType
    var animations: [Int:AnimationDefinition]
    var motionName: String?
    var distance: Distance
    
    init() {
        self.name = ""
        self.type = DefaultSpriteType.Decoration
        self.animations = [:]
        self.motionName = nil
        self.distance = .Behind
    }
    
    init(type: SpriteType, width: Int, height: Int, animations: [Int:AnimationDefinition]) {
        self.name = ""
        self.type = type
        self.animations = animations
        self.motionName = nil
        self.distance = .Behind
    }
    
    init(definition: SpriteDefinition, type: SpriteType, animation: AnimationName, frame frameIndex: Int) {
        let animation = definition.animations[animation.rawValue]!
        let frame = animation.frames[frameIndex]
        let singleFrameAnimation = AnimationDefinition(frames: [frame])
        
        self.name = ""
        self.type = type
        self.animations = [DefaultAnimationName.Normal.rawValue: singleFrameAnimation]
        self.motionName = nil
        self.distance = definition.distance
    }
    
    init(inputStream : NSInputStream, index: Int, types: [SpriteType] = [], animationNames: [AnimationName] = []) {
        self.name = Streams.readNullableString(inputStream)
        let _ = Streams.readInt(inputStream) // width
        let _ = Streams.readInt(inputStream) // height
        let type = Streams.readInt(inputStream)
        
        if type >= 0 && type < types.count {
            self.type = types[type]
        } else {
            self.type = DefaultSpriteType.Decoration
        }
        
        if let distance = Distance(rawValue: Streams.readInt(inputStream)) {
            self.distance = distance
        } else {
            self.distance = .Behind
        }
        
        self.motionName = Streams.readNullableString(inputStream)
        
        // Animations
        let animationCount = Streams.readInt(inputStream)
        var animations = [Int:AnimationDefinition]()
        
        for index in 0..<animationCount {
            // TODO: Éviter de charger toutes les animations.
            let animation = animationNames[index].rawValue
            animations[animation] = AnimationDefinition(inputStream: inputStream)
        }
        
        self.animations = animations
    }
    
    static func definitionsFromInputStream(inputStream : NSInputStream) -> [SpriteDefinition] {
        var definitions : [SpriteDefinition] = []
        
        let definitionCount = Streams.readInt(inputStream)
        for index in 0..<definitionCount {
            definitions.append(SpriteDefinition(inputStream: inputStream, index: index))
        }
        
        return definitions
    }
    
    static func definitionsFromResource(resource: String) -> [SpriteDefinition]? {
        if let url = NSBundle.mainBundle().URLForResource(resource, withExtension: fileExtension), let inputStream = NSInputStream(URL: url) {
            inputStream.open()
            let definitions = definitionsFromInputStream(inputStream)
            inputStream.close()
            
            return definitions
            
        } else {
            return nil
        }
    }
    
}
