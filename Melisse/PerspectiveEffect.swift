//
//  PerspectiveEffect.swift
//  MeltedIce
//
//  Created by Raphaël Calabro on 30/04/2016.
//  Copyright © 2016 Raphaël Calabro. All rights reserved.
//

import GLKit
#if os(iOS)
    import CoreMotion
#endif

struct MotionMetric {
    
    var from: Double
    var to: Double
    
    func valueFor(_ attitude: Double) -> GLfloat {
        let value = GLfloat((attitude - from) / (to - from))
        
        if value <= -1 {
            return -1
        } else if value >= 1 {
            return 1
        } else {
            return value
        }
    }
    
}

public struct PerspectiveEffect {
    
    public var backgroundTilt = Point<GLfloat>()
    public var foregroundTilt = Point<GLfloat>()
    
    #if os(iOS)
    let motionManager = CMMotionManager()
    let verticalMetrics = [UIInterfaceOrientation.landscapeRight: MotionMetric(from: 0.4, to: -1.2),
                           UIInterfaceOrientation.landscapeLeft: MotionMetric(from: -0.3, to: 1.5)]
    let horizontalMetrics = [UIInterfaceOrientation.landscapeRight : MotionMetric(from: -1, to: 1),
                             UIInterfaceOrientation.landscapeLeft : MotionMetric(from: -1, to: 1)]
    #endif
    
    public init() {
        // Public initializer.
    }
    
    public func load() {
        #if os(iOS)
            motionManager.deviceMotionUpdateInterval = 1 / 60
            motionManager.startDeviceMotionUpdates()
        #endif
    }
    
    public func unload() {
        #if os(iOS)
            motionManager.stopDeviceMotionUpdates()
        #endif
    }
    
    mutating public func update() {
        #if os(iOS)
            let tilt: Point<GLfloat>
            if let motion = motionManager.deviceMotion {
                let orientation = UIApplication.shared().statusBarOrientation
                let horizontalMetric = horizontalMetrics[orientation]!
                let verticalMetric = verticalMetrics[orientation]!
                tilt = Point(x: horizontalMetric.valueFor(motion.attitude.pitch), y: verticalMetric.valueFor(motion.attitude.roll))
            } else {
                tilt = Point()
            }
            
            self.backgroundTilt = tilt
            self.foregroundTilt = Point(x: -tilt.x * tileSize / 2, y: -tilt.y * tileSize / 4)
        #endif
    }
    
}
