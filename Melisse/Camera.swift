//
//  Camera.swift
//  MeltedIce
//
//  Created by Raphaël Calabro on 28/06/2015.
//  Copyright (c) 2015 Raphaël Calabro. All rights reserved.
//

import GLKit

public struct Camera {
    
    public var frame: Rectangle<GLfloat>
    
    /// Cadre dans lequel se déplace la caméra.
    public var bounds: Rectangle<GLfloat>
    
    /// Décalage vertical causé par les zoom.
    var offsetY: GLfloat = 0
    
    var motion: CameraMotion = NoCameraMotion()
    
    public var target: Point<GLfloat>? {
        didSet {
            if let target = self.target {
                self.motion = motion.to(LockedCameraMotion(target: target))
            } else {
                self.motion = motion.to(NoCameraMotion())
            }
            self.frame.center = motion.locationFor(&self, timeSinceLastUpdate: 0)
        }
    }
    
    public init() {
        self.frame = Rectangle(size: View.instance.size)
        self.bounds = frame
    }
    
    public mutating func updateWith(timeSinceLastUpdate: NSTimeInterval) {
        let center = motion.locationFor(&self, timeSinceLastUpdate: timeSinceLastUpdate)
        
        frame.x = max(min(center.x, bounds.right - frame.width / 2), bounds.left + frame.width / 2)
        frame.y = max(min(center.y, bounds.bottom - frame.height / 2), bounds.top + frame.height / 2) + offsetY
    }
    
    public mutating func center(width: GLfloat, height: GLfloat) {
        self.frame.center = Point<GLfloat>(x: width / 2, y: height / 2)
    }
    
    public mutating func moveTo(target: Point<GLfloat>, time: NSTimeInterval = 1, onLock: (() -> Void)? = nil) {
        self.motion = motion.to(MovingToTargetCameraMotion(origin: frame.center, target: target, onLock: onLock))
    }
    
    public func isSpriteInView(sprite: Sprite) -> Bool {
        return SimpleHitbox(frame: frame).collidesWith(SimpleHitbox(frame: sprite.frame))
    }
    
    public func removeSpriteIfOutOfView(sprite: Sprite) {
        if !isSpriteInView(sprite) {
            sprite.destroy()
        }
    }

}

protocol CameraMotion {
    
    mutating func locationFor(inout camera: Camera, timeSinceLastUpdate: NSTimeInterval) -> Point<GLfloat>
 
    mutating func to(other: CameraMotion) -> CameraMotion
    
}

struct NoCameraMotion : CameraMotion {
    
    func locationFor(inout camera: Camera, timeSinceLastUpdate: NSTimeInterval) -> Point<GLfloat> {
        return camera.frame.center
    }
    
    func to(other: CameraMotion) -> CameraMotion {
        return other
    }
    
}

struct LockedCameraMotion : CameraMotion {
    
    let target: Point<GLfloat>
    
    func locationFor(inout camera: Camera, timeSinceLastUpdate: NSTimeInterval) -> Point<GLfloat> {
        return target
    }
    
    func to(other: CameraMotion) -> CameraMotion {
        return other
    }
    
}

struct MovingToTargetCameraMotion : CameraMotion {
    
    let origin : Point<GLfloat>
    let target : Point<GLfloat>
    let duration : NSTimeInterval = 1
    var elapsed : NSTimeInterval = 0
    var onLock : (() -> Void)?
    
    init(origin: Point<GLfloat>, target: Point<GLfloat>, onLock: (() -> Void)?) {
        self.origin = Point(point: origin)
        self.target = target
        self.onLock = onLock
    }
    
    mutating func locationFor(inout camera: Camera, timeSinceLastUpdate: NSTimeInterval) -> Point<GLfloat> {
        elapsed += timeSinceLastUpdate
        
        if elapsed >= duration {
            onLock?()
            self.onLock = nil
            self.elapsed = duration
            
            camera.motion = LockedCameraMotion(target: target)
        }
        
        let ratio = GLfloat(elapsed / duration)
        return Point(x: target.x * ratio + origin.x * (1 - ratio), y: target.y * ratio + origin.y * (1 - ratio))
    }
    
