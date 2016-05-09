//
//  Camera.swift
//  MeltedIce
//
//  Created by Raphaël Calabro on 28/06/2015.
//  Copyright (c) 2015 Raphaël Calabro. All rights reserved.
//

import GLKit

class Camera {
    
    static let instance = Camera()
    static let defaultMoveTime : NSTimeInterval = 1
    
    var frame: Rectangle<GLfloat>
    
    /// Cadre dans lequel se déplace la caméra.
    var bounds: Rectangle<GLfloat>
    
    /// Décalage vertical causé par les zoom.
    var offsetY: GLfloat = 0
    
    var motion : CameraMotion = NoCameraMotion()
    
    var target: Point<GLfloat>? {
        didSet {
            if let target = self.target {
                self.motion = motion.to(LockedCameraMotion(target: target))
            } else {
                self.motion = motion.to(NoCameraMotion())
            }
            self.frame.center = motion.locationWithTimeSinceLastUpdate(0)
        }
    }
    
    init() {
        let width = View.instance.width
        let height = View.instance.height
        self.bounds = Rectangle(left: 0, top: 0, width: width, height: height)
    }
    
    func updateWithTimeSinceLastUpdate(timeSinceLastUpdate: NSTimeInterval) {
        let center = motion.locationWithTimeSinceLastUpdate(timeSinceLastUpdate)
        
        frame.x = max(min(center.x, bounds.right - frame.width / 2), bounds.left + frame.width / 2)
        frame.y = max(min(center.y, bounds.bottom - frame.height / 2), bounds.top + frame.height / 2) + offsetY
    }
    
    func center(width: GLfloat, height: GLfloat) {
        self.frame.center = Point<GLfloat>(x: width / 2, y: height / 2)
    }
    
    func moveTo(target: Point) {
        moveTo(target, time: Camera.defaultMoveTime, onLock: nil);
    }
    
    func moveTo(target: Point, onLock : () -> Void) {
        moveTo(target, time: Camera.defaultMoveTime, onLock: onLock);
    }
    
    func moveTo(target: Point, time: NSTimeInterval, onLock: (() -> Void)?) {
        self.motion = motion.to(MovingToTargetCameraMotion(origin: Camera.instance, target: target, onLock: onLock))
    }
    
    func isSpriteInView(sprite: Sprite) -> Bool {
        return SimpleHitbox(center: self, width: width + sprite.width, height: height + sprite.height).collidesWith(sprite)
    }
    
    func removeSpriteIfOutOfView(sprite: Sprite) {
        if !isSpriteInView(sprite) {
            sprite.destroy()
        }
    }

}

protocol CameraMotion {
    
    func locationWithTimeSinceLastUpdate(timeSinceLastUpdate: NSTimeInterval) -> Point
 
    func to(other: CameraMotion) -> CameraMotion
    
}

class NoCameraMotion : CameraMotion {
    
    func locationWithTimeSinceLastUpdate(timeSinceLastUpdate: NSTimeInterval) -> Point {
        return Camera.instance
    }
    
    func to(other: CameraMotion) -> CameraMotion {
        return other
    }
    
}

class LockedCameraMotion : CameraMotion {
    
    let target : Point
    
    init(target: Point) {
        self.target = target
    }
    
    func locationWithTimeSinceLastUpdate(timeSinceLastUpdate: NSTimeInterval) -> Point {
        return target
    }
    
    func to(other: CameraMotion) -> CameraMotion {
        return other
    }
    
}

class MovingToTargetCameraMotion : CameraMotion {
    
    let origin : Point
    let target : Point
    let duration : NSTimeInterval = 1
    var elapsed : NSTimeInterval = 0
    var onLock : (() -> Void)?
    
    init(origin: Point, target: Point, onLock: (() -> Void)?) {
        self.origin = Point(point: origin)
        self.target = target
        self.onLock = onLock
    }
    
    func locationWithTimeSinceLastUpdate(timeSinceLastUpdate: NSTimeInterval) -> Point {
        self.elapsed += timeSinceLastUpdate
        
        if elapsed >= duration {
            onLock?()
            self.onLock = nil
            self.elapsed = duration
            
            Camera.instance.motion = LockedCameraMotion(target: target)
        }
        
        let ratio = GLfloat(elapsed / duration)
        return Point(x: target.x * ratio + origin.x * (1 - ratio), y: target.y * ratio + origin.y * (1 - ratio))
    }
    
    func to(other: CameraMotion) -> CameraMotion {
        return other
    }
    
}

class EarthquakeCameraMotion : CameraMotion {
    
    var motion : CameraMotion
    let random = Random()
    let amplitude : GLfloat = 4
    
    init() {
        self.motion = Camera.instance.motion
    }
    
    func locationWithTimeSinceLastUpdate(timeSinceLastUpdate: NSTimeInterval) -> Point {
        let center = motion.locationWithTimeSinceLastUpdate(timeSinceLastUpdate)
        return Point(x: center.x + random.next(amplitude) - amplitude / 2, y: center.y + random.next(amplitude) - amplitude / 2)
    }
    
    func to(other: CameraMotion) -> CameraMotion {
        self.motion = other
        return self
    }
    
}

class TimedEarthquakeCameraMotion : CameraMotion {
    
    let random = Random()
    let duration : NSTimeInterval
    var time : NSTimeInterval = 0
    var motion : CameraMotion
    
    init(duration: NSTimeInterval) {
        self.duration = duration
        self.motion = Camera.instance.motion
    }
    
    func locationWithTimeSinceLastUpdate(timeSinceLastUpdate: NSTimeInterval) -> Point {
        self.time += timeSinceLastUpdate
        
        if time >= duration {
            Camera.instance.motion = motion
        }
        
        let center = motion.locationWithTimeSinceLastUpdate(timeSinceLastUpdate)
        let amplitude = smoothStep(0, to: duration, value: time) * 4
        return Point(x: center.x, y: center.y + random.next(amplitude) - amplitude / 2)
    }
    
    func to(other: CameraMotion) -> CameraMotion {
        self.motion = other
        return self
    }
    
}

class QuakeCameraMotion : CameraMotion {
    
    let random = Random()
    var amplitude : GLfloat
    var motion : CameraMotion
    
    init(amplitude: GLfloat) {
        self.amplitude = amplitude
        self.motion = Camera.instance.motion
    }
    
    func locationWithTimeSinceLastUpdate(timeSinceLastUpdate: NSTimeInterval) -> Point {
        self.amplitude = max(amplitude - GLfloat(timeSinceLastUpdate * 10), 0)
        
        if amplitude == 0 {
            Camera.instance.motion = motion
        }
        
        let center = motion.locationWithTimeSinceLastUpdate(timeSinceLastUpdate)
        return Point(x: center.x, y: center.y + random.next(amplitude) - amplitude / 2)
    }
    
    func to(other: CameraMotion) -> CameraMotion {
        self.motion = other
        return self
    }
    
}

class TwoPlayerCameraMotion : CameraMotion {
    
    let first : Point
    let second : Point
    
    init(first: Point, second: Point) {
        self.first = first
        self.second = second
    }
    
    func locationWithTimeSinceLastUpdate(timeSinceLastUpdate: NSTimeInterval) -> Point {
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
        
        Camera.instance.width = right - left
        View.instance.zoom = Camera.instance.width / View.instance.width
        Camera.instance.height = View.instance.zoomedHeight
        View.instance.applyZoom()
        
        Camera.instance.offsetY = (Camera.instance.height - View.instance.height) / 2
        
        return center
    }
    
    func to(other: CameraMotion) -> CameraMotion {
        return self
    }
    
}
