//
//  CircularAnimation.swift
//  CircularAnimation
//
//  Created by Ahmed Osama on 3/28/19.
//  Copyright © 2019 Ahmed Osama. All rights reserved.
//  https://github.com/AhmedOS/CircularAnimation

import UIKit

class CircularAnimation {
    
    var views = [UIView]()
    // Views to be animated
    
    var radius: Float = 0
    // Virtual circle radius
    
    var origin = CGPoint(x: 0, y: 0)
    // Virtual circle center
    
    var sourceAngle: Float = 0
    // Angle which views start animating from (ranges from 0 -> 360)
    
    var startAngle: Float = 0
    // The beginning angle which views distribute themselves starting from it (ranges from 0 -> 360)
    
    var degrees: Float = 0
    // Amount of degrees used after the startAngle, positive value -> clockwise, negative -> counterclockwise
    
    var duration: CFTimeInterval = 0
    // Duration of animation for each view in seconds
    
    var delay: Double = 0
    // The delay between animating views
    
    var fullCircle = false
    // Change it to true if the final shape is meant to be a circle
    
    func animate() {
        let sourcePoint = getCGPoint(angle: sourceAngle)
        for i in 0 ..< views.count {
            views[i].center = sourcePoint
            animate(view: views[i], index: i)
        }
    }
    
    fileprivate func animate(view: UIView, index: Int) {
        
        let one: Float = degrees >= 0 ? 1 : -1
        let degreeDiff = abs(degrees) / Float(views.count - (fullCircle ? 0 : 1))
        
        let sourceStartDiff = degreesDiff(a: sourceAngle, b: startAngle, clockwise: degrees >= 0)
        let amount = Double((sourceStartDiff + (degreeDiff * Float(index))) / 0.1)
        let strid = stride(from: 0, to: sourceStartDiff + (degreeDiff * Float(index)), by: 0.1)

        var values = [CGPoint]()
        var keyTimes = [NSNumber]()
        var degreeCount: Double = 0
        var angle = sourceAngle
        for _ in strid {
            if angle < 0 {
                angle = 359.9
            }
            if angle >= 360 {
                angle = 0
            }
            values.append(getCGPoint(angle: angle))
            keyTimes.append(NSNumber(value: degreeCount / amount))
            degreeCount += 1
            angle += 0.1 * one
        }
        
        let animation = CAKeyframeAnimation()
        animation.keyPath = "position"
        animation.values = values
        animation.keyTimes = keyTimes
        animation.duration = duration
        animation.timingFunction = CAMediaTimingFunction(controlPoints: 0.23, 1, 0.32, 1)
        // Quint CAMediaTimingFunction(controlPoints: 0.23, 1, 0.32, 1)
        // Quart CAMediaTimingFunction(controlPoints: 0.165, 0.84, 0.44, 1)
        // Expo CAMediaTimingFunction(controlPoints: 0.19, 1, 0.22, 1)
        // https://gist.github.com/naoyashiga/2673e55a9b5212fd0897
        
        DispatchQueue.main.asyncAfter(deadline: .now() + (delay * Double(views.count - index))) {
            view.layer.position = values.last ?? view.layer.position
            // Change model layer, as animation chnges presentation layer only
            view.layer.add(animation, forKey: "position")
            // Use the name of the animated property as key to override the implicit animation
        }
    }
    
    fileprivate func degreesDiff(a: Float, b: Float, clockwise: Bool) -> Float {
        if clockwise {
            if a <= b {
                return b - a
            }
            else {
                let p1 = 360 - a
                let p2 = b
                return p1 + p2
            }
        }
        else {
            if a >= b {
                return a - b
            }
            else {
                let p1 = a
                let p2 = 360 - b
                return p1 + p2
            }
        }
    }
    
    fileprivate func getCGPoint(angle: Float) -> CGPoint {
        let x = Float(origin.x) + radius * cos(angle / 180 * Float.pi)
        let y = Float(origin.y) + radius * sin(angle / 180 * Float.pi)
        return CGPoint(x: CGFloat(x), y: CGFloat(y))
    }
    
}