    func to(other: CameraMotion) -> CameraMotion {
        return other
    }
    
}

struct EarthquakeCameraMotion : CameraMotion {
    
    var motion: CameraMotion
    let random = Random()
    let amplitude: GLfloat = 4
    
    mutating func locationFor(inout camera: Camera, timeSinceLastUpdate: NSTimeInterval) -> Point<GLfloat> {
        let center = motion.locationFor(&camera, timeSinceLastUpdate: timeSinceLastUpdate)
        return Point(x: center.x + random.next(amplitude) - amplitude / 2, y: center.y + random.next(amplitude) - amplitude / 2)
    }
    
    mutating func to(other: CameraMotion) -> CameraMotion {
        self.motion = other
        return self
    }
    
}

struct TimedEarthquakeCameraMotion : CameraMotion {
    
    var motion: CameraMotion
    let duration: NSTimeInterval
    let random = Random()
    var time: NSTimeInterval = 0
    
    mutating func locationFor(inout camera: Camera, timeSinceLastUpdate: NSTimeInterval) -> Point<GLfloat> {
        self.time += timeSinceLastUpdate
        
        if time >= duration {
            camera.motion.to(motion)
        }
        
        let center = motion.locationFor(&camera, timeSinceLastUpdate: timeSinceLastUpdate)
        let amplitude = smoothStep(0, to: duration, value: time) * 4
        return Point(x: center.x, y: center.y + random.next(amplitude) - amplitude / 2)
    }
    
    mutating func to(other: CameraMotion) -> CameraMotion {
        self.motion = other
        return self
    }
    
}

struct QuakeCameraMotion : CameraMotion {
    
    var motion: CameraMotion
    var amplitude: GLfloat
    let random = Random()
    
    
    mutating func locationFor(inout camera: Camera, timeSinceLastUpdate: NSTimeInterval) -> Point<GLfloat> {
        self.amplitude = max(amplitude - GLfloat(timeSinceLastUpdate * 10), 0)
        
        if amplitude == 0 {
            camera.motion = motion
        }
        
        let center = motion.locationFor(&camera, timeSinceLastUpdate: timeSinceLastUpdate)
        return Point(x: center.x, y: center.y + random.next(amplitude) - amplitude / 2)
    }
    
    mutating func to(other: CameraMotion) -> CameraMotion {
        self.motion = other
        return self
    }
    
}

/*
class TwoPlayerCameraMotion : CameraMotion {
    
    let first : Point<GLfloat>
    let second : Point<GLfloat>
    
    init(first: Point<GLfloat>, second: Point<GLfloat>) {
        self.first = first
        self.second = second
    }
    
    func locationFor(camera: Camera, timeSinceLastUpdate: NSTimeInterval) -> Point {
        let minX, maxX : GLfloat
        if first.x < second.x {
            minX = first.x
            maxX = second.x
        } else {
            minX = second.x
            maxX = first.x
        }
        
        let width = View.instance.width
        
        // TODO: MOINS ZOOMER !
        let center = Point(x: (first.x + second.x) / 2, y: (first.y + second.y) / 2)
        let left = max(min(minX - width / 4, center.x - width / 2), center.x - width * 0.75)
        let right = min(max(maxX + width / 4, center.x + width / 2), center.x + width * 0.75)
        
        Camera.instance.frame.width = right - left
        View.instance.zoom = Camera.instance.frame.width / View.instance.frame.width
        Camera.instance.frame.height = View.instance.zoomedHeight
        View.instance.applyZoom()
        
        Camera.instance.offsetY = (Camera.instance.height - View.instance.height) / 2
        
        return center
    }
    
    func to(other: CameraMotion) -> CameraMotion {
        return self
    }
    
}
*/