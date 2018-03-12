//
//  DragSensitiveZone.swift
//  Melisse
//
//  Created by Raphaël Calabro on 12/03/2018.
//  Copyright © 2018 Raphaël Calabro. All rights reserved.
//

import GLKit

/// Draggable area.
public class DragSensitiveZone : SensitiveZone {
    
    let sprite: Sprite
    var trackedFinger: UnsafeRawPointer? = nil
    var oldLocation = Point<GLfloat>()
    
    public var translation = Point<GLfloat>()
    public var isDragging: Bool {
        return trackedFinger != nil
    }
    
    public var dragDidEnd: (() -> Void)?
    
    public init() {
        self.sprite = Sprite()
        super.init(hitbox: StaticHitbox(), touches: [:])
    }
    
    public init(sprite: Sprite, touches: [UnsafeRawPointer : Point<GLfloat>] = [:]) {
        self.sprite = sprite
        super.init(hitbox: ScaledSpriteHitbox(sprite: sprite, scale: View.instance.scale), touches: touches)
    }
    
    public override func touchDown(_ touch: UnsafeRawPointer, at location: Point<GLfloat>) {
        if trackedFinger == nil {
            trackedFinger = touch
            translation = Point()
            oldLocation = location * View.instance.scale
        }
    }
    
    public override func touch(_ touch: UnsafeRawPointer, movedTo location: Point<GLfloat>) {
        if touch == trackedFinger || trackedFinger == nil {
            trackedFinger = touch
            let newLocation = location * View.instance.scale
            translation = newLocation - oldLocation
            oldLocation = newLocation
        }
    }
    
    public override func touchUp(_ touch: UnsafeRawPointer, withState state: TouchState) {
        if touch == trackedFinger {
            trackedFinger = nil
            translation = Point()
            oldLocation = Point()
            
            dragDidEnd?()
        }
    }
    
}

fileprivate struct ScaledSpriteHitbox : Hitbox {
    
    var sprite: Sprite
    var scale: Point<GLfloat>
    
    var frame: Rectangle<GLfloat> {
        let frame = sprite.hitbox.frame
        return Rectangle(x: frame.x / scale.x, y: frame.y / scale.y, width: frame.width / scale.x, height: frame.height / scale.y)
    }
    
}
